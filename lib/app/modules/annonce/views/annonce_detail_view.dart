import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:carousel_slider/carousel_slider.dart'; // Remplacé par PageView
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/annonce_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/components/custom_button.dart';
import '../../../widgets/components/loading_widget.dart';
import '../../../models/annonce.dart';
import '../../../models/photo.dart';
import '../../../routes/app_routes.dart';

class AnnonceDetailView extends GetView<AnnonceController> {
  @override
  Widget build(BuildContext context) {
    final Annonce annonce = Get.arguments as Annonce;

    // Charger les détails de l'annonce
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadAnnonceDetail(annonce.id);
    });

    return WillPopScope(
      onWillPop: () async {
        // Gérer le bouton retour physique
        Get.back();
        return false; // Empêcher le comportement par défaut
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingWidget(message: 'Chargement des détails...');
          }

          final currentAnnonce = controller.currentAnnonce.value ?? annonce;

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(currentAnnonce),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainInfo(currentAnnonce),
                    _buildDescription(currentAnnonce),
                    _buildFeatures(currentAnnonce),
                    _buildLocation(currentAnnonce),
                    _buildOwnerInfo(currentAnnonce),
                    const SizedBox(
                      height: 100,
                    ), // Espace pour les boutons flottants
                  ],
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: _buildBottomActions(annonce),
      ),
    );
  }

  Widget _buildSliverAppBar(Annonce annonce) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(background: _buildImageCarousel(annonce)),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () => controller.shareAnnonceWithPhoto(annonce),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {
            Get.snackbar('Favoris', 'Ajouté aux favoris');
          },
        ),
      ],
    );
  }

  Widget _buildImageCarousel(Annonce annonce) {
    if (annonce.photos.isEmpty) {
      return Container(
        color: AppTheme.backgroundColor,
        child: const Center(
          child: Icon(Icons.home, size: 80, color: AppTheme.textLight),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: annonce.photos.length,
          onPageChanged: (index) {
            controller.setCurrentPhotoIndex(index);
          },
          itemBuilder: (context, index) {
            final photo = annonce.photos[index];
            return GestureDetector(
              onTap: () => _openPhotoViewer(annonce.photos, index),
              child: CachedNetworkImage(
                imageUrl: photo.url,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder:
                    (context, url) => Container(
                      color: AppTheme.backgroundColor,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: AppTheme.backgroundColor,
                      child: const Icon(Icons.error, size: 50),
                    ),
              ),
            );
          },
        ),

        // Indicateurs de photos
        if (annonce.photos.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  annonce.photos.asMap().entries.map((entry) {
                    return Obx(
                      () => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              controller.currentPhotoIndex.value == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

        // Badge type de logement
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.getTypeLogementColor(annonce.typeLogementDisplay),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              annonce.typeLogementDisplay,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfo(Annonce annonce) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            annonce.titre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

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
                  annonce.adresseComplete,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                annonce.prixFormate,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${annonce.vues} vues',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Annonce annonce) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            annonce.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(Annonce annonce) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Caractéristiques',
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
                child: _buildFeatureItem(
                  Icons.bed,
                  'Chambres',
                  '${annonce.nombreChambres}',
                ),
              ),
              Expanded(
                child: _buildFeatureItem(
                  Icons.home,
                  'Type',
                  annonce.typeLogementDisplay,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildPaymentInfo(annonce),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppTheme.primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(Annonce annonce) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Modalités de paiement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            annonce.modalitesPaiement,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(Annonce annonce) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Localisation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: AppTheme.textLight),
                  SizedBox(height: 8),
                  Text(
                    'Carte à venir',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            annonce.adresseComplete,
            style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo(Annonce annonce) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Propriétaire',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  annonce.proprietaire.prenom[0] + annonce.proprietaire.nom[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce.proprietaire.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Propriétaire',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    if (annonce.proprietaire.telephone != null)
                      Text(
                        annonce.proprietaire.telephone!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(Annonce annonce) {
    final telephone = annonce.proprietaire.telephone;
    final email = annonce.proprietaire.email;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (telephone != null && telephone.isNotEmpty)
            Expanded(
              child: ContactButton(
                icon: Icons.phone,
                label: 'Appeler',
                color: AppTheme.successColor,
                onPressed: () => controller.makePhoneCall(telephone),
              ),
            ),
          if (telephone != null && telephone.isNotEmpty)
            Expanded(
              child: ContactButton(
                icon: Icons.message,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onPressed: () => controller.openWhatsApp(telephone, annonce),
              ),
            ),
          if (email.isNotEmpty)
            Expanded(
              child: ContactButton(
                icon: Icons.email,
                label: 'Email',
                color: AppTheme.infoColor,
                onPressed: () => controller.sendEmail(email),
              ),
            ),
        ],
      ),
    );
  }

  void _openPhotoViewer(List<Photo> photos, int initialIndex) {
    Get.toNamed(
      AppRoutes.photoViewer,
      arguments: {'photos': photos, 'initialIndex': initialIndex},
    );
  }

  void _shareAnnonce(Annonce annonce) {
    // Implémentation du partage
    Get.snackbar(
      'Partage',
      'Partage de l\'annonce: ${annonce.titre}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
