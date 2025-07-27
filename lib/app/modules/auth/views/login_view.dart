import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/components/custom_text_field.dart';
import '../../../widgets/components/custom_button.dart';

class LoginView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              _buildHeader(),

              const SizedBox(height: 40),

              _buildLoginForm(),

              const SizedBox(height: 24),

              _buildLoginButton(),

              const SizedBox(height: 16),

              _buildForgotPassword(),

              const SizedBox(height: 32),

              _buildDivider(),

              const SizedBox(height: 24),

              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.home, size: 40, color: Colors.white),
        ),

        const SizedBox(height: 24),

        const Text(
          'Connexion',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Connectez-vous à votre compte',
          style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextField(
          label: 'Email',
          hint: 'Entrez votre email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          onChanged: (value) => controller.loginEmailController.value = value,
          validator: Validators.email,
        ),

        const SizedBox(height: 16),

        CustomTextField(
          label: 'Mot de passe',
          hint: 'Entrez votre mot de passe',
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
          onChanged:
              (value) => controller.loginPasswordController.value = value,
          validator: Validators.password,
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => CustomButton(
        text: 'Se connecter',
        onPressed:
            controller.loginFormValid.value
                ? controller.login
                : () {
                  // Debug: afficher l'état de validation
                  print('Form valid: ${controller.loginFormValid.value}');
                  print('Email: "${controller.loginEmailController.value}"');
                  print(
                    'Password: "${controller.loginPasswordController.value}"',
                  );
                  Get.snackbar(
                    'Debug',
                    'Formulaire non valide - Vérifiez les champs',
                  );
                },
        isLoading: controller.isLoading.value,
        isFullWidth: true,
        type: ButtonType.primary,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              // Naviguer vers la page de récupération de mot de passe
              Get.snackbar(
                'Information',
                'Fonctionnalité de récupération de mot de passe à venir',
              );
            },
            child: const Text(
              'Mot de passe oublié ?',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // Afficher les informations de connexion mock
              Get.dialog(
                AlertDialog(
                  title: const Text('Informations de connexion'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Utilisateurs disponibles :'),
                      SizedBox(height: 8),
                      Text(
                        '• jean.dupont@email.com / password123 (Propriétaire)',
                      ),
                      Text('• marie.martin@email.com / password123 (Client)'),
                      Text(
                        '• amadou.ba@email.com / password123 (Propriétaire)',
                      ),
                      Text('• fatou.diop@email.com / password123 (Client)'),
                      Text('• admin@immobilier.com / admin123 (Admin)'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Fermer'),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'Voir les comptes de test',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OU',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Pas encore de compte ? ',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        TextButton(
          onPressed: () => Get.toNamed('/register'),
          child: const Text(
            'S\'inscrire',
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
