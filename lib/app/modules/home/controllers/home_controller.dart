import 'package:get/get.dart';
import '../../../models/annonce.dart';
import '../../../models/user.dart';
import '../../../services/annonce_service_mock.dart';
import '../../../services/user_service_mock.dart';
import '../../../services/utils_service_mock.dart';
import '../../../utils/snackbar_utils.dart';

class HomeController extends GetxController {
  final AnnonceServiceMock _annonceService = Get.find<AnnonceServiceMock>();
  final UserServiceMock _userService = Get.find<UserServiceMock>();
  final UtilsServiceMock _utilsService = Get.find<UtilsServiceMock>();

  // Observables
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final annonces = <Annonce>[].obs;
  final filteredAnnonces = <Annonce>[].obs;
  final featuredAnnonces = <Annonce>[].obs;
  final recentAnnonces = <Annonce>[].obs;
  final displayedAnnonces = <Annonce>[].obs;
  final hasMore = true.obs;
  final selectedTabIndex = 0.obs;

  // État du tri
  final currentSortType = Rxn<String>();
  final sortOptions = <String>[
    'Plus récent',
    'Prix croissant',
    'Prix décroissant',
    'Plus de vues',
  ];

  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final hasMoreData = true.obs;

  // Filtres
  final selectedRegion = ''.obs;
  final selectedCommune = ''.obs;
  final selectedType = ''.obs;
  final minPrice = 0.0.obs;
  final maxPrice = 10000000.0.obs;
  final minChambres = 0.obs;
  final maxChambres = 10.obs;
  final showFilters = false.obs;
  final prixMin = 0.0.obs;
  final prixMax = 100000000.0.obs; // 100M FCFA par défaut

  // Recherche
  final searchQuery = ''.obs;
  final searchSuggestions = <String>[].obs;
  final searchHistory = <String>[].obs;

  // Données de référence
  final regions = <String>[].obs;
  final communes = <String>[].obs;
  final typeLogements =
      <String>['VILLA', 'MAISON', 'APPARTEMENT', 'STUDIO', 'CHAMBRE'].obs;

  // État de l'utilisateur
  final currentUser = Rxn<User>();
  final favoriteIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      loadAnnonces(refresh: true),
      loadFeaturedAnnonces(),
      loadRecentAnnonces(),
      _loadRegions(),
      _loadCurrentUser(),
    ]);
  }

  // Charger les annonces
  Future<void> loadAnnonces({bool refresh = false}) async {
    try {
      print('🔍 Début du chargement des annonces...');

      if (refresh) {
        currentPage.value = 1;
        annonces.clear();
      } else {
        if (!hasMoreData.value || isLoadingMore.value) return;
        isLoadingMore.value = true;
      }

      isLoading.value = true;

      // Convertir le type de logement
      TypeLogement? typeLogement;
      if (selectedType.value.isNotEmpty) {
        try {
          typeLogement = TypeLogement.values.firstWhere(
            (e) => e.toString().split('.').last == selectedType.value,
          );
        } catch (e) {
          print('❌ TypeLogement invalide : ${selectedType.value}');
          typeLogement = null;
        }
      }

      // Gestion des filtres de prix
      double? prixMinFinal = prixMin.value > 0 ? prixMin.value : null;
      double? prixMaxFinal = prixMax.value > 0 ? prixMax.value : null;

      // Debug: Afficher les paramètres envoyés
      print('🔍 Paramètres envoyés au service:');
      print(
        '  - region: "${selectedRegion.value}" -> ${selectedRegion.value.isEmpty ? null : selectedRegion.value}',
      );
      print(
        '  - commune: "${selectedCommune.value}" -> ${selectedCommune.value.isEmpty ? null : selectedCommune.value}',
      );
      print('  - typeLogement: $typeLogement');
      print('  - prixMin: $prixMinFinal');
      print('  - prixMax: $prixMaxFinal');

      final result = await _annonceService.getAnnonces(
        page: currentPage.value,
        limit: 10,
        region: selectedRegion.value.isEmpty ? null : selectedRegion.value,
        commune: selectedCommune.value.isEmpty ? null : selectedCommune.value,
        typeLogement: typeLogement,
        prixMin: prixMinFinal,
        prixMax: prixMaxFinal,
      );

      if (result['success']) {
        print('✅ Annonces récupérées');
        final List<dynamic> data = result['data'];
        final newAnnonces = data.map((json) => Annonce.fromJson(json)).toList();

        print('📦 Annonces reçues: ${newAnnonces.length}');
        if (refresh) {
          annonces.value = newAnnonces;
        } else {
          annonces.addAll(newAnnonces);
        }

        // Mise à jour pagination
        final pagination = result['pagination'];
        if (pagination != null) {
          final current = pagination['current_page'] ?? 1;
          final last = pagination['last_page'] ?? 1;
          hasMoreData.value = current < last;
          totalPages.value = last;
          currentPage.value = current + 1;
        } else {
          hasMoreData.value = false;
        }

        print('📊 Total annonces après ajout: ${annonces.length}');
        _updateFilteredAnnonces();
        update();
      } else {
        print('❌ Erreur: ${result['message']}');
        SnackbarUtils.showError('Erreur', result['message']);
      }
    } catch (e) {
      print('❌ Exception lors du chargement: $e');
      SnackbarUtils.showError(
        'Erreur',
        'Erreur lors du chargement des annonces',
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Charger les annonces en vedette
  Future<void> loadFeaturedAnnonces() async {
    try {
      final result = await _annonceService.getFeaturedAnnonces();
      if (result['success']) {
        featuredAnnonces.value =
            (result['data'] as List)
                .map((json) => Annonce.fromJson(json))
                .toList();
        update();
      }
    } catch (e) {
      print('Erreur lors du chargement des annonces en vedette: $e');
    }
  }

  // Charger les annonces récentes
  Future<void> loadRecentAnnonces() async {
    try {
      final result = await _annonceService.getRecentAnnonces(limit: 5);
      if (result['success']) {
        recentAnnonces.value =
            (result['data'] as List)
                .map((json) => Annonce.fromJson(json))
                .toList();
        update();
      }
    } catch (e) {
      print('Erreur lors du chargement des annonces récentes: $e');
    }
  }

  // Rechercher des annonces
  Future<void> searchAnnonces(String query) async {
    try {
      searchQuery.value = query;
      isLoading.value = true;

      if (query.isNotEmpty) {
        await _utilsService.saveSearchHistory(query);
        _loadSearchHistory();
      }

      // Convertir le type de logement
      TypeLogement? typeLogement;
      if (selectedType.value.isNotEmpty) {
        try {
          typeLogement = TypeLogement.values.firstWhere(
            (e) => e.toString().split('.').last == selectedType.value,
          );
        } catch (e) {
          typeLogement = null;
        }
      }

      final result = await _annonceService.searchAnnonces(
        query: query,
        region: selectedRegion.value,
        commune: selectedCommune.value,
        typeLogement: typeLogement,
        prixMin: prixMin.value,
        prixMax: prixMax.value,
      );

      if (result['success']) {
        annonces.value =
            (result['data'] as List)
                .map((json) => Annonce.fromJson(json))
                .toList();
        _updateFilteredAnnonces();
        update();
      } else {
        SnackbarUtils.showError('Erreur', result['message']);
      }
    } catch (e) {
      SnackbarUtils.showError('Erreur', 'Erreur lors de la recherche');
    } finally {
      isLoading.value = false;
    }
  }

  // Obtenir des suggestions de recherche
  Future<void> getSearchSuggestions(String query) async {
    try {
      if (query.length < 2) {
        searchSuggestions.clear();
        return;
      }

      final result = await _utilsService.getSearchSuggestions(query);
      if (result['success']) {
        searchSuggestions.value = List<String>.from(result['data']);
      }
    } catch (e) {
      print('Erreur lors du chargement des suggestions: $e');
    }
  }

  // Gestion des favoris
  Future<void> toggleFavorite(int annonceId) async {
    try {
      if (currentUser.value == null) {
        Get.snackbar(
          'Erreur',
          'Vous devez être connecté pour ajouter aux favoris',
        );
        return;
      }

      final isFavorite = favoriteIds.contains(annonceId);

      if (isFavorite) {
        final result = await _utilsService.removeFromFavorites(annonceId);
        if (result['success']) {
          favoriteIds.remove(annonceId);
          SnackbarUtils.showSuccess('Succès', 'Retiré des favoris');
        }
      } else {
        final result = await _utilsService.addToFavorites(annonceId);
        if (result['success']) {
          favoriteIds.add(annonceId);
          SnackbarUtils.showSuccess('Succès', 'Ajouté aux favoris');
        }
      }
    } catch (e) {
      SnackbarUtils.showError(
        'Erreur',
        'Erreur lors de la gestion des favoris',
      );
    }
  }

  // Filtres
  void applyFilters() {
    _updateFilteredAnnonces();
    loadAnnonces(refresh: true);
  }

  void clearFilters() {
    selectedRegion.value = '';
    selectedCommune.value = '';
    selectedType.value = '';
    selectedTabIndex.value = 0; // Remettre à "Tout"
    prixMin.value = 0.0;
    prixMax.value = 100000000.0; // 100M par défaut
    minChambres.value = 0;
    maxChambres.value = 10;
    searchQuery.value = '';
    currentSortType.value = null; // Effacer aussi le tri

    print('🧹 Filtres effacés - Rechargement des annonces');
    loadAnnonces(refresh: true);
  }

  void setRegion(String region) {
    selectedRegion.value = region;
    selectedCommune.value = ''; // Reset commune
    _loadCommunes(region);
  }

  void setCommune(String commune) {
    selectedCommune.value = commune;
  }

  void setType(String type) {
    selectedType.value = type;
  }

  void setPriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  void setChambresRange(int min, int max) {
    minChambres.value = min;
    maxChambres.value = max;
  }

  // Méthodes privées
  Map<String, dynamic> _buildFilters() {
    final filters = <String, dynamic>{};

    if (selectedRegion.value.isNotEmpty) {
      filters['region'] = selectedRegion.value;
    }
    if (selectedCommune.value.isNotEmpty) {
      filters['commune'] = selectedCommune.value;
    }
    if (selectedType.value.isNotEmpty) {
      filters['typeLogement'] = selectedType.value;
    }
    if (minPrice.value > 0) {
      filters['minPrice'] = minPrice.value;
    }
    if (maxPrice.value < 10000000) {
      filters['maxPrice'] = maxPrice.value;
    }
    if (minChambres.value > 0) {
      filters['minChambres'] = minChambres.value;
    }
    if (maxChambres.value < 10) {
      filters['maxChambres'] = maxChambres.value;
    }

    return filters;
  }

  void _updateFilteredAnnonces() {
    print('🔄 Mise à jour des annonces filtrées...');
    print('📊 Annonces disponibles: ${annonces.length}');
    displayedAnnonces.value =
        annonces.where((annonce) {
          // Appliquer les filtres locaux si nécessaire
          return true; // Pour l'instant, on affiche toutes les annonces
        }).toList();
    print('📋 Annonces affichées après filtrage: ${displayedAnnonces.length}');
    update();
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

  Future<void> _loadCommunes(String region) async {
    try {
      final result = await _utilsService.getCommunes(region);
      if (result['success']) {
        communes.value = List<String>.from(result['data']);
      }
    } catch (e) {
      print('Erreur lors du chargement des communes: $e');
    }
  }

  Future<void> loadCommunesForRegion(String region) async {
    try {
      print('🏘️ Chargement des communes pour la région: $region');
      // Réinitialiser la commune sélectionnée quand on change de région
      selectedCommune.value = '';

      final result = await _utilsService.getCommunes(region);
      if (result['success']) {
        communes.value = List<String>.from(result['data']);
        print('✅ Communes chargées: ${communes.length}');
        update();
      } else {
        print('❌ Erreur lors du chargement des communes: ${result['message']}');
      }
    } catch (e) {
      print('❌ Exception lors du chargement des communes: $e');
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      // Récupérer l'utilisateur actuel depuis le service d'auth
      // Pour l'instant, on simule
      currentUser.value = null;

      if (currentUser.value != null) {
        await _loadUserFavorites();
      }
    } catch (e) {
      print('Erreur lors du chargement de l\'utilisateur: $e');
    }
  }

  Future<void> _loadUserFavorites() async {
    try {
      if (currentUser.value == null) return;

      final result = await _utilsService.getFavorites();
      if (result['success']) {
        final favorites = result['data'] as List<Annonce>;
        favoriteIds.value = favorites.map((a) => a.id).toList();
      }
    } catch (e) {
      print('Erreur lors du chargement des favoris: $e');
    }
  }

  Future<void> _loadSearchHistory() async {
    try {
      final result = await _utilsService.getSearchHistory();
      if (result['success']) {
        searchHistory.value = List<String>.from(result['data']);
      }
    } catch (e) {
      print('Erreur lors du chargement de l\'historique: $e');
    }
  }

  // Méthodes utilitaires
  bool isFavorite(int annonceId) {
    return favoriteIds.contains(annonceId);
  }

  String getFormattedPrice(double price) {
    return _utilsService.formatPrice(price);
  }

  String getFormattedDate(DateTime date) {
    return _utilsService.formatDate(date);
  }

  // Refresh
  Future<void> refreshData() async {
    await _initializeData();
  }

  // Navigation
  void goToAnnonceDetail(Annonce annonce) {
    Get.toNamed('/annonce-detail', arguments: annonce);
  }

  void goToSearch() {
    Get.toNamed('/search');
  }

  void goToFilters() {
    // Cette méthode sera gérée dans la vue
    Get.toNamed('/filters');
  }

  void toggleFilters() {
    showFilters.value = !showFilters.value;
    update();
  }

  bool get hasActiveFilters {
    return selectedRegion.value.isNotEmpty ||
        selectedCommune.value.isNotEmpty ||
        selectedType.value.isNotEmpty ||
        prixMin.value > 0 ||
        prixMax.value < 100000000.0;
  }

  String get filtersCount {
    int count = 0;
    if (selectedRegion.value.isNotEmpty) count++;
    if (selectedCommune.value.isNotEmpty) count++;
    if (selectedType.value.isNotEmpty) count++;
    if (prixMin.value > 0) count++;
    if (prixMax.value < 100000000.0) count++;
    return count > 0 ? '($count)' : '';
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;

    // Mettre à jour le type de logement sélectionné
    final tabItems = [
      null, // Tout
      TypeLogement.VILLA,
      TypeLogement.MAISON,
      TypeLogement.APPARTEMENT,
      TypeLogement.STUDIO,
    ];

    if (index < tabItems.length) {
      final selectedTypeLogement = tabItems[index];
      selectedType.value =
          selectedTypeLogement?.toString().split('.').last ?? '';
      print('🔍 Type sélectionné: ${selectedType.value}');

      // Recharger les annonces avec le nouveau filtre
      loadAnnonces(refresh: true);
    }
  }

  Future<void> refreshAnnonces() async {
    await loadAnnonces(refresh: true);
  }

  void loadMoreAnnonces() {
    if (hasMore.value && !isLoadingMore.value) {
      loadAnnonces();
    }
  }

  void onAnnonceSelected(Annonce annonce) {
    Get.toNamed('/annonce/detail', arguments: annonce);
  }

  // Méthodes de tri
  void sortByDate() {
    currentSortType.value = 'Plus récent';
    annonces.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _updateFilteredAnnonces();
    update();
  }

  void sortByPriceAscending() {
    currentSortType.value = 'Prix croissant';
    annonces.sort((a, b) => a.prix.compareTo(b.prix));
    _updateFilteredAnnonces();
    update();
  }

  void sortByPriceDescending() {
    currentSortType.value = 'Prix décroissant';
    annonces.sort((a, b) => b.prix.compareTo(a.prix));
    _updateFilteredAnnonces();
    update();
  }

  void sortByViews() {
    currentSortType.value = 'Plus de vues';
    annonces.sort((a, b) => b.vues.compareTo(a.vues));
    _updateFilteredAnnonces();
    update();
  }

  void clearSort() {
    currentSortType.value = null;
    _updateFilteredAnnonces();
    update();
  }
}
