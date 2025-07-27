import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/components/custom_text_field.dart';
import '../../../widgets/components/custom_button.dart';
import '../../../widgets/components/loading_widget.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [_buildHeader(), _buildProfileContent()]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mon Profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => _showSettingsMenu(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Avatar et informations de base
          Obx(
            () => Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    controller.userInitials,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  controller.currentUser?.fullName ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  controller.currentUser?.email ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.currentUser?.role.name
                            .toString()
                            .split('.')
                            .last ??
                        '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Statistiques pour les propriétaires
          if (controller.isProprietaire) ...[
            _buildStatisticsCard(),
            const SizedBox(height: 20),
          ],

          // Informations du profil
          _buildProfileInfoCard(),

          const SizedBox(height: 20),

          // Actions du profil
          _buildProfileActions(),

          const SizedBox(height: 20),

          // Bouton de déconnexion
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: LoadingWidget(message: 'Chargement des statistiques...'),
          ),
        );
      }

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mes Statistiques',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Annonces',
                      '${controller.totalAnnonces}',
                      Icons.home,
                      AppTheme.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Total Vues',
                      '${controller.totalVues}',
                      Icons.visibility,
                      AppTheme.infoColor,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Moy. Vues',
                      '${controller.moyenneVues}',
                      Icons.trending_up,
                      AppTheme.successColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              CustomButton(
                text: 'Voir mes annonces',
                type: ButtonType.outline,
                isFullWidth: true,
                onPressed: () => Get.toNamed('/annonce/mes-annonces'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informations Personnelles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      controller.isEditingProfile.value
                          ? Icons.close
                          : Icons.edit,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      if (controller.isEditingProfile.value) {
                        controller.cancelEditingProfile();
                      } else {
                        controller.startEditingProfile();
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Obx(() {
              if (controller.isEditingProfile.value) {
                return _buildEditProfileForm();
              } else {
                return _buildProfileInfo();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        _buildInfoRow('Prénom', controller.currentUser?.prenom ?? ''),
        _buildInfoRow('Nom', controller.currentUser?.nom ?? ''),
        _buildInfoRow('Email', controller.currentUser?.email ?? ''),
        _buildInfoRow(
          'Région',
          controller.currentUser?.region ?? 'Non spécifiée',
        ),
        _buildInfoRow(
          'Commune',
          controller.currentUser?.commune ?? 'Non spécifiée',
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => CustomTextField(
                  label: 'Prénom',
                  initialValue: controller.prenomController.value,
                  onChanged:
                      (value) => controller.prenomController.value = value,
                  validator: Validators.required,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => CustomTextField(
                  label: 'Nom',
                  initialValue: controller.nomController.value,
                  onChanged: (value) => controller.nomController.value = value,
                  validator: Validators.required,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Obx(
          () => CustomTextField(
            label: 'Email',
            initialValue: controller.emailController.value,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => controller.emailController.value = value,
            validator: Validators.email,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Obx(
                () => CustomDropdown<String>(
                  label: 'Région',
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
                  label: 'Commune',
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
                      (value) =>
                          controller.communeController.value = value ?? '',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Annuler',
                type: ButtonType.outline,
                onPressed: controller.cancelEditingProfile,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => CustomButton(
                  text: 'Sauvegarder',
                  type: ButtonType.primary,
                  isLoading: controller.isSaving.value,
                  onPressed:
                      controller.profileFormValid.value
                          ? controller.updateProfile
                          : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileActions() {
    return Column(
      children: [
        _buildActionTile(
          'Changer le mot de passe',
          Icons.lock_outline,
          () => _showChangePasswordDialog(),
        ),

        if (controller.isProprietaire) ...[
          _buildActionTile(
            'Mes annonces',
            Icons.home_outlined,
            () => Get.toNamed('/annonce/mes-annonces'),
          ),
          _buildActionTile(
            'Créer une annonce',
            Icons.add_home_outlined,
            () => Get.toNamed('/annonce/form'),
          ),
        ],

        _buildActionTile(
          'Mes favoris',
          Icons.favorite_outline,
          () => Get.snackbar('Favoris', 'Fonctionnalité à venir'),
        ),

        _buildActionTile(
          'Notifications',
          Icons.notifications,
          () => Get.snackbar('Notifications', 'Fonctionnalité à venir'),
        ),

        _buildActionTile(
          'Aide et support',
          Icons.help_outline,
          () => Get.snackbar('Support', 'Fonctionnalité à venir'),
        ),

        _buildActionTile(
          'Supprimer le compte',
          Icons.delete_outline,
          controller.deleteAccount,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return CustomButton(
      text: 'Se déconnecter',
      type: ButtonType.outline,
      isFullWidth: true,
      onPressed: controller.logout,
      icon: Icons.logout,
    );
  }

  void _showChangePasswordDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => CustomTextField(
                label: 'Mot de passe actuel',
                obscureText: true,
                onChanged:
                    (value) =>
                        controller.currentPasswordController.value = value,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomTextField(
                label: 'Nouveau mot de passe',
                obscureText: true,
                onChanged:
                    (value) => controller.newPasswordController.value = value,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomTextField(
                label: 'Confirmer le nouveau mot de passe',
                obscureText: true,
                onChanged:
                    (value) =>
                        controller.confirmPasswordController.value = value,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.cancelChangingPassword();
              Get.back();
            },
            child: const Text('Annuler'),
          ),
          Obx(
            () => TextButton(
              onPressed:
                  controller.passwordFormValid.value
                      ? () {
                        controller.changePassword();
                        Get.back();
                      }
                      : null,
              child:
                  controller.isSaving.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Changer'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paramètres',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Mode sombre'),
              trailing: Switch(
                value: false, // À implémenter
                onChanged: (value) {
                  Get.snackbar('Thème', 'Fonctionnalité à venir');
                },
              ),
            ),

            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Langue'),
              trailing: const Text('Français'),
              onTap: () {
                Get.snackbar('Langue', 'Fonctionnalité à venir');
              },
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
                Get.snackbar('À propos', 'Immobilier App v1.0.0');
              },
            ),
          ],
        ),
      ),
    );
  }
}
