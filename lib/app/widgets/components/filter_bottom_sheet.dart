import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../models/annonce.dart';
import '../../core/constants.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    Key? key,
    this.initialFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Filtres
  String? selectedRegion;
  String? selectedCommune;
  TypeLogement? selectedTypeLogement;
  RangeValues priceRange = const RangeValues(0, 10000000);
  int? selectedChambres;
  String? selectedModalitePaiement;
  
  // Filtres avancés
  bool withPhotos = false;
  bool recentlyAdded = false;
  int? maxVues;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeFilters();
  }

  void _initializeFilters() {
    if (widget.initialFilters != null) {
      final filters = widget.initialFilters!;
      selectedRegion = filters['region'];
      selectedCommune = filters['commune'];
      selectedTypeLogement = filters['typeLogement'];
      if (filters['prixMin'] != null || filters['prixMax'] != null) {
        priceRange = RangeValues(
          filters['prixMin']?.toDouble() ?? 0,
          filters['prixMax']?.toDouble() ?? 10000000,
        );
      }
      selectedChambres = filters['nombreChambres'];
      selectedModalitePaiement = filters['modalitesPaiement'];
      withPhotos = filters['withPhotos'] ?? false;
      recentlyAdded = filters['recentlyAdded'] ?? false;
      maxVues = filters['maxVues'];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicFilters(),
                _buildAdvancedFilters(),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.tune,
            color: AppTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Filtres de recherche',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'Réinitialiser',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Filtres de base'),
          Tab(text: 'Filtres avancés'),
        ],
      ),
    );
  }

  Widget _buildBasicFilters() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Localisation'),
          _buildRegionSelector(),
          const SizedBox(height: 16),
          _buildCommuneSelector(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Type de logement'),
          _buildTypeLogementSelector(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Budget'),
          _buildPriceRangeSlider(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Caractéristiques'),
          _buildChambresSelector(),
          const SizedBox(height: 16),
          _buildModalitePaiementSelector(),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Options avancées'),
          
          _buildSwitchTile(
            title: 'Avec photos uniquement',
            subtitle: 'Afficher seulement les annonces avec photos',
            value: withPhotos,
            onChanged: (value) => setState(() => withPhotos = value),
            icon: Icons.photo_library,
          ),
          
          _buildSwitchTile(
            title: 'Récemment ajoutées',
            subtitle: 'Annonces ajoutées dans les 7 derniers jours',
            value: recentlyAdded,
            onChanged: (value) => setState(() => recentlyAdded = value),
            icon: Icons.new_releases,
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Popularité'),
          _buildVuesFilter(),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Tri par défaut'),
          _buildSortOptions(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildRegionSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRegion,
          hint: const Text('Sélectionner une région'),
          isExpanded: true,
          items: AppConstants.regionsCommunes.keys.map((region) {
            return DropdownMenuItem(
              value: region,
              child: Text(region),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedRegion = value;
              selectedCommune = null; // Reset commune when region changes
            });
          },
        ),
      ),
    );
  }

  Widget _buildCommuneSelector() {
    final communes = selectedRegion != null 
        ? AppConstants.regionsCommunes[selectedRegion!] ?? []
        : <String>[];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCommune,
          hint: Text(selectedRegion == null 
              ? 'Sélectionner d\'abord une région'
              : 'Sélectionner une commune'),
          isExpanded: true,
          items: communes.map((commune) {
            return DropdownMenuItem(
              value: commune,
              child: Text(commune),
            );
          }).toList(),
          onChanged: selectedRegion == null ? null : (value) {
            setState(() {
              selectedCommune = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTypeLogementSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TypeLogement.values.map((type) {
        final isSelected = selectedTypeLogement == type;
        return FilterChip(
          label: Text(type.toString().split('.').last),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              selectedTypeLogement = selected ? type : null;
            });
          },
          backgroundColor: Colors.grey.shade100,
          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
          checkmarkColor: AppTheme.primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: priceRange,
          min: 0,
          max: 10000000,
          divisions: 100,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withOpacity(0.2),
          labels: RangeLabels(
            '${(priceRange.start / 1000000).toStringAsFixed(1)}M',
            '${(priceRange.end / 1000000).toStringAsFixed(1)}M',
          ),
          onChanged: (values) {
            setState(() {
              priceRange = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(priceRange.start / 1000000).toStringAsFixed(1)}M FCFA',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '${(priceRange.end / 1000000).toStringAsFixed(1)}M FCFA',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChambresSelector() {
    return Wrap(
      spacing: 8,
      children: [1, 2, 3, 4, 5].map((nombre) {
        final isSelected = selectedChambres == nombre;
        return FilterChip(
          label: Text('$nombre ch.'),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              selectedChambres = selected ? nombre : null;
            });
          },
          backgroundColor: Colors.grey.shade100,
          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
          checkmarkColor: AppTheme.primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModalitePaiementSelector() {
    final modalites = ['Mensuel', 'Trimestriel', 'Semestriel', 'Annuel'];
    
    return Wrap(
      spacing: 8,
      children: modalites.map((modalite) {
        final isSelected = selectedModalitePaiement == modalite;
        return FilterChip(
          label: Text(modalite),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              selectedModalitePaiement = selected ? modalite : null;
            });
          },
          backgroundColor: Colors.grey.shade100,
          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
          checkmarkColor: AppTheme.primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildVuesFilter() {
    return Column(
      children: [
        Slider(
          value: (maxVues ?? 1000).toDouble(),
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withOpacity(0.2),
          label: maxVues == null ? 'Toutes' : '$maxVues vues max',
          onChanged: (value) {
            setState(() {
              maxVues = value.toInt();
            });
          },
        ),
        Text(
          maxVues == null 
              ? 'Toutes les annonces'
              : 'Maximum $maxVues vues',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    final sortOptions = [
      'Plus récentes',
      'Prix croissant',
      'Prix décroissant',
      'Plus populaires',
    ];
    
    return Column(
      children: sortOptions.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: 'Plus récentes', // Valeur par défaut
          onChanged: (value) {
            // Gérer le changement de tri
          },
          activeColor: AppTheme.primaryColor,
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Appliquer les filtres'),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedRegion = null;
      selectedCommune = null;
      selectedTypeLogement = null;
      priceRange = const RangeValues(0, 10000000);
      selectedChambres = null;
      selectedModalitePaiement = null;
      withPhotos = false;
      recentlyAdded = false;
      maxVues = null;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};
    
    if (selectedRegion != null) filters['region'] = selectedRegion;
    if (selectedCommune != null) filters['commune'] = selectedCommune;
    if (selectedTypeLogement != null) filters['typeLogement'] = selectedTypeLogement;
    if (priceRange.start > 0) filters['prixMin'] = priceRange.start;
    if (priceRange.end < 10000000) filters['prixMax'] = priceRange.end;
    if (selectedChambres != null) filters['nombreChambres'] = selectedChambres;
    if (selectedModalitePaiement != null) filters['modalitesPaiement'] = selectedModalitePaiement;
    if (withPhotos) filters['withPhotos'] = true;
    if (recentlyAdded) filters['recentlyAdded'] = true;
    if (maxVues != null) filters['maxVues'] = maxVues;
    
    widget.onApplyFilters(filters);
    Get.back();
  }
}

