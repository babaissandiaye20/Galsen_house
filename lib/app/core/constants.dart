class AppConstants {
  // Informations de l'application
  static const String appName = 'Immobilier App';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Application de gestion d\'annonces immobilières';
  
  // Configuration API
  static const String baseUrl = 'https://api.immobilier-app.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Configuration de pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  
  // Configuration des images
  static const int maxPhotosPerAnnonce = 10;
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];
  
  // Configuration du cache
  static const Duration cacheExpiration = Duration(hours: 1);
  static const int maxCacheSize = 100; // Nombre d'éléments
  
  // Clés de stockage local
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String favoritesKey = 'favorites';
  
  // Messages d'erreur
  static const String networkErrorMessage = 'Erreur de connexion. Vérifiez votre connexion internet.';
  static const String serverErrorMessage = 'Erreur du serveur. Veuillez réessayer plus tard.';
  static const String unknownErrorMessage = 'Une erreur inattendue s\'est produite.';
  static const String validationErrorMessage = 'Veuillez vérifier les informations saisies.';
  
  // Messages de succès
  static const String loginSuccessMessage = 'Connexion réussie !';
  static const String registerSuccessMessage = 'Inscription réussie !';
  static const String updateSuccessMessage = 'Mise à jour réussie !';
  static const String deleteSuccessMessage = 'Suppression réussie !';
  
  // Configuration du chat
  static const int maxMessageLength = 500;
  static const Duration typingIndicatorDelay = Duration(seconds: 2);
  static const int maxChatHistory = 100;
  
  // Régions et communes du Sénégal
  static const Map<String, List<String>> regionsCommunes = {
    'Dakar': [
      'Almadies',
      'Biscuiterie',
      'Dieuppeul-Derklé',
      'Grand Dakar',
      'Gueule Tapée-Fass-Colobane',
      'HLM',
      'Médina',
      'Mermoz-Sacré-Cœur',
      'Ngor',
      'Ouakam',
      'Parcelles Assainies',
      'Patte d\'Oie',
      'Plateau',
      'Point E',
      'Sicap Liberté',
      'Yoff',
    ],
    'Thiès': [
      'Thiès Nord',
      'Thiès Sud',
      'Thiès Est',
      'Thiès Ouest',
      'Mbour',
      'Tivaouane',
      'Joal-Fadiouth',
      'Popenguine',
    ],
    'Saint-Louis': [
      'Saint-Louis',
      'Dagana',
      'Podor',
      'Richard Toll',
    ],
    'Diourbel': [
      'Diourbel',
      'Bambey',
      'Mbacké',
      'Touba',
    ],
    'Louga': [
      'Louga',
      'Kebemer',
      'Linguère',
    ],
    'Fatick': [
      'Fatick',
      'Foundiougne',
      'Gossas',
      'Sokone',
    ],
    'Kaolack': [
      'Kaolack',
      'Guinguinéo',
      'Kaffrine',
      'Nioro du Rip',
    ],
    'Tambacounda': [
      'Tambacounda',
      'Bakel',
      'Goudiry',
      'Koumpentoum',
    ],
    'Kolda': [
      'Kolda',
      'Médina Yoro Foulah',
      'Vélingara',
    ],
    'Ziguinchor': [
      'Ziguinchor',
      'Bignona',
      'Oussouye',
    ],
    'Matam': [
      'Matam',
      'Kanel',
      'Ranérou',
    ],
    'Kaffrine': [
      'Kaffrine',
      'Birkelane',
      'Koungheul',
      'Malem-Hodar',
    ],
    'Kédougou': [
      'Kédougou',
      'Salémata',
      'Saraya',
    ],
    'Sédhiou': [
      'Sédhiou',
      'Bounkiling',
      'Goudomp',
    ],
  };
  
  // Types de logement avec leurs couleurs
  static const Map<String, String> typeLogementColors = {
    'VILLA': '#4CAF50',
    'MAISON': '#2196F3',
    'APPARTEMENT': '#FF9800',
    'STUDIO': '#9C27B0',
    'CHAMBRE': '#607D8B',
  };
  
  // Configuration des notifications
  static const Duration notificationDuration = Duration(seconds: 3);
  static const int maxNotifications = 5;
  
  // Configuration de la recherche
  static const int minSearchLength = 2;
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);
  
  // Expressions régulières
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^(\+221|00221)?[0-9]{9}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';
  
  // URLs utiles
  static const String privacyPolicyUrl = 'https://immobilier-app.com/privacy';
  static const String termsOfServiceUrl = 'https://immobilier-app.com/terms';
  static const String supportEmail = 'support@immobilier-app.com';
  static const String supportPhone = '+221 77 123 45 67';
  
  // Configuration des animations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Configuration des bordures et rayons
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Configuration des espacements
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Configuration des tailles de police
  static const double smallFontSize = 12.0;
  static const double mediumFontSize = 14.0;
  static const double largeFontSize = 16.0;
  static const double titleFontSize = 18.0;
  static const double headerFontSize = 24.0;
}

