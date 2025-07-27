# 🏠 Immobilier App

Une application Flutter moderne pour la gestion d'annonces immobilières au Sénégal, développée avec l'architecture GetX.

## 📱 Fonctionnalités

### 🔐 Authentification
- Inscription et connexion sécurisées
- Gestion des rôles (Client, Propriétaire, Admin)
- Validation des formulaires en temps réel
- Récupération de mot de passe

### 🏡 Gestion des Annonces
- **Pour les clients :**
  - Recherche avancée avec filtres
  - Navigation par type de logement
  - Visualisation détaillée des annonces
  - Contact direct avec les propriétaires
  - Système de favoris

- **Pour les propriétaires :**
  - Création et modification d'annonces
  - Upload de photos multiples
  - Gestion du portfolio d'annonces
  - Statistiques de vues
  - Outils de partage

### 👤 Profil Utilisateur
- Gestion des informations personnelles
- Statistiques personnalisées
- Paramètres de l'application
- Historique des activités

### 🤖 Chatbot Intelligent
- Assistant virtuel intégré
- Suggestions d'annonces personnalisées
- Réponses rapides
- Interface conversationnelle

## 🏗️ Architecture

### Structure du Projet
```
lib/
├── app/
│   ├── core/                 # Configuration globale
│   │   ├── app_binding.dart
│   │   ├── constants.dart
│   │   └── navigation_service.dart
│   ├── data/                 # Données et mocks
│   │   └── mocks/
│   ├── models/               # Modèles de données
│   │   ├── user.dart
│   │   ├── annonce.dart
│   │   ├── photo.dart
│   │   └── role.dart
│   ├── modules/              # Modules fonctionnels
│   │   ├── auth/
│   │   ├── home/
│   │   ├── profile/
│   │   ├── annonce/
│   │   └── chat/
│   ├── routes/               # Configuration des routes
│   ├── services/             # Services API
│   ├── theme/                # Thème et styles
│   └── widgets/              # Composants réutilisables
└── main.dart
```

### Technologies Utilisées
- **Flutter** 3.29.0 - Framework de développement
- **GetX** - Gestion d'état et navigation
- **Dart** 3.7.0 - Langage de programmation

### Packages Principaux
- `get: ^4.6.6` - State management et navigation
- `cached_network_image: ^3.3.1` - Cache d'images
- `carousel_slider: ^4.2.1` - Carrousel d'images
- `image_picker: ^1.0.7` - Sélection d'images
- `dio: ^5.4.1` - Client HTTP

## 🚀 Installation

### Prérequis
- Flutter SDK 3.29.0 ou supérieur
- Dart SDK 3.7.0 ou supérieur
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Étapes d'installation

1. **Cloner le projet**
```bash
git clone https://github.com/votre-repo/immobilier-app.git
cd immobilier-app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer l'environnement**
```bash
flutter doctor
```

4. **Lancer l'application**
```bash
flutter run
```

## 📊 Modèles de Données

### User
```dart
class User {
  final int id;
  final String prenom;
  final String nom;
  final String? region;
  final String? commune;
  final String email;
  final String password;
  final Role role;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### Annonce
```dart
class Annonce {
  final int id;
  final String titre;
  final String description;
  final double prix;
  final String modalitesPaiement;
  final TypeLogement typeLogement;
  final String region;
  final String commune;
  final String adresse;
  final int nombreChambres;
  final int vues;
  final User proprietaire;
  final List<Photo> photos;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

## 🎨 Interface Utilisateur

### Thème
- **Couleur principale :** Vert (#4CAF50)
- **Couleur secondaire :** Orange (#FF9800)
- **Design :** Material Design 3
- **Mode sombre :** Supporté

### Pages Principales
1. **Splash Screen** - Écran de démarrage animé
2. **Authentification** - Login/Register
3. **Accueil** - Liste des annonces avec filtres
4. **Détail Annonce** - Vue complète avec carrousel
5. **Profil** - Gestion du compte utilisateur
6. **Formulaire Annonce** - Création/modification
7. **Mes Annonces** - Gestion pour propriétaires

## 🔧 Configuration

### Services API
L'application utilise deux services :
- `ApiServiceMock` - Données de démonstration
- `ApiServiceBack` - API backend réelle

### Données de Test
Des données de démonstration sont disponibles dans `lib/app/data/mocks/mock_data.dart` :
- 3 utilisateurs de test
- 15 annonces variées
- Photos d'exemple
- Données géographiques du Sénégal

## 🧪 Tests

### Lancer les tests
```bash
flutter test
```

### Structure des tests
```
test/
├── unit/                 # Tests unitaires
├── widget/               # Tests de widgets
└── integration/          # Tests d'intégration
```

## 📱 Fonctionnalités Avancées

### Recherche et Filtres
- Recherche textuelle intelligente
- Filtres par région/commune
- Filtres par prix et type
- Tri par pertinence/prix/date

### Contact Propriétaires
- Appel téléphonique direct
- Message WhatsApp
- Envoi d'email
- Partage d'annonces

### Chatbot
- Intelligence artificielle intégrée
- Suggestions contextuelles
- Historique des conversations
- Réponses rapides prédéfinies

## 🌍 Localisation

### Régions Supportées
L'application couvre toutes les régions du Sénégal :
- Dakar (16 communes)
- Thiès (8 communes)
- Saint-Louis (4 communes)
- Et 11 autres régions...

## 🔒 Sécurité

### Authentification
- Validation côté client et serveur
- Hashage des mots de passe
- Tokens JWT pour les sessions
- Protection contre les attaques CSRF

### Données
- Validation stricte des entrées
- Sanitisation des données
- Chiffrement des données sensibles

## 📈 Performance

### Optimisations
- Lazy loading des images
- Pagination des listes
- Cache intelligent
- Compression des images

### Métriques
- Temps de démarrage < 3s
- Navigation fluide 60fps
- Consommation mémoire optimisée

## 🤝 Contribution

### Guidelines
1. Fork le projet
2. Créer une branche feature
3. Commiter les changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

### Standards de Code
- Respect des conventions Dart/Flutter
- Documentation des fonctions publiques
- Tests unitaires obligatoires
- Revue de code requise

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Équipe

- **Développeur Principal** - Architecture et développement
- **Designer UI/UX** - Interface utilisateur
- **Product Owner** - Spécifications fonctionnelles

## 📞 Support

- **Email :** support@immobilier-app.com
- **Téléphone :** +221 77 123 45 67
- **Documentation :** [Wiki du projet](https://github.com/votre-repo/immobilier-app/wiki)

## 🔄 Roadmap

### Version 1.1
- [ ] Notifications push
- [ ] Mode hors ligne
- [ ] Géolocalisation avancée

### Version 1.2
- [ ] Paiements intégrés
- [ ] Visites virtuelles
- [ ] API publique

### Version 2.0
- [ ] Intelligence artificielle avancée
- [ ] Réalité augmentée
- [ ] Blockchain pour les transactions

---

**Immobilier App** - Trouvez votre logement idéal au Sénégal 🇸🇳

# Galsen_house
