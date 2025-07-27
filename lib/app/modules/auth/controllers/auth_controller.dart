import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/user.dart';
import '../../../services/auth_service_mock.dart';

class AuthController extends GetxController {
  final AuthServiceMock _authService = Get.find<AuthServiceMock>();

  // Observables
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();
  final token = ''.obs;

  // Form controllers
  final loginEmailController = ''.obs;
  final loginPasswordController = ''.obs;
  final registerPrenomController = ''.obs;
  final registerNomController = ''.obs;
  final registerEmailController = ''.obs;
  final registerPasswordController = ''.obs;
  final registerConfirmPasswordController = ''.obs;
  final registerRegionController = ''.obs;
  final registerCommuneController = ''.obs;
  final registerRoleController = 'CLIENT'.obs;

  // Validation
  final loginFormValid = false.obs;
  final registerFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
    _setupValidation();
  }

  void _setupValidation() {
    // Validation du formulaire de connexion
    ever(loginEmailController, (_) => _validateLoginForm());
    ever(loginPasswordController, (_) => _validateLoginForm());

    // Validation du formulaire d'inscription
    ever(registerPrenomController, (_) => _validateRegisterForm());
    ever(registerNomController, (_) => _validateRegisterForm());
    ever(registerEmailController, (_) => _validateRegisterForm());
    ever(registerPasswordController, (_) => _validateRegisterForm());
    ever(registerConfirmPasswordController, (_) => _validateRegisterForm());
  }

  void _validateLoginForm() {
    final emailValid =
        loginEmailController.value.isNotEmpty &&
        GetUtils.isEmail(loginEmailController.value);
    final passwordValid = loginPasswordController.value.isNotEmpty;

    print('Email: "${loginEmailController.value}" - Valid: $emailValid');
    print(
      'Password: "${loginPasswordController.value}" - Valid: $passwordValid',
    );

    loginFormValid.value = emailValid && passwordValid;
    print('Form valid: ${loginFormValid.value}');
  }

  void _validateRegisterForm() {
    registerFormValid.value =
        registerPrenomController.value.isNotEmpty &&
        registerNomController.value.isNotEmpty &&
        registerEmailController.value.isNotEmpty &&
        registerPasswordController.value.isNotEmpty &&
        registerConfirmPasswordController.value.isNotEmpty &&
        GetUtils.isEmail(registerEmailController.value) &&
        registerPasswordController.value.length >= 6 &&
        registerPasswordController.value ==
            registerConfirmPasswordController.value;
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');
      final savedUserJson = prefs.getString('current_user');

      if (savedToken != null && savedUserJson != null) {
        token.value = savedToken;
        // Ici, vous pourriez valider le token avec le backend
        // Pour le mock, on assume que le token est valide
        isLoggedIn.value = true;
        // currentUser.value = User.fromJson(jsonDecode(savedUserJson));
      }
    } catch (e) {
      print('Erreur lors de la vérification du statut d\'authentification: $e');
    }
  }

  Future<void> login() async {
    if (!loginFormValid.value) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs correctement');
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authService.login(
        loginEmailController.value,
        loginPasswordController.value,
      );

      if (result['success']) {
        // Sauvegarder les données d'authentification
        await _saveAuthData(result['token'], result['user']);

        // Mettre à jour l'état
        token.value = result['token'];
        currentUser.value = result['user']; // L'objet User est déjà retourné
        isLoggedIn.value = true;

        // Nettoyer les champs
        _clearLoginForm();

        // Naviguer vers l'accueil
        Get.offAllNamed('/home');

        Get.snackbar(
          'Succès',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Erreur',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors de la connexion');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormValid.value) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs correctement');
      return;
    }

    isLoading.value = true;

    try {
      final userData = {
        'prenom': registerPrenomController.value,
        'nom': registerNomController.value,
        'email': registerEmailController.value,
        'password': registerPasswordController.value,
        'region': registerRegionController.value,
        'commune': registerCommuneController.value,
        'role': registerRoleController.value,
      };

      final result = await _authService.register(userData);

      if (result['success']) {
        // Sauvegarder les données d'authentification
        await _saveAuthData(result['token'], result['user']);

        // Mettre à jour l'état
        token.value = result['token'];
        currentUser.value = result['user']; // L'objet User est déjà retourné
        isLoggedIn.value = true;

        // Nettoyer les champs
        _clearRegisterForm();

        // Naviguer vers l'accueil
        Get.offAllNamed('/home');

        Get.snackbar(
          'Succès',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Erreur',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors de l\'inscription');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Supprimer les données sauvegardées
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('current_user');

      // Réinitialiser l'état
      token.value = '';
      currentUser.value = null;
      isLoggedIn.value = false;

      // Naviguer vers la page de connexion
      Get.offAllNamed('/login');

      Get.snackbar('Déconnexion', 'Vous avez été déconnecté avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la déconnexion');
    }
  }

  Future<void> _saveAuthData(String authToken, User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authToken);
      await prefs.setString('current_user', jsonEncode(user.toJson()));
    } catch (e) {
      print('Erreur lors de la sauvegarde des données d\'authentification: $e');
    }
  }

  void _clearLoginForm() {
    loginEmailController.value = '';
    loginPasswordController.value = '';
  }

  void _clearRegisterForm() {
    registerPrenomController.value = '';
    registerNomController.value = '';
    registerEmailController.value = '';
    registerPasswordController.value = '';
    registerConfirmPasswordController.value = '';
    registerRegionController.value = '';
    registerCommuneController.value = '';
    registerRoleController.value = 'CLIENT';
  }

  // Getters utiles
  bool get isProprietaire => currentUser.value?.isProprietaire ?? false;
  bool get isClient => currentUser.value?.isClient ?? false;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;

  String get userFullName => currentUser.value?.fullName ?? '';
  String get userEmail => currentUser.value?.email ?? '';
}
