import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/core/app_binding.dart';
import 'app/core/navigation_service.dart';

void main() async {
  // Assurer l'initialisation des widgets Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de l'orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configuration de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Immobilier App',

      // Configuration du thème
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Configuration de la navigation
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),

      // Configuration de la localisation
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),

      // Configuration du debug
      debugShowCheckedModeBanner: false,

      // Configuration des transitions par défaut
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),

      // Configuration des snackbars
      // Note: GetX ne supporte pas directement snackBarTheme dans GetMaterialApp

      // Gestion des erreurs de navigation
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const NotFoundPage(),
      ),

      // Configuration de la gestion du retour système
      builder: (context, child) {
        return WillPopScope(
          onWillPop: NavigationService.onWillPop,
          child: child!,
        );
      },
    );
  }
}

// Page d'erreur 404
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Page non trouvée'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppTheme.errorColor,
              ),

              const SizedBox(height: 24),

              const Text(
                'Page non trouvée',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'La page que vous recherchez n\'existe pas.',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () => Get.offAllNamed('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
