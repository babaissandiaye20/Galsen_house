import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../models/annonce.dart';

class NavigationService {
  // Navigation vers les pages d'authentification
  static void toLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  static void toRegister() {
    Get.toNamed(AppRoutes.register);
  }

  static void toHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  // Navigation vers les pages principales
  static void toProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  // Navigation vers les pages d'annonces
  static void toAnnonceDetail(Annonce annonce) {
    Get.toNamed(AppRoutes.annonceDetail, arguments: annonce);
  }

  static void toAnnonceForm({Annonce? annonce}) {
    Get.toNamed(AppRoutes.annonceForm, arguments: annonce);
  }

  static void toMesAnnonces() {
    Get.toNamed(AppRoutes.mesAnnonces);
  }

  // Navigation avec retour
  static void back() {
    Get.back();
  }

  static void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  // Navigation avec remplacement
  static void offToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  static void offToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  // Vérification de la route actuelle
  static bool get isOnHomePage => Get.currentRoute == AppRoutes.home;
  static bool get isOnLoginPage => Get.currentRoute == AppRoutes.login;
  static bool get isOnProfilePage => Get.currentRoute == AppRoutes.profile;

  // Navigation avec paramètres
  static void toAnnonceDetailWithId(int annonceId) {
    Get.toNamed('${AppRoutes.annonceDetail}/$annonceId');
  }

  // Navigation conditionnelle
  static void toHomeOrLogin({required bool isLoggedIn}) {
    if (isLoggedIn) {
      toHome();
    } else {
      toLogin();
    }
  }

  // Gestion des erreurs de navigation
  static void handleNavigationError(String error) {
    Get.snackbar(
      'Erreur de navigation',
      error,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Navigation avec confirmation
  static void confirmAndNavigate({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  // Navigation avec animation personnalisée
  static void toWithCustomTransition({
    required String route,
    dynamic arguments,
    Transition? transition,
    Duration? duration,
  }) {
    Get.toNamed(route, arguments: arguments);
  }

  // Gestion du retour système (Android)
  static Future<bool> onWillPop() async {
    if (Get.currentRoute == AppRoutes.home) {
      // Si on est sur la page d'accueil, demander confirmation pour quitter
      bool? shouldExit = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Quitter l\'application'),
          content: const Text('Voulez-vous vraiment quitter l\'application ?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Oui'),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    } else {
      // Sinon, navigation normale
      Get.back();
      return false;
    }
  }
}
