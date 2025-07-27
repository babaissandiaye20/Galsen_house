import 'package:get/get.dart';
import '../models/user.dart';
import '../models/annonce.dart';
import '../models/role.dart';
import '../data/mocks/mock_data.dart';

class ApiServiceMock extends GetxService {
  // Simulation d'un délai réseau
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 500 + (DateTime.now().millisecond % 1000)));
  }

  // Authentification
  Future<Map<String, dynamic>> login(String email, String password) async {
    await _simulateNetworkDelay();
    
    try {
      final user = MockData.users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      
      return {
        'success': true,
        'user': user.toJson(),
        'token': 'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Connexion réussie'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Email ou mot de passe incorrect'
      };
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    await _simulateNetworkDelay();
    
    try {
      // Vérifier si l'email existe déjà
      final existingUser = MockData.users.where((u) => u.email == userData['email']).isNotEmpty;
      
      if (existingUser) {
        return {
          'success': false,
          'message': 'Cet email est déjà utilisé'
        };
      }

      // Créer un nouvel utilisateur
      final newUser = User(
        id: MockData.users.length + 1,
        prenom: userData['prenom'],
        nom: userData['nom'],
        region: userData['region'],
        commune: userData['commune'],
        email: userData['email'],
        password: userData['password'],
        role: MockData.roles.firstWhere((r) => r.name.toString().split('.').last == userData['role']),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      MockData.users.add(newUser);

      return {
        'success': true,
        'user': newUser.toJson(),
        'token': 'mock_token_${newUser.id}_${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Inscription réussie'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de l\'inscription'
      };
    }
  }

  // Gestion des annonces
  Future<Map<String, dynamic>> getAnnonces({
    String? region,
    String? commune,
    TypeLogement? typeLogement,
    double? prixMin,
    double? prixMax,
    int page = 1,
    int limit = 10,
  }) async {
    await _simulateNetworkDelay();

    try {
      var filteredAnnonces = List<Annonce>.from(MockData.annonces);

      // Appliquer les filtres
      if (region != null && region.isNotEmpty) {
        filteredAnnonces = filteredAnnonces.where((a) => a.region.toLowerCase().contains(region.toLowerCase())).toList();
      }

      if (commune != null && commune.isNotEmpty) {
        filteredAnnonces = filteredAnnonces.where((a) => a.commune.toLowerCase().contains(commune.toLowerCase())).toList();
      }

      if (typeLogement != null) {
        filteredAnnonces = filteredAnnonces.where((a) => a.typeLogement == typeLogement).toList();
      }

      if (prixMin != null) {
        filteredAnnonces = filteredAnnonces.where((a) => a.prix >= prixMin).toList();
      }

      if (prixMax != null) {
        filteredAnnonces = filteredAnnonces.where((a) => a.prix <= prixMax).toList();
      }

      // Pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      final paginatedAnnonces = filteredAnnonces.skip(startIndex).take(limit).toList();

      return {
        'success': true,
        'data': paginatedAnnonces.map((a) => a.toJson()).toList(),
        'pagination': {
          'currentPage': page,
          'totalPages': (filteredAnnonces.length / limit).ceil(),
          'totalItems': filteredAnnonces.length,
          'hasNext': endIndex < filteredAnnonces.length,
          'hasPrevious': page > 1,
        }
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la récupération des annonces'
      };
    }
  }

  Future<Map<String, dynamic>> getAnnonceById(int id) async {
    await _simulateNetworkDelay();

    try {
      final annonce = MockData.annonces.firstWhere((a) => a.id == id);
      
      // Incrémenter les vues
      final index = MockData.annonces.indexWhere((a) => a.id == id);
      if (index != -1) {
        MockData.annonces[index] = annonce.copyWith(vues: annonce.vues + 1);
      }

      return {
        'success': true,
        'data': MockData.annonces[index].toJson()
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Annonce non trouvée'
      };
    }
  }

  Future<Map<String, dynamic>> createAnnonce(Map<String, dynamic> annonceData) async {
    await _simulateNetworkDelay();

    try {
      final newAnnonce = Annonce(
        id: MockData.annonces.length + 1,
        titre: annonceData['titre'],
        description: annonceData['description'],
        prix: annonceData['prix'].toDouble(),
        modalitesPaiement: annonceData['modalitesPaiement'],
        typeLogement: TypeLogement.values.firstWhere(
          (e) => e.toString().split('.').last == annonceData['typeLogement']
        ),
        region: annonceData['region'],
        commune: annonceData['commune'],
        adresse: annonceData['adresse'],
        nombreChambres: annonceData['nombreChambres'],
        vues: 0,
        proprietaire: MockData.users.firstWhere((u) => u.id == annonceData['proprietaireId']),
        photos: [], // Les photos seront ajoutées séparément
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      MockData.annonces.add(newAnnonce);

      return {
        'success': true,
        'data': newAnnonce.toJson(),
        'message': 'Annonce créée avec succès'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la création de l\'annonce'
      };
    }
  }

  Future<Map<String, dynamic>> updateAnnonce(int id, Map<String, dynamic> annonceData) async {
    await _simulateNetworkDelay();

    try {
      final index = MockData.annonces.indexWhere((a) => a.id == id);
      if (index == -1) {
        return {
          'success': false,
          'message': 'Annonce non trouvée'
        };
      }

      final currentAnnonce = MockData.annonces[index];
      final updatedAnnonce = currentAnnonce.copyWith(
        titre: annonceData['titre'] ?? currentAnnonce.titre,
        description: annonceData['description'] ?? currentAnnonce.description,
        prix: annonceData['prix']?.toDouble() ?? currentAnnonce.prix,
        modalitesPaiement: annonceData['modalitesPaiement'] ?? currentAnnonce.modalitesPaiement,
        typeLogement: annonceData['typeLogement'] != null 
          ? TypeLogement.values.firstWhere((e) => e.toString().split('.').last == annonceData['typeLogement'])
          : currentAnnonce.typeLogement,
        region: annonceData['region'] ?? currentAnnonce.region,
        commune: annonceData['commune'] ?? currentAnnonce.commune,
        adresse: annonceData['adresse'] ?? currentAnnonce.adresse,
        nombreChambres: annonceData['nombreChambres'] ?? currentAnnonce.nombreChambres,
        updatedAt: DateTime.now(),
      );

      MockData.annonces[index] = updatedAnnonce;

      return {
        'success': true,
        'data': updatedAnnonce.toJson(),
        'message': 'Annonce mise à jour avec succès'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la mise à jour de l\'annonce'
      };
    }
  }

  Future<Map<String, dynamic>> deleteAnnonce(int id) async {
    await _simulateNetworkDelay();

    try {
      final index = MockData.annonces.indexWhere((a) => a.id == id);
      if (index == -1) {
        return {
          'success': false,
          'message': 'Annonce non trouvée'
        };
      }

      MockData.annonces.removeAt(index);
      // Supprimer aussi les photos associées
      MockData.photos.removeWhere((p) => p.annonceId == id);

      return {
        'success': true,
        'message': 'Annonce supprimée avec succès'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la suppression de l\'annonce'
      };
    }
  }

  Future<Map<String, dynamic>> getAnnoncesByProprietaire(int proprietaireId) async {
    await _simulateNetworkDelay();

    try {
      final annonces = MockData.annonces.where((a) => a.proprietaire.id == proprietaireId).toList();

      return {
        'success': true,
        'data': annonces.map((a) => a.toJson()).toList()
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la récupération des annonces'
      };
    }
  }

  // Gestion du profil utilisateur
  Future<Map<String, dynamic>> updateProfile(int userId, Map<String, dynamic> userData) async {
    await _simulateNetworkDelay();

    try {
      final index = MockData.users.indexWhere((u) => u.id == userId);
      if (index == -1) {
        return {
          'success': false,
          'message': 'Utilisateur non trouvé'
        };
      }

      final currentUser = MockData.users[index];
      final updatedUser = currentUser.copyWith(
        prenom: userData['prenom'] ?? currentUser.prenom,
        nom: userData['nom'] ?? currentUser.nom,
        region: userData['region'] ?? currentUser.region,
        commune: userData['commune'] ?? currentUser.commune,
        email: userData['email'] ?? currentUser.email,
        updatedAt: DateTime.now(),
      );

      MockData.users[index] = updatedUser;

      return {
        'success': true,
        'data': updatedUser.toJson(),
        'message': 'Profil mis à jour avec succès'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la mise à jour du profil'
      };
    }
  }

  // Statistiques
  Future<Map<String, dynamic>> getStatistiques(int proprietaireId) async {
    await _simulateNetworkDelay();

    try {
      final annonces = MockData.annonces.where((a) => a.proprietaire.id == proprietaireId).toList();
      final totalVues = annonces.fold<int>(0, (sum, a) => sum + a.vues);

      return {
        'success': true,
        'data': {
          'totalAnnonces': annonces.length,
          'totalVues': totalVues,
          'moyenneVues': annonces.isNotEmpty ? (totalVues / annonces.length).round() : 0,
          'annoncesPlusVues': annonces..sort((a, b) => b.vues.compareTo(a.vues)),
        }
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la récupération des statistiques'
      };
    }
  }

  // Utilitaires
  Future<Map<String, dynamic>> getRegions() async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'data': MockData.regions
    };
  }

  Future<Map<String, dynamic>> getCommunesByRegion(String region) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'data': MockData.communesParRegion[region] ?? []
    };
  }
}

