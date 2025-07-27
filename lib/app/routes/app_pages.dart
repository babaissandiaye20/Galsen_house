import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import des vues
import '../modules/auth/views/splash_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/annonce/views/annonce_detail_view.dart';
import '../modules/annonce/views/annonce_form_view.dart';
import '../modules/annonce/views/mes_annonces_view.dart';
import '../modules/annonce/views/photo_viewer_view.dart';
import '../modules/chat/views/chat_view.dart';

// Import des bindings
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/annonce/bindings/annonce_binding.dart';
import '../modules/chat/bindings/chat_binding.dart';

// Import des routes
import 'app_routes.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

  static final List<GetPage> routes = [
    // Page de démarrage
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Pages d'authentification
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Page d'accueil
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Page de profil
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Pages des annonces
    GetPage(
      name: AppRoutes.annonceDetail,
      page: () => AnnonceDetailView(),
      binding: AnnonceBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.annonceForm,
      page: () => AnnonceFormView(),
      binding: AnnonceBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.mesAnnonces,
      page: () => MesAnnoncesView(),
      binding: AnnonceBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Page du visualiseur de photos
    GetPage(
      name: AppRoutes.photoViewer,
      page:
          () => PhotoViewerView(
            photos: Get.arguments['photos'],
            initialIndex: Get.arguments['initialIndex'] ?? 0,
          ),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Page du chat
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatView(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];

  // Middleware pour la protection des routes
  static List<GetMiddleware> get middlewares => [AuthMiddleware()];
}

// Middleware d'authentification
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Pour la démo, on laisse passer toutes les routes
    // Dans une vraie app, on vérifierait le token d'authentification

    // Routes publiques (pas besoin d'authentification)
    final publicRoutes = [
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.home,
      AppRoutes.annonceDetail,
      AppRoutes.photoViewer,
    ];

    // Pour l'instant, toutes les routes sont publiques
    return null;
  }
}
