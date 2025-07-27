import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';

class ModernSearchBar extends StatefulWidget {
  final String? hint;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onFilterTap;
  final VoidCallback? onMicTap;
  final TextEditingController? controller;
  final bool showFilter;
  final bool showMic;
  final int filterCount;

  const ModernSearchBar({
    Key? key,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.onMicTap,
    this.controller,
    this.showFilter = true,
    this.showMic = true,
    this.filterCount = 0,
  }) : super(key: key);

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: _isFocused 
                      ? AppTheme.primaryColor.withOpacity(0.2)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: _isFocused ? 12 : 8,
                  offset: const Offset(0, 4),
                  spreadRadius: _isFocused ? 2 : 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Icône de recherche
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 12),
                  child: Icon(
                    Icons.search,
                    color: _isFocused ? AppTheme.primaryColor : AppTheme.textSecondary,
                    size: 24,
                  ),
                ),

                // Champ de texte
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    onTap: () {
                      setState(() {
                        _isFocused = true;
                      });
                      _animationController.forward();
                    },
                    onEditingComplete: () {
                      setState(() {
                        _isFocused = false;
                      });
                      _animationController.reverse();
                    },
                    decoration: InputDecoration(
                      hintText: widget.hint ?? 'Rechercher un logement...',
                      hintStyle: TextStyle(
                        color: AppTheme.textSecondary.withOpacity(0.7),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),

                // Bouton microphone
                if (widget.showMic)
                  _buildActionButton(
                    icon: Icons.mic,
                    onTap: widget.onMicTap,
                    tooltip: 'Recherche vocale',
                  ),

                // Bouton filtres
                if (widget.showFilter)
                  _buildFilterButton(),

                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Tooltip(
      message: 'Filtres',
      child: InkWell(
        onTap: widget.onFilterTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Icon(
                Icons.tune,
                color: widget.filterCount > 0 
                    ? AppTheme.primaryColor 
                    : AppTheme.textSecondary,
                size: 22,
              ),
              if (widget.filterCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${widget.filterCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget de suggestions de recherche
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final VoidCallback? onClearHistory;

  const SearchSuggestions({
    Key? key,
    required this.suggestions,
    required this.onSuggestionTap,
    this.onClearHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recherches récentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (onClearHistory != null)
                  TextButton(
                    onPressed: onClearHistory,
                    child: const Text(
                      'Effacer',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Liste des suggestions
          ...suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return InkWell(
      onTap: () => onSuggestionTap(suggestion),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.history,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.north_west,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de recherche rapide avec catégories
class QuickSearchCategories extends StatelessWidget {
  final List<QuickSearchCategory> categories;
  final Function(QuickSearchCategory) onCategoryTap;

  const QuickSearchCategories({
    Key? key,
    required this.categories,
    required this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Recherche rapide',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) => _buildCategoryChip(category)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(QuickSearchCategory category) {
    return InkWell(
      onTap: () => onCategoryTap(category),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: category.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color: category.color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: TextStyle(
                color: category.color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modèle pour les catégories de recherche rapide
class QuickSearchCategory {
  final String label;
  final IconData icon;
  final Color color;
  final String query;

  const QuickSearchCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.query,
  });
}

// Catégories prédéfinies
class DefaultQuickSearchCategories {
  static const List<QuickSearchCategory> categories = [
    QuickSearchCategory(
      label: 'Villa',
      icon: Icons.villa,
      color: AppTheme.villaColor,
      query: 'villa',
    ),
    QuickSearchCategory(
      label: 'Appartement',
      icon: Icons.apartment,
      color: AppTheme.appartementColor,
      query: 'appartement',
    ),
    QuickSearchCategory(
      label: 'Studio',
      icon: Icons.home,
      color: AppTheme.studioColor,
      query: 'studio',
    ),
    QuickSearchCategory(
      label: 'Dakar',
      icon: Icons.location_city,
      color: AppTheme.primaryColor,
      query: 'Dakar',
    ),
    QuickSearchCategory(
      label: 'Moins de 500k',
      icon: Icons.attach_money,
      color: AppTheme.successColor,
      query: 'prix:0-500000',
    ),
  ];
}

