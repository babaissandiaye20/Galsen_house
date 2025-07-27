import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/annonce_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/components/custom_text_field.dart';
import '../../../widgets/components/custom_button.dart';
import '../../../widgets/components/loading_widget.dart';
import '../../../models/annonce.dart';

class AnnonceFormView extends GetView<AnnonceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditing.value
                ? 'Modifier l\'annonce'
                : 'Nouvelle annonce',
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Chargement...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormHeader(),
              const SizedBox(height: 20),
              _buildBasicInfoSection(),
              const SizedBox(height: 20),
              _buildLocationSection(),
              const SizedBox(height: 20),
              _buildDetailsSection(),
              const SizedBox(height: 20),
              _buildPhotosSection(),
              const SizedBox(height: 20),
              _buildPaymentSection(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                controller.isEditing.value ? Icons.edit : Icons.add_home,
                color: AppTheme.primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.isEditing.value
                      ? 'Modifiez les informations de votre annonce'
                      : 'Créez votre annonce immobilière',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            controller.isEditing.value
                ? 'Mettez à jour les détails pour attirer plus de clients'
                : 'Remplissez tous les champs pour créer une annonce attractive',
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection('Informations de base', Icons.info_outline, [
      Obx(
        () => CustomTextField(
          label: 'Titre de l\'annonce *',
          hint: 'Ex: Villa moderne avec piscine',
          initialValue: controller.titreController.value,
          onChanged: (value) => controller.titreController.value = value,
          validator: Validators.required,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),

      const SizedBox(height: 16),

      Obx(
        () => MultilineTextField(
          label: 'Description *',
          hint: 'Décrivez votre propriété en détail...',
          controller: TextEditingController(
            text: controller.descriptionController.value,
          )..addListener(
            () =>
                controller.descriptionController.value =
                    TextEditingController(
                      text: controller.descriptionController.value,
                    ).text,
          ),
          onChanged: (value) => controller.descriptionController.value = value,
          validator: Validators.required,
          maxLines: 4,
          maxLength: 1000,
        ),
      ),

      const SizedBox(height: 16),

      Obx(
        () => CustomDropdown<TypeLogement>(
          label: 'Type de logement *',
          hint: 'Sélectionnez le type',
          value: controller.selectedTypeLogement.value,
          items:
              controller.typeLogements
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getTypeLogementDisplay(type)),
                    ),
                  )
                  .toList(),
          onChanged: (value) => controller.selectedTypeLogement.value = value,
        ),
      ),
    ]);
  }

  Widget _buildLocationSection() {
    return _buildSection('Localisation', Icons.location_on_outlined, [
      Row(
        children: [
          Expanded(
            child: Obx(
              () => CustomDropdown<String>(
                label: 'Région *',
                hint: 'Sélectionnez la région',
                value:
                    controller.regionController.value.isEmpty
                        ? null
                        : controller.regionController.value,
                items:
                    controller.regions
                        .map(
                          (region) => DropdownMenuItem(
                            value: region,
                            child: Text(region),
                          ),
                        )
                        .toList(),
                onChanged: (value) => controller.onRegionChanged(value ?? ''),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(
              () => CustomDropdown<String>(
                label: 'Commune *',
                hint: 'Sélectionnez la commune',
                value:
                    controller.communeController.value.isEmpty
                        ? null
                        : controller.communeController.value,
                items:
                    controller.communes
                        .map(
                          (commune) => DropdownMenuItem(
                            value: commune,
                            child: Text(commune),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => controller.communeController.value = value ?? '',
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 16),

      Obx(
        () => CustomTextField(
          label: 'Adresse complète *',
          hint: 'Ex: Rue 15, Quartier Almadies',
          initialValue: controller.adresseController.value,
          onChanged: (value) => controller.adresseController.value = value,
          validator: Validators.required,
          textCapitalization: TextCapitalization.words,
        ),
      ),
    ]);
  }

  Widget _buildDetailsSection() {
    return _buildSection('Détails du logement', Icons.home_outlined, [
      Row(
        children: [
          Expanded(
            child: Obx(
              () => PriceTextField(
                label: 'Prix (FCFA) *',
                hint: 'Ex: 25000000',
                controller: TextEditingController(
                  text: controller.prixController.value,
                )..addListener(
                  () =>
                      controller.prixController.value =
                          TextEditingController(
                            text: controller.prixController.value,
                          ).text,
                ),
                onChanged: (value) => controller.prixController.value = value,
                validator: Validators.price,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(
              () => CustomTextField(
                label: 'Nombre de chambres *',
                hint: 'Ex: 3',
                initialValue: controller.nombreChambresController.value,
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        controller.nombreChambresController.value = value,
                validator: Validators.number,
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildPhotosSection() {
    return _buildSection('Photos', Icons.photo_camera_outlined, [
      const Text(
        'Ajoutez des photos pour rendre votre annonce plus attractive',
        style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
      ),

      const SizedBox(height: 16),

      // Boutons d'ajout de photos
      Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Galerie',
              type: ButtonType.outline,
              icon: Icons.photo_library,
              onPressed: controller.pickImages,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: 'Caméra',
              type: ButtonType.outline,
              icon: Icons.camera_alt,
              onPressed: controller.pickImageFromCamera,
            ),
          ),
        ],
      ),

      const SizedBox(height: 16),

      // Grille des photos sélectionnées
      Obx(() {
        if (controller.selectedPhotos.isEmpty) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: AppTheme.textLight,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aucune photo sélectionnée',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.selectedPhotos.length,
          itemBuilder: (context, index) {
            final photo = controller.selectedPhotos[index];
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(photo.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => controller.removePhoto(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    ]);
  }

  Widget _buildPaymentSection() {
    return _buildSection('Modalités de paiement', Icons.payment_outlined, [
      Obx(
        () => MultilineTextField(
          label: 'Modalités de paiement *',
          hint:
              'Ex: Comptant, financement bancaire possible, facilités de paiement...',
          controller: TextEditingController(
            text: controller.modalitesPaiementController.value,
          )..addListener(
            () =>
                controller.modalitesPaiementController.value =
                    TextEditingController(
                      text: controller.modalitesPaiementController.value,
                    ).text,
          ),
          onChanged:
              (value) => controller.modalitesPaiementController.value = value,
          validator: Validators.required,
          maxLines: 3,
        ),
      ),
    ]);
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => CustomButton(
        text:
            controller.isEditing.value ? 'Mettre à jour' : 'Publier l\'annonce',
        type: ButtonType.primary,
        isFullWidth: true,
        isLoading: controller.isSaving.value,
        onPressed: controller.formValid.value ? _submitForm : null,
        icon: controller.isEditing.value ? Icons.update : Icons.publish,
      ),
    );
  }

  void _submitForm() {
    if (controller.isEditing.value) {
      controller.updateAnnonce(controller.currentAnnonce.value!.id);
    } else {
      controller.createAnnonce();
    }
  }

  String _getTypeLogementDisplay(TypeLogement type) {
    switch (type) {
      case TypeLogement.VILLA:
        return 'Villa';
      case TypeLogement.MAISON:
        return 'Maison';
      case TypeLogement.APPARTEMENT:
        return 'Appartement';
      case TypeLogement.STUDIO:
        return 'Studio';
      case TypeLogement.CHAMBRE:
        return 'Chambre';
    }
  }
}
