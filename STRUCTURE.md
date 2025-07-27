# 📁 Structure du Projet Immobilier App

## 🏗️ Architecture Générale

L'application suit l'architecture **GetX** avec une séparation claire des responsabilités :

```
immobilier_app/
├── lib/
│   ├── app/                          # Code principal de l'application
│   │   ├── core/                     # Configuration et services globaux
│   │   ├── data/                     # Données et mocks
│   │   ├── models/                   # Modèles de données
│   │   ├── modules/                  # Modules fonctionnels (MVC)
│   │   ├── routes/                   # Configuration des routes
│   │   ├── services/                 # Services API
│   │   ├── theme/                    # Thème et styles
│   │   └── widgets/                  # Composants réutilisables
│   └── main.dart                     # Point d'entrée de l'application
├── pubspec.yaml                      # Configuration des dépendances
├── README.md                         # Documentation principale
└── STRUCTURE.md                      # Ce fichier
```

## 📂 Détail des Dossiers

### `/lib/app/core/` - Configuration Globale
```
core/
├── app_binding.dart          # Injection de dépendances globales
├── constants.dart            # Constantes de l'application
└── navigation_service.dart   # Service de navigation centralisé
```

### `/lib/app/data/` - Données et Mocks
```
data/
└── mocks/
    └── mock_data.dart        # Données de démonstration
```

### `/lib/app/models/` - Modèles de Données
```
models/
├── annonce.dart              # Modèle Annonce avec TypeLogement
├── photo.dart                # Modèle Photo
├── role.dart                 # Modèle Role avec RoleType
└── user.dart                 # Modèle User
```

### `/lib/app/modules/` - Modules Fonctionnels
Chaque module suit le pattern **MVC** de GetX :

```
modules/
├── auth/                     # Module d'authentification
│   ├── bindings/
│   │   └── auth_binding.dart
│   ├── controllers/
│   │   └── auth_controller.dart
│   └── views/
│       ├── login_view.dart
│       ├── register_view.dart
│       └── splash_view.dart
├── home/                     # Module page d'accueil
│   ├── bindings/
│   │   └── home_binding.dart
│   ├── controllers/
│   │   └── home_controller.dart
│   └── views/
│       └── home_view.dart
├── profile/                  # Module profil utilisateur
│   ├── bindings/
│   │   └── profile_binding.dart
│   ├── controllers/
│   │   └── profile_controller.dart
│   └── views/
│       └── profile_view.dart
├── annonce/                  # Module gestion des annonces
│   ├── bindings/
│   │   └── annonce_binding.dart
│   ├── controllers/
│   │   └── annonce_controller.dart
│   └── views/
│       ├── annonce_detail_view.dart
│       ├── annonce_form_view.dart
│       └── mes_annonces_view.dart
└── chat/                     # Module chatbot
    ├── bindings/
    │   └── chat_binding.dart
    └── controllers/
        └── chat_controller.dart
```

### `/lib/app/routes/` - Configuration des Routes
```
routes/
├── app_pages.dart            # Configuration des pages GetX
└── app_routes.dart           # Définition des routes
```

### `/lib/app/services/` - Services API
```
services/
├── api_service_back.dart     # Service API backend réel
└── api_service_mock.dart     # Service API avec mocks
```

### `/lib/app/theme/` - Thème et Styles
```
theme/
└── app_theme.dart            # Configuration du thème Material
```

### `/lib/app/widgets/` - Composants Réutilisables
```
widgets/
└── components/
    ├── annonce_card.dart     # Cartes d'annonces
    ├── chat_widget.dart      # Interface de chat
    ├── custom_button.dart    # Boutons personnalisés
    ├── custom_text_field.dart # Champs de texte
    └── loading_widget.dart   # Widgets de chargement
```

## 🔄 Flux de Données

### 1. Architecture GetX
```
View (UI) ↔ Controller (Logic) ↔ Service (API) ↔ Model (Data)
```

### 2. Injection de Dépendances
```
AppBinding (Global) → ModuleBinding (Local) → Controller → Service
```

### 3. Navigation
```
NavigationService → GetX Router → Page → Binding → Controller
```

## 📊 Statistiques du Projet

- **Total de fichiers Dart :** 37
- **Modules fonctionnels :** 5 (auth, home, profile, annonce, chat)
- **Modèles de données :** 4 (User, Annonce, Photo, Role)
- **Pages/Vues :** 8 principales
- **Composants réutilisables :** 5 widgets
- **Services :** 2 (mock et backend)

## 🎯 Responsabilités par Couche

### **Models** - Couche de Données
- Définition des structures de données
- Sérialisation/Désérialisation JSON
- Validation des données
- Relations entre entités

### **Services** - Couche d'Accès aux Données
- Communication avec l'API
- Gestion du cache
- Transformation des données
- Gestion des erreurs réseau

### **Controllers** - Couche Logique Métier
- Gestion de l'état de l'application
- Logique métier
- Validation des formulaires
- Coordination entre vues et services

### **Views** - Couche Présentation
- Interface utilisateur
- Gestion des interactions
- Affichage des données
- Navigation entre écrans

### **Widgets** - Composants Réutilisables
- Composants UI personnalisés
- Logique d'affichage commune
- Styles cohérents
- Optimisation des performances

## 🔧 Configuration et Bindings

### Bindings Hierarchy
```
AppBinding (Global)
├── AuthBinding (auth module)
├── HomeBinding + ChatBinding (home module)
├── ProfileBinding (profile module)
└── AnnonceBinding (annonce module)
```

### Services Registration
```
AppBinding:
  - ApiServiceMock (permanent)
  - ApiServiceBack (permanent)

ModuleBindings:
  - Controllers (lazy, fenix)
  - Module-specific services
```

## 🚀 Points d'Entrée

### 1. Application
```dart
main.dart → MyApp → GetMaterialApp → AppPages.routes
```

### 2. Navigation
```dart
SplashView → LoginView → HomeView → [Other Pages]
```

### 3. Services
```dart
AppBinding → Services → Controllers → Views
```

## 📱 Fonctionnalités par Module

### **Auth Module**
- Splash screen avec animations
- Connexion avec validation
- Inscription complète
- Gestion des sessions

### **Home Module**
- Liste des annonces
- Recherche et filtres
- Navigation par catégories
- Pagination

### **Profile Module**
- Gestion du profil
- Statistiques utilisateur
- Paramètres
- Déconnexion

### **Annonce Module**
- Détail des annonces
- Formulaire de création/modification
- Gestion des photos
- Contact propriétaires

### **Chat Module**
- Chatbot intelligent
- Suggestions d'annonces
- Interface conversationnelle
- Historique des messages

## 🎨 Design System

### Thème
- **Primary Color:** #4CAF50 (Vert)
- **Secondary Color:** #FF9800 (Orange)
- **Surface Color:** #FFFFFF
- **Background Color:** #F5F5F5

### Composants
- Boutons avec états (primary, secondary, outline, text, danger)
- Champs de texte avec validation
- Cartes d'annonces responsives
- Widgets de chargement avec shimmer
- Interface de chat moderne

Cette structure garantit une maintenabilité optimale, une séparation claire des responsabilités et une évolutivité future de l'application.

