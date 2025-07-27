import 'package:get/get.dart';
import '../models/annonce.dart';
import '../data/mocks/mock_data.dart';
import 'annonce_service.dart';
import 'api_service_mock.dart';

class AnnonceServiceMock extends AnnonceService {
  final ApiServiceMock _apiServiceMock = Get.find<ApiServiceMock>();

  AnnonceServiceMock() : super();

  @override
  Future<Map<String, dynamic>> createAnnonce(
    Map<String, dynamic> annonceData,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': annonceData,
        'message': 'Annonce créée avec succès',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAnnonces({
    String? region,
    String? commune,
    TypeLogement? typeLogement,
    double? prixMin,
    double? prixMax,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('🔍 Service: Début getAnnonces');
      print(
        '📊 Service: Nombre d\'annonces dans MockData: ${MockData.annonces.length}',
      );

      await Future.delayed(Duration(milliseconds: 500));

      List<Annonce> filteredAnnonces = List.from(MockData.annonces);
      print('📊 Service: Annonces après copie: ${filteredAnnonces.length}');

      // Appliquer les filtres
      if (region != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.region == region).toList();
      }
      if (commune != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.commune == commune).toList();
      }
      if (typeLogement != null) {
        filteredAnnonces =
            filteredAnnonces
                .where((a) => a.typeLogement == typeLogement)
                .toList();
      }
      if (prixMin != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.prix >= prixMin).toList();
      }
      if (prixMax != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.prix <= prixMax).toList();
      }

      print('📊 Service: Annonces après filtrage: ${filteredAnnonces.length}');
      print(
        '📊 Service: Données retournées: ${filteredAnnonces.map((a) => a.toJson()).toList().length}',
      );

      return {
        'success': true,
        'data': filteredAnnonces.map((a) => a.toJson()).toList(),
        'pagination': {
          'current_page': page,
          'last_page': (filteredAnnonces.length / limit).ceil(),
          'per_page': limit,
          'total': filteredAnnonces.length,
        },
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAnnonceById(int id) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final annonce = MockData.annonces.firstWhere((a) => a.id == id);
      return {'success': true, 'data': annonce.toJson()};
    } catch (e) {
      return {'success': false, 'message': 'Annonce non trouvée'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateAnnonce(
    int id,
    Map<String, dynamic> annonceData,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': annonceData,
        'message': 'Annonce mise à jour avec succès',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteAnnonce(int id) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Annonce supprimée avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> searchAnnonces({
    String? query,
    String? region,
    String? commune,
    TypeLogement? typeLogement,
    double? prixMin,
    double? prixMax,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));

      List<Annonce> filteredAnnonces = List.from(MockData.annonces);

      // Appliquer les filtres
      if (query != null && query.isNotEmpty) {
        filteredAnnonces =
            filteredAnnonces
                .where(
                  (a) =>
                      a.titre.toLowerCase().contains(query.toLowerCase()) ||
                      a.description.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
      if (region != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.region == region).toList();
      }
      if (commune != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.commune == commune).toList();
      }
      if (typeLogement != null) {
        filteredAnnonces =
            filteredAnnonces
                .where((a) => a.typeLogement == typeLogement)
                .toList();
      }
      if (prixMin != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.prix >= prixMin).toList();
      }
      if (prixMax != null) {
        filteredAnnonces =
            filteredAnnonces.where((a) => a.prix <= prixMax).toList();
      }

      return {
        'success': true,
        'data': filteredAnnonces.map((a) => a.toJson()).toList(),
        'pagination': {
          'current_page': page,
          'last_page': (filteredAnnonces.length / limit).ceil(),
          'per_page': limit,
          'total': filteredAnnonces.length,
        },
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAnnoncesByProprietaire(
    int proprietaireId,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final annonces =
          MockData.annonces
              .where((a) => a.proprietaire.id == proprietaireId)
              .toList();
      return {
        'success': true,
        'data': annonces.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAnnoncesByRegion(String region) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final annonces =
          MockData.annonces.where((a) => a.region == region).toList();
      return {
        'success': true,
        'data': annonces.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAnnoncesByType(TypeLogement type) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final annonces =
          MockData.annonces.where((a) => a.typeLogement == type).toList();
      return {
        'success': true,
        'data': annonces.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> incrementViews(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Vue ajoutée'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> contactOwner(
    int annonceId,
    String message,
    String contactInfo,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Message envoyé au propriétaire'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAnnonceStatistics(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {'views': 156, 'favorites': 12, 'contacts': 8, 'shares': 5},
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getFeaturedAnnonces() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final featuredAnnonces = MockData.annonces.take(3).toList();
      return {
        'success': true,
        'data': featuredAnnonces.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getRecentAnnonces({int limit = 10}) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final recentAnnonces = MockData.annonces.take(limit).toList();
      return {
        'success': true,
        'data': recentAnnonces.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getSimilarAnnonces(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final annonce = MockData.annonces.firstWhere((a) => a.id == annonceId);
      final similarAnnonces =
          MockData.annonces
              .where(
                (a) =>
                    a.id != annonceId && a.typeLogement == annonce.typeLogement,
              )
              .take(5)
              .toList();
      return {
        'success': true,
        'data': similarAnnonces.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAnnoncesByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final annonces =
          MockData.annonces
              .where((a) => a.prix >= minPrice && a.prix <= maxPrice)
              .toList();
      return {
        'success': true,
        'data': annonces.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> validateAnnonce(
    Map<String, dynamic> annonceData,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Annonce validée'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> duplicateAnnonce(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Annonce dupliquée avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> archiveAnnonce(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Annonce archivée'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> unarchiveAnnonce(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Annonce désarchivée'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getArchivedAnnonces(int userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'data': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> uploadPhoto(
    String filePath,
    int annonceId,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {'photoUrl': 'https://example.com/photos/uploaded.jpg'},
        'message': 'Photo uploadée avec succès',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> deletePhoto(int photoId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Photo supprimée avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
