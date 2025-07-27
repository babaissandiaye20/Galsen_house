import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/components/custom_text_field.dart';
import '../../../widgets/components/custom_button.dart';
import '../../../models/role.dart';

class RegisterView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),

              const SizedBox(height: 32),

              _buildRegisterForm(),

              const SizedBox(height: 24),

              _buildRegisterButton(),

              const SizedBox(height: 16),

              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Créer un compte',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Rejoignez notre communauté immobilière',
          style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Prénom et Nom
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Prénom',
                hint: 'Votre prénom',
                prefixIcon: Icons.person_outlined,
                textCapitalization: TextCapitalization.words,
                onChanged:
                    (value) =>
                        controller.registerPrenomController.value = value,
                validator: Validators.required,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Nom',
                hint: 'Votre nom',
                prefixIcon: Icons.person_outlined,
                textCapitalization: TextCapitalization.words,
                onChanged:
                    (value) => controller.registerNomController.value = value,
                validator: Validators.required,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Email
        CustomTextField(
          label: 'Email',
          hint: 'votre.email@exemple.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          onChanged:
              (value) => controller.registerEmailController.value = value,
          validator: Validators.email,
        ),

        const SizedBox(height: 16),

        // Type de compte
        CustomDropdown<String>(
          label: 'Type de compte',
          hint: 'Sélectionnez votre rôle',
          value: controller.registerRoleController.value,
          prefixIcon: Icons.account_circle_outlined,
          items: [
            DropdownMenuItem(
              value: 'CLIENT',
              child: Text('Client (Recherche de logement)'),
            ),
            DropdownMenuItem(
              value: 'PROPRIETAIRE',
              child: Text('Propriétaire (Publication d\'annonces)'),
            ),
          ],
          onChanged:
              (value) =>
                  controller.registerRoleController.value = value ?? 'CLIENT',
        ),

        const SizedBox(height: 16),

        // Région et Commune
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Région',
                hint: 'Ex: Dakar',
                prefixIcon: Icons.location_on_outlined,
                textCapitalization: TextCapitalization.words,
                onChanged:
                    (value) =>
                        controller.registerRegionController.value = value,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Commune',
                hint: 'Ex: Plateau',
                prefixIcon: Icons.location_city_outlined,
                textCapitalization: TextCapitalization.words,
                onChanged:
                    (value) =>
                        controller.registerCommuneController.value = value,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Mot de passe
        CustomTextField(
          label: 'Mot de passe',
          hint: 'Minimum 6 caractères',
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
          onChanged:
              (value) => controller.registerPasswordController.value = value,
          validator: Validators.password,
        ),

        const SizedBox(height: 16),

        // Confirmation mot de passe
        CustomTextField(
          label: 'Confirmer le mot de passe',
          hint: 'Retapez votre mot de passe',
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
          onChanged:
              (value) =>
                  controller.registerConfirmPasswordController.value = value,
          validator: Validators.confirmPassword(
            controller.registerPasswordController.value,
          ),
        ),

        const SizedBox(height: 16),

        // Conditions d'utilisation
        _buildTermsAndConditions(),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: true, // Pour la démo, toujours coché
          onChanged: (value) {
            // Gérer l'acceptation des conditions
          },
          activeColor: AppTheme.primaryColor,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              children: [
                const TextSpan(text: 'En créant un compte, j\'accepte les '),
                TextSpan(
                  text: 'Conditions d\'utilisation',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: ' et la '),
                TextSpan(
                  text: 'Politique de confidentialité',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Obx(
      () => CustomButton(
        text: 'Créer mon compte',
        onPressed:
            controller.registerFormValid.value ? controller.register : null,
        isLoading: controller.isLoading.value,
        isFullWidth: true,
        type: ButtonType.primary,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Déjà un compte ? ',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Se connecter',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
