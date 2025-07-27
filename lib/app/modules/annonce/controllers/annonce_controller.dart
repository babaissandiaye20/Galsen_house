import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../models/annonce.dart';
import '../../../models/photo.dart';
import '../../../models/user.dart';
import '../../../services/annonce_service_mock.dart';
import '../../../services/photo_service_mock.dart';
import '../../../services/user_service_mock.dart';
import '../../../services/utils_service_mock.dart';
import '../../../services/auth_service_mock.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../utils/snackbar_utils.dart';

class AnnonceController extends GetxController {
  final AnnonceServiceMock _annonceService = Get.find<AnnonceServiceMock>();
  final PhotoServiceMock _photoService = Get.find<PhotoServiceMock>();
  final UserServiceMock _userService = Get.find<UserServiceMock>();
  final UtilsServiceMock _utilsService = Get.find<UtilsServiceMock>();
  final AuthController _authController = Get.find<AuthController>();

  // Observables
  final isLoading = false.obs;
  final isSaving = false.obs;
  final currentAnnonce = Rxn<Annonce>();
  final mesAnnonces = <Annonce>[].obs;
  final selectedPhotos = <XFile>[].obs;
  final currentPhotoIndex = 0.obs;

  // Form fields
  final titreController = ''.obs;
  final descriptionController = ''.obs;
  final prixController = ''.obs;
  final modalitesPaiementController = ''.obs;
  final selectedTypeLogement = Rxn<TypeLogement>();
  final regionController = ''.obs;
  final communeController = ''.obs;
  final adresseController = ''.obs;
  final nombreChambresController = '1'.obs;

  // Validation
  final formValid = false.obs;

  // UI State
  final isEditing = false.obs;
  final showImagePicker = false.obs;

  // Données pour les formulaires
  final regions = <String>[].obs;
  final communes = <String>[].obs;
  final typeLogements = TypeLogement.values.obs;

  @override
  void onInit() {
    super.onInit();
    _setupValidation();
    _loadRegions();

    // Charger les annonces du propriétaire si connecté
    if (_authController.isProprietaire) {
      loadMesAnnonces();
    }
  }

  void _setupValidation() {
    ever(titreController, (_) => _validateForm());
    ever(descriptionController, (_) => _validateForm());
    ever(prixController, (_) => _validateForm());
    ever(modalitesPaiementController, (_) => _validateForm());
    ever(selectedTypeLogement, (_) => _validateForm());
    ever(regionController, (_) => _validateForm());
    ever(communeController, (_) => _validateForm());
    ever(adresseController, (_) => _validateForm());
    ever(nombreChambresController, (_) => _validateForm());
  }

  void _validateForm() {
    formValid.value =
        titreController.value.isNotEmpty &&
        descriptionController.value.isNotEmpty &&
        prixController.value.isNotEmpty &&
        double.tryParse(prixController.value) != null &&
        modalitesPaiementController.value.isNotEmpty &&
        selectedTypeLogement.value != null &&
        regionController.value.isNotEmpty &&
        communeController.value.isNotEmpty &&
        adresseController.value.isNotEmpty &&
        int.tryParse(nombreChambresController.value) != null;
  }

  Future<void> loadAnnonceDetail(int annonceId) async {
    isLoading.value = true;

    try {
      final result = await _annonceService.getAnnonceById(annonceId);

      if (result['success']) {
        currentAnnonce.value = Annonce.fromJson(result['data']);
      } else {
        Get.snackbar('Erreur', result['message']);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors du chargement de l\'annonce');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMesAnnonces() async {
    if (!_authController.isProprietaire) return;

    isLoading.value = true;

    try {
      final result = await _annonceService.getAnnoncesByProprietaire(
        _authController.currentUser.value!.id,
      );

      if (result['success']) {
        mesAnnonces.value =
            (result['data'] as List)
                .map((json) => Annonce.fromJson(json))
                .toList();
      } else {
        Get.snackbar('Erreur', result['message']);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors du chargement de vos annonces');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAnnonce() async {
    if (!formValid.value) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs correctement');
      return;
    }

    isSaving.value = true;

    try {
      final annonceData = {
        'titre': titreController.value,
        'description': descriptionController.value,
        'prix': double.parse(prixController.value),
        'modalitesPaiement': modalitesPaiementController.value,
        'typeLogement': selectedTypeLogement.value!.toString().split('.').last,
        'region': regionController.value,
        'commune': communeController.value,
        'adresse': adresseController.value,
        'nombreChambres': int.parse(nombreChambresController.value),
        'proprietaireId': _authController.currentUser.value!.id,
      };

      final result = await _annonceService.createAnnonce(annonceData);

      if (result['success']) {
        Get.snackbar('Succès', result['message']);
        _clearForm();
        await loadMesAnnonces();
        Get.back();
      } else {
        Get.snackbar('Erreur', result['message']);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la création de l\'annonce');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateAnnonce(int annonceId) async {
    if (!formValid.value) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs correctement');
      return;
    }

    isSaving.value = true;

    try {
      final annonceData = {
        'titre': titreController.value,
        'description': descriptionController.value,
        'prix': double.parse(prixController.value),
        'modalitesPaiement': modalitesPaiementController.value,
        'typeLogement': selectedTypeLogement.value!.toString().split('.').last,
        'region': regionController.value,
        'commune': communeController.value,
        'adresse': adresseController.value,
        'nombreChambres': int.parse(nombreChambresController.value),
      };

      final result = await _annonceService.updateAnnonce(
        annonceId,
        annonceData,
      );

      if (result['success']) {
        Get.snackbar('Succès', result['message']);
        await loadMesAnnonces();
        Get.back();
      } else {
        Get.snackbar('Erreur', result['message']);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la mise à jour de l\'annonce');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteAnnonce(int annonceId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer cette annonce ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isLoading.value = true;

    try {
      final result = await _annonceService.deleteAnnonce(annonceId);

      if (result['success']) {
        Get.snackbar('Succès', result['message']);
        await loadMesAnnonces();
      } else {
        Get.snackbar('Erreur', result['message']);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la suppression de l\'annonce');
    } finally {
      isLoading.value = false;
    }
  }

  void editAnnonce(Annonce annonce) {
    isEditing.value = true;
    currentAnnonce.value = annonce;

    // Remplir le formulaire avec les données de l'annonce
    titreController.value = annonce.titre;
    descriptionController.value = annonce.description;
    prixController.value = annonce.prix.toString();
    modalitesPaiementController.value = annonce.modalitesPaiement;
    selectedTypeLogement.value = annonce.typeLogement;
    regionController.value = annonce.region;
    communeController.value = annonce.commune;
    adresseController.value = annonce.adresse;
    nombreChambresController.value = annonce.nombreChambres.toString();

    // Charger les communes pour la région sélectionnée
    _onRegionChanged();

    Get.toNamed('/annonce/form');
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

  Future<void> _onRegionChanged() async {
    communeController.value = '';
    communes.clear();

    if (regionController.value.isNotEmpty) {
      try {
        final result = await _utilsService.getCommunes(regionController.value);
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
    _onRegionChanged();
  }

  // Gestion des photos
  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        selectedPhotos.addAll(images);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la sélection des images');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        selectedPhotos.add(image);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la prise de photo');
    }
  }

  void removePhoto(int index) {
    selectedPhotos.removeAt(index);
  }

  void setCurrentPhotoIndex(int index) {
    currentPhotoIndex.value = index;
  }

  void nextPhoto() {
    if (currentAnnonce.value != null &&
        currentPhotoIndex.value < currentAnnonce.value!.photos.length - 1) {
      currentPhotoIndex.value++;
    }
  }

  void previousPhoto() {
    if (currentPhotoIndex.value > 0) {
      currentPhotoIndex.value--;
    }
  }

  void _clearForm() {
    titreController.value = '';
    descriptionController.value = '';
    prixController.value = '';
    modalitesPaiementController.value = '';
    selectedTypeLogement.value = null;
    regionController.value = '';
    communeController.value = '';
    adresseController.value = '';
    nombreChambresController.value = '1';
    selectedPhotos.clear();
    communes.clear();
    isEditing.value = false;
    currentAnnonce.value = null;
  }

  void startNewAnnonce() {
    _clearForm();
    Get.toNamed('/annonce/form');
  }

  // Actions de contact
  void contactProprietaire(Annonce annonce) {
    final telephone = annonce.proprietaire.telephone;
    final email = annonce.proprietaire.email;

    if (telephone == null || telephone.isEmpty) {
      SnackbarUtils.showError('Erreur', 'Numéro de téléphone non disponible');
      return;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contacter ${annonce.proprietaire.fullName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Appeler'),
              subtitle: Text(telephone),
              onTap: () => makePhoneCall(telephone),
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Color(0xFF25D366)),
              title: const Text('WhatsApp'),
              subtitle: Text(telephone),
              onTap: () => openWhatsApp(telephone, annonce),
            ),
            if (email.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text('Email'),
                subtitle: Text(email),
                onTap: () => sendEmail(email),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> makePhoneCall(String phone) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        Get.back();
        SnackbarUtils.showSuccess('Appel', 'Ouverture de l\'appel vers $phone');
      } else {
        SnackbarUtils.showError('Erreur', 'Impossible d\'ouvrir l\'appel');
      }
    } catch (e) {
      SnackbarUtils.showError(
        'Erreur',
        'Erreur lors de l\'ouverture de l\'appel',
      );
    }
  }

  Future<void> openWhatsApp(String phone, Annonce annonce) async {
    try {
      // Nettoyer le numéro de téléphone (enlever les espaces et caractères spéciaux)
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

      // Créer le message WhatsApp avec les détails de l'annonce
      String message = '''
🏠 *${annonce.titre}*

Bonjour ${annonce.proprietaire.prenom},

Je suis intéressé(e) par votre annonce immobilière.

💰 *Prix :* ${annonce.prixFormate}
📍 *Localisation :* ${annonce.commune}, ${annonce.region}
🛏️ *Chambres :* ${annonce.nombreChambres}
🏢 *Type :* ${annonce.typeLogementDisplay}

Pouvez-vous me donner plus d'informations sur cette propriété ?

Merci !
''';

      // Si il y a une photo, télécharger et partager avec photo
      if (annonce.photos.isNotEmpty) {
        SnackbarUtils.showInfo(
          'Préparation',
          'Préparation du partage avec photo...',
        );

        final firstPhoto = annonce.photos.first;

        // Télécharger l'image
        final response = await http.get(Uri.parse(firstPhoto.url));
        if (response.statusCode != 200) {
          throw Exception('Impossible de télécharger l\'image');
        }

        // Sauvegarder l'image temporairement
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/annonce_whatsapp.jpg');
        await file.writeAsBytes(response.bodyBytes);

        // Partager l'image avec le message via WhatsApp
        await Share.shareXFiles(
          [XFile(file.path)],
          text: message,
          subject: 'Annonce immobilière : ${annonce.titre}',
        );

        Get.back();
        SnackbarUtils.showSuccess('WhatsApp', 'Partage avec photo envoyé');
      } else {
        // Si pas de photo, utiliser l'ancienne méthode
        final Uri whatsappUri = Uri.parse(
          'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}',
        );

        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        Get.back();
        SnackbarUtils.showSuccess('WhatsApp', 'Ouverture de WhatsApp');
      }
    } catch (e) {
      // En cas d'erreur, proposer d'installer WhatsApp
      final bool installWhatsApp =
          await Get.dialog<bool>(
            AlertDialog(
              title: const Text('WhatsApp non trouvé'),
              content: const Text(
                'WhatsApp n\'est pas installé sur votre appareil. Voulez-vous l\'installer ?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Installer'),
                ),
              ],
            ),
          ) ??
          false;

      if (installWhatsApp) {
        final Uri playStoreUri = Uri.parse(
          'https://play.google.com/store/apps/details?id=com.whatsapp',
        );
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  // Nouvelle méthode pour partager avec photo
  Future<void> shareAnnonceWithPhoto(Annonce annonce) async {
    try {
      if (annonce.photos.isEmpty) {
        SnackbarUtils.showError(
          'Erreur',
          'Aucune photo disponible pour le partage',
        );
        return;
      }

      final firstPhoto = annonce.photos.first;

      // Télécharger l'image
      SnackbarUtils.showInfo('Téléchargement', 'Téléchargement de la photo...');

      final response = await http.get(Uri.parse(firstPhoto.url));
      if (response.statusCode != 200) {
        throw Exception('Impossible de télécharger l\'image');
      }

      // Sauvegarder l'image temporairement
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/annonce_photo.jpg');
      await file.writeAsBytes(response.bodyBytes);

      final message = '''
🏠 *${annonce.titre}*

💰 Prix : ${annonce.prixFormate}
📍 Localisation : ${annonce.commune}, ${annonce.region}
🛏️ Chambres : ${annonce.nombreChambres}
🏢 Type : ${annonce.typeLogementDisplay}

Découvrez cette annonce sur notre application !
''';

      // Partager l'image avec le message
      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
        subject: 'Annonce immobilière : ${annonce.titre}',
      );

      SnackbarUtils.showSuccess('Partage', 'Partage de l\'annonce avec photo');
    } catch (e) {
      SnackbarUtils.showError('Erreur', 'Erreur lors du partage : $e');
    }
  }

  Future<void> sendEmail(String email) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        query:
            'subject=Intérêt pour votre annonce&body=Bonjour, je suis intéressé par votre annonce.',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        Get.back();
        SnackbarUtils.showSuccess('Email', 'Ouverture de l\'email');
      } else {
        SnackbarUtils.showError('Erreur', 'Impossible d\'ouvrir l\'email');
      }
    } catch (e) {
      SnackbarUtils.showError(
        'Erreur',
        'Erreur lors de l\'ouverture de l\'email',
      );
    }
  }
}
