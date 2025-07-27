import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/user.dart';
import '../../../models/annonce.dart';
import '../../../services/user_service_mock.dart';
import '../../../services/annonce_service_mock.dart';
import '../../../services/auth_service_mock.dart';
import '../../../services/utils_service_mock.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final UserServiceMock _userService = Get.find<UserServiceMock>();
  final AnnonceServiceMock _annonceService = Get.find<AnnonceServiceMock>();
  final AuthServiceMock _authService = Get.find<AuthServiceMock>();
  final UtilsServiceMock _utilsService = Get.find<UtilsServiceMock>();
  final AuthController _authController = Get.find<AuthController>();

  // Observables
  final isLoading = false.obs;
  final isSaving = false.obs;
  final statistiques = <String, dynamic>{}.obs;

  // Form fields
  final prenomController = ''.obs;
  final nomController = ''.obs;
  final emailController = ''.obs;
  final regionController = ''.obs;
  final communeController = ''.obs;
  final currentPasswordController = ''.obs;
  final newPasswordController = ''.obs;
  final confirmPasswordController = ''.obs;

  // Validation
  final profileFormValid = false.obs;
  final passwordFormValid = false.obs;

  // UI State
  final isEditingProfile = false.obs;
  final isChangingPassword = false.obs;
  final showStatistics = false.obs;

  // Données pour les formulaires
  final regions = <String>[].obs;
  final communes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProfile();
    _setupValidation();
    _loadRegions();

    if (_authController.isProprietaire) {
      loadStatistiques();
    }
  }

  void _initializeProfile() {
    final user = _authController.currentUser.value;
    if (user != null) {
      prenomController.value = user.prenom;
      nomController.value = user.nom;
      emailController.value = user.email;
      regionController.value = user.region ?? '';
      communeController.value = user.commune ?? '';

      if (user.region != null) {
        _loadCommunesByRegion(user.region!);
      }
    }
  }

  void _setupValidation() {
    // Validation du formulaire de profil
    ever(prenomController, (_) => _validateProfileForm());
    ever(nomController, (_) => _validateProfileForm());
    ever(emailController, (_) => _validateProfileForm());

    // Validation du formulaire de mot de passe
    ever(currentPasswordController, (_) => _validatePasswordForm());
    ever(newPasswordController, (_) => _validatePasswordForm());
    ever(confirmPasswordController, (_) => _validatePasswordForm());
  }

  void _validateProfileForm() {
    profileFormValid.value =
        prenomController.value.isNotEmpty &&
        nomController.value.isNotEmpty &&
        emailController.value.isNotEmpty &&
        GetUtils.isEmail(emailController.value);
  }

  void _validatePasswordForm() {
    passwordFormValid.value =
        currentPasswordController.value.isNotEmpty &&
        newPasswordController.value.isNotEmpty &&
        newPasswordController.value.length >= 6 &&
        confirmPasswordController.value.isNotEmpty &&
        newPasswordController.value == confirmPasswordController.value;
  }

  Future<void> updateProfile() async {
    if (!profileFormValid.value) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs correctement');
      return;
    }

    isSaving.value = true;

    try {
      final userData = {
        'prenom': prenomController.value,
        'nom': nomController.value,
        'email': emailController.value,
        'region': regionController.value,
        'commune': communeController.value,
      };

      final result = await _userService.updateProfile(
        _authController.currentUser.value!.id,
        userData,
      );

      if (result['success']) {
        // Mettre à jour l'utilisateur dans AuthController
        final updatedUser = User.fromJson(result['data']);
        _authController.currentUser.value = updatedUser;

        isEditingProfile.value = false;
        Get.snackbar('Succès', result['message']);
      } else {
        Get.snackbar('Erreur', result['message']);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la mise à jour du profil');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> changePassword() async {
    if (!passwordFormValid.value) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs correctement');
      return;
    }

    isSaving.value = true;

    try {
      // Pour le mock, on simule juste la validation du mot de passe actuel
      final currentUser = _authController.currentUser.value!;
      if (currentPasswordController.value != currentUser.password) {
        Get.snackbar('Erreur', 'Mot de passe actuel incorrect');
        isSaving.value = false;
        return;
      }

      // Simuler la mise à jour du mot de passe
      await Future.delayed(Duration(seconds: 1));

      _clearPasswordForm();
      isChangingPassword.value = false;
      Get.snackbar('Succès', 'Mot de passe modifié avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la modification du mot de passe');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> loadStatistiques() async {
    if (!_authController.isProprietaire) return;

    isLoading.value = true;

    try {
      final result = await _userService.getUserStatistics(
        _authController.currentUser.value!.id,
      );

      if (result['success']) {
        statistiques.value = result['data'];
        showStatistics.value = true;
      } else {
        Get.snackbar('Erreur', result['message']);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors du chargement des statistiques');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadRegions() async {
    try {
      final result = await _utilsService.getRegions();
      if (result['success']) {
        regions.value = List<String>.from(result['data']);
      }
    } catch (e) {
      print('Erreur lors du chargement des régions: $e');
    }
  }

  Future<void> _loadCommunesByRegion(String region) async {
    communes.clear();

    if (region.isNotEmpty) {
      try {
        final result = await _utilsService.getCommunesByRegion(region);
        if (result['success']) {
          communes.value = List<String>.from(result['data']);
        }
      } catch (e) {
        print('Erreur lors du chargement des communes: $e');
      }
    }
  }

  void onRegionChanged(String region) {
    regionController.value = region;
    communeController.value = '';
    _loadCommunesByRegion(region);
  }

  void startEditingProfile() {
    isEditingProfile.value = true;
  }

  void cancelEditingProfile() {
    isEditingProfile.value = false;
    _initializeProfile(); // Restaurer les valeurs originales
  }

  void startChangingPassword() {
    isChangingPassword.value = true;
    _clearPasswordForm();
  }

  void cancelChangingPassword() {
    isChangingPassword.value = false;
    _clearPasswordForm();
  }

  void _clearPasswordForm() {
    currentPasswordController.value = '';
    newPasswordController.value = '';
    confirmPasswordController.value = '';
  }

  void logout() {
    _authController.logout();
  }

  void deleteAccount() async {
    // Cette méthode sera gérée dans la vue
    Get.snackbar('Compte supprimé', 'Votre compte a été supprimé');
    _authController.logout();
  }

  // Getters utiles
  User? get currentUser => _authController.currentUser.value;

  bool get isProprietaire => _authController.isProprietaire;

  String get userInitials {
    final user = currentUser;
    if (user != null) {
      return '${user.prenom[0]}${user.nom[0]}'.toUpperCase();
    }
    return 'U';
  }

  int get totalAnnonces => statistiques['totalAnnonces'] ?? 0;
  int get totalVues => statistiques['totalVues'] ?? 0;
  int get moyenneVues => statistiques['moyenneVues'] ?? 0;
}
