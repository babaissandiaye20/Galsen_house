import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/annonce_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/components/custom_button.dart';
import '../../../widgets/components/loading_widget.dart';
import '../../../widgets/components/annonce_card.dart';
import '../../../models/annonce.dart';

class MesAnnoncesView extends GetView<AnnonceController> {
  @override
  Widget build(BuildContext context) {
    // Charger les annonces du propriétaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadMesAnnonces();
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Mes Annonces'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.startNewAnnonce,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Chargement de vos annonces...');
        }

        return Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildAnnoncesList()),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.startNewAnnonce,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadows,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  '${controller.mesAnnonces.length}',
                  Icons.home,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Vues totales',
                  '${_getTotalViews()}',
                  Icons.visibility,
                  AppTheme.infoColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          CustomButton(
            text: 'Créer une nouvelle annonce',
            type: ButtonType.primary,
            isFullWidth: true,
            icon: Icons.add_home,
            onPressed: controller.startNewAnnonce,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnoncesList() {
    return Obx(() {
      if (controller.mesAnnonces.isEmpty) {
        return EmptyStateWidget(
          title: 'Aucune annonce',
          subtitle: 'Vous n\'avez pas encore publié d\'annonce.\nCommencez dès maintenant !',
          icon: Icons.home_outlined,
          actionText: 'Créer ma première annonce',
          onAction: controller.startNewAnnonce,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadMesAnnonces,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.mesAnnonces.length,
          itemBuilder: (context, index) {
            final annonce = controller.mesAnnonces[index];
            return _buildAnnonceItem(annonce);
          },
        ),
      );
    });
  }

  Widget _buildAnnonceItem(Annonce annonce) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Image et informations principales
          AnnonceCard(
            annonce: annonce,
            showActions: false,
            onTap: () => Get.toNamed('/annonce/detail', arguments: annonce),
          ),
          
          // Actions spécifiques au propriétaire
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                // Statistiques
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniStat(
                        Icons.visibility,
                        '${annonce.vues} vues',
                        AppTheme.infoColor,
                      ),
                    ),
                    Expanded(
                      child: _buildMiniStat(
                        Icons.calendar_today,
                        _formatDate(annonce.createdAt),
                        AppTheme.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: _buildMiniStat(
                        Icons.update,
                        _formatDate(annonce.updatedAt),
                        AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Modifier',
                        type: ButtonType.outline,
                        icon: Icons.edit,
                        onPressed: () => controller.editAnnonce(annonce),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Partager',
                        type: ButtonType.outline,
                        icon: Icons.share,
                        onPressed: () => _shareAnnonce(annonce),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: '',
                      type: ButtonType.danger,
                      icon: Icons.delete,
                      onPressed: () => _confirmDelete(annonce),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(Annonce annonce) {
    Get.dialog(
      AlertDialog(
        title: const Text('Supprimer l\'annonce'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Êtes-vous sûr de vouloir supprimer cette annonce ?'),
            const SizedBox(height: 8),
            Text(
              annonce.titre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cette action est irréversible.',
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAnnonce(annonce.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _shareAnnonce(Annonce annonce) {
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
              'Partager l\'annonce',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  Icons.link,
                  'Copier le lien',
                  () {
                    Get.back();
                    Get.snackbar('Lien copié', 'Le lien de l\'annonce a été copié');
                  },
                ),
                _buildShareOption(
                  Icons.message,
                  'WhatsApp',
                  () {
                    Get.back();
                    Get.snackbar('WhatsApp', 'Partage via WhatsApp');
                  },
                ),
                _buildShareOption(
                  Icons.email,
                  'Email',
                  () {
                    Get.back();
                    Get.snackbar('Email', 'Partage par email');
                  },
                ),
                _buildShareOption(
                  Icons.more_horiz,
                  'Autres',
                  () {
                    Get.back();
                    Get.snackbar('Partage', 'Autres options de partage');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalViews() {
    return controller.mesAnnonces.fold<int>(
      0,
      (total, annonce) => total + annonce.vues,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}j';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}sem';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

