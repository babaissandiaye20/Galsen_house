import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/annonce.dart';
import '../../theme/app_theme.dart';

class AnnonceCard extends StatelessWidget {
  final Annonce annonce;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool showActions;

  const AnnonceCard({
    Key? key,
    required this.annonce,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImageSection(), _buildContentSection()],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          child:
              annonce.mainPhotoUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: annonce.mainPhotoUrl,
                  fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                    color: AppTheme.backgroundColor,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                    errorWidget:
                        (context, url, error) => Container(
                    color: AppTheme.backgroundColor,
                    child: const Icon(
                      Icons.home,
                      size: 64,
                      color: AppTheme.textLight,
                    ),
                  ),
                )
              : Container(
                  color: AppTheme.backgroundColor,
                  child: const Icon(
                    Icons.home,
                    size: 64,
                    color: AppTheme.textLight,
                  ),
                ),
        ),
        
        // Badge type de logement
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.getTypeLogementColor(annonce.typeLogementDisplay),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              annonce.typeLogementDisplay,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        
        // Bouton favori
        if (showActions)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppTheme.textSecondary,
                ),
                onPressed: onFavorite,
              ),
            ),
          ),
        
        // Indicateur nombre de photos
        if (annonce.photos.length > 1)
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${annonce.photos.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Text(
            annonce.titre,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          // Localisation
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${annonce.commune}, ${annonce.region}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Caractéristiques
          Row(
            children: [
              _buildFeature(Icons.bed, '${annonce.nombreChambres} ch.'),
              const SizedBox(width: 16),
              _buildFeature(Icons.visibility, '${annonce.vues} vues'),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Prix et actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  annonce.prixFormate,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              
              if (showActions)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareAnnonce(),
                      color: AppTheme.textSecondary,
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () => _contactProprietaire(),
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _shareAnnonce() {
    // Implémentation du partage
    // Share.share('Découvrez cette annonce: ${annonce.titre}');
  }

  void _contactProprietaire() {
    // Implémentation du contact
    // Cette méthode sera appelée depuis le parent
  }
}

// Widget compact pour les listes horizontales
class AnnonceCardCompact extends StatelessWidget {
  final Annonce annonce;
  final VoidCallback? onTap;

  const AnnonceCardCompact({Key? key, required this.annonce, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                height: 140,
                width: double.infinity,
                child:
                    annonce.mainPhotoUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: annonce.mainPhotoUrl,
                        fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                          color: AppTheme.backgroundColor,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                          errorWidget:
                              (context, url, error) => Container(
                          color: AppTheme.backgroundColor,
                          child: const Icon(
                            Icons.home,
                            size: 48,
                            color: AppTheme.textLight,
                          ),
                        ),
                      )
                    : Container(
                        color: AppTheme.backgroundColor,
                        child: const Icon(
                          Icons.home,
                          size: 48,
                          color: AppTheme.textLight,
                        ),
                      ),
              ),
              
              // Contenu
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce.titre,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      '${annonce.commune}, ${annonce.region}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      annonce.prixFormate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
