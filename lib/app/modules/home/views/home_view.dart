import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/components/custom_text_field.dart';
import '../../../widgets/components/custom_button.dart';
import '../../../widgets/components/annonce_card.dart';
import '../../../widgets/components/loading_widget.dart';
import '../../../widgets/components/chat_widget.dart';
import '../../../models/annonce.dart';
import '../../../utils/snackbar_utils.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFiltersSection(),
            _buildTabBar(),
            Expanded(child: _buildAnnoncesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bonjour !',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const Text(
                    'Trouvez votre logement',
                    style: TextStyle(
                        fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      // Naviguer vers les notifications
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Get.toNamed('/profile'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GetBuilder<HomeController>(
        builder:
            (controller) => SearchTextField(
          hint: 'Rechercher par titre, région, commune...',
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.update();
              },
          onClear: () {
            controller.searchQuery.value = '';
                controller.update();
          },
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return GetBuilder<HomeController>(
      builder:
          (controller) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: controller.showFilters.value ? null : 60,
        child: Column(
          children: [
            // Bouton filtres et tri
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilterButton(
                      text: 'Filtres ${controller.filtersCount}',
                      onPressed: controller.toggleFilters,
                      isActive: controller.hasActiveFilters,
                    ),
                  ),
                  const SizedBox(width: 12),
                      GetBuilder<HomeController>(
                        builder:
                            (controller) => OutlinedButton.icon(
                    onPressed: () {
                      // Afficher les options de tri
                      _showSortOptions();
                    },
                    icon: const Icon(Icons.sort),
                              label: Text(
                                controller.currentSortType.value ?? 'Trier',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      controller.currentSortType.value != null
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                  color:
                                      controller.currentSortType.value != null
                                          ? AppTheme.primaryColor
                                          : AppTheme.textSecondary,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    controller.currentSortType.value != null
                                        ? AppTheme.primaryColor
                                        : AppTheme.textSecondary,
                                side: BorderSide(
                                  color:
                                      controller.currentSortType.value != null
                                          ? AppTheme.primaryColor
                                          : AppTheme.dividerColor,
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),

            // Filtres détaillés
            if (controller.showFilters.value) ...[
              const SizedBox(height: 16),
              _buildDetailedFilters(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Région et Commune
          Column(
            children: [
              GetBuilder<HomeController>(
                builder:
                    (controller) => CustomDropdown<String>(
                    label: 'Région',
                    hint: 'Toutes les régions',
                    value:
                        controller.selectedRegion.value.isEmpty
                            ? null
                            : controller.selectedRegion.value,
                    items:
                        controller.regions
                            .map(
                              (region) => DropdownMenuItem(
                                value: region,
                                child: Text(region),
                              ),
                            )
                            .toList(),
                      onChanged: (value) {
                        controller.selectedRegion.value = value ?? '';
                        // Charger les communes quand une région est sélectionnée
                        if (value != null && value.isNotEmpty) {
                          controller.loadCommunesForRegion(value);
                        }
                        controller.update();
                      },
                ),
              ),
              const SizedBox(height: 16),
              GetBuilder<HomeController>(
                builder:
                    (controller) => CustomDropdown<String>(
                    label: 'Commune',
                    hint: 'Toutes les communes',
                    value:
                        controller.selectedCommune.value.isEmpty
                            ? null
                              : controller.communes.contains(
                                controller.selectedCommune.value,
                              )
                              ? controller.selectedCommune.value
                              : null,
                    items:
                        controller.communes
                            .map(
                              (commune) => DropdownMenuItem(
                                value: commune,
                                child: Text(commune),
                              ),
                            )
                            .toList(),
                      onChanged: (value) {
                        controller.selectedCommune.value = value ?? '';
                        controller.update();
                      },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Prix
          Column(
            children: [
              PriceTextField(
                label: 'Prix min',
                  hint: 'Ex: 10000000',
                  onChanged: (value) {
                    final cleanValue = value.replaceAll(' ', '');
                    final parsedValue = double.tryParse(cleanValue);
                    if (parsedValue != null) {
                      controller.prixMin.value = parsedValue;
                    print('💰 Prix min mis à jour: $parsedValue');
                    controller.update();
                    }
                  },
              ),
              const SizedBox(height: 16),
              PriceTextField(
                label: 'Prix max',
                  hint: 'Ex: 50000000',
                  onChanged: (value) {
                    final cleanValue = value.replaceAll(' ', '');
                    final parsedValue = double.tryParse(cleanValue);
                    if (parsedValue != null) {
                      controller.prixMax.value = parsedValue;
                    print('💰 Prix max mis à jour: $parsedValue');
                    controller.update();
                    }
                  },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Effacer',
                  type: ButtonType.outline,
                  onPressed: controller.clearFilters,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Appliquer',
                  type: ButtonType.primary,
                  onPressed: () {
                    controller.toggleFilters();
                    controller.loadAnnonces(refresh: true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GetBuilder<HomeController>(
        builder:
            (controller) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _getTabItems().length,
          itemBuilder: (context, index) {
            final item = _getTabItems()[index];
            final isSelected = controller.selectedTabIndex.value == index;

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterButton(
                text: item['title'],
                isActive: isSelected,
                onPressed: () => controller.onTabChanged(index),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTabItems() {
    return [
      {'title': 'Tout', 'type': null},
      {'title': 'Villas', 'type': TypeLogement.VILLA},
      {'title': 'Maisons', 'type': TypeLogement.MAISON},
      {'title': 'Appartements', 'type': TypeLogement.APPARTEMENT},
      {'title': 'Studios', 'type': TypeLogement.STUDIO},
    ];
  }

  Widget _buildAnnoncesList() {
    return GetBuilder<HomeController>(
      builder: (controller) {
        print('🏠 Construction de la liste des annonces');
        print(
          '📊 Nombre d\'annonces affichées: ${controller.displayedAnnonces.length}',
        );
        print('⏳ En cours de chargement: ${controller.isLoading.value}');

        if (controller.isLoading.value &&
            controller.displayedAnnonces.isEmpty) {
        return const ListSkeleton(
          itemCount: 5,
          itemSkeleton: AnnonceCardSkeleton(),
        );
      }

      if (controller.displayedAnnonces.isEmpty) {
        return EmptyStateWidget(
          title: 'Aucune annonce trouvée',
          subtitle: 'Essayez de modifier vos critères de recherche',
          icon: Icons.search_off,
          actionText: 'Effacer les filtres',
          onAction: controller.clearFilters,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshAnnonces,
        child: ListView.builder(
          itemCount:
              controller.displayedAnnonces.length +
              (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.displayedAnnonces.length) {
              // Indicateur de chargement pour plus d'annonces
              if (controller.isLoadingMore.value) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                // Charger plus automatiquement
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.loadMoreAnnonces();
                });
                return const SizedBox.shrink();
              }
            }

            final annonce = controller.displayedAnnonces[index];
            return AnnonceCard(
              annonce: annonce,
              onTap: () => controller.onAnnonceSelected(annonce),
              onFavorite: () {
                // Gérer les favoris
                  SnackbarUtils.showInfo('Favoris', 'Fonctionnalité à venir');
              },
            );
          },
        ),
      );
      },
    );
  }

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trier par',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GetBuilder<HomeController>(
                  builder:
                      (controller) =>
                          controller.currentSortType.value != null
                              ? TextButton(
                                onPressed: () {
                                  controller.clearSort();
                                  Get.back();
                                },
                                child: const Text(
                                  'Effacer',
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                              : const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSortOption('Plus récent', Icons.access_time),
            _buildSortOption('Prix croissant', Icons.arrow_upward),
            _buildSortOption('Prix décroissant', Icons.arrow_downward),
            _buildSortOption('Plus de vues', Icons.visibility),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon) {
    return GetBuilder<HomeController>(
      builder:
          (controller) => ListTile(
            leading: Icon(
              icon,
              color:
                  controller.currentSortType.value == title
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight:
                    controller.currentSortType.value == title
                        ? FontWeight.bold
                        : FontWeight.w500,
                color:
                    controller.currentSortType.value == title
                        ? AppTheme.primaryColor
                        : AppTheme.textPrimary,
              ),
            ),
            trailing:
                controller.currentSortType.value == title
                    ? const Icon(Icons.check, color: AppTheme.primaryColor)
                    : null,
      onTap: () {
        Get.back();

              switch (title) {
                case 'Plus récent':
                  controller.sortByDate();
                  break;
                case 'Prix croissant':
                  controller.sortByPriceAscending();
                  break;
                case 'Prix décroissant':
                  controller.sortByPriceDescending();
                  break;
                case 'Plus de vues':
                  controller.sortByViews();
                  break;
              }

              SnackbarUtils.showSuccess(
                'Tri appliqué',
                'Tri par $title appliqué avec succès',
              );
      },
          ),
    );
  }
}
