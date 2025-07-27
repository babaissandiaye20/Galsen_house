import 'package:get/get.dart';
import '../models/annonce.dart';
import '../data/mocks/mock_data.dart';
import 'utils_service.dart';
import 'api_service_mock.dart';

class UtilsServiceMock extends UtilsService {
  final ApiServiceMock _apiServiceMock = Get.find<ApiServiceMock>();

  UtilsServiceMock() : super();

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
  Future<Map<String, dynamic>> getSearchSuggestions(String query) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': [
          'Villa Dakar',
          'Appartement Plateau',
          'Studio Mermoz',
          'Maison Thiès',
        ],
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> saveSearchHistory(String query) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Historique sauvegardé'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getSearchHistory() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': ['Villa Dakar', 'Appartement Plateau', 'Studio Mermoz'],
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> clearSearchHistory() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Historique effacé'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> addToFavorites(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'isFavorite': true,
        'message': 'Ajouté aux favoris',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> removeFromFavorites(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'isFavorite': false,
        'message': 'Retiré des favoris',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getFavorites() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': MockData.annonces.take(3).map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> checkFavoriteStatus(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'isFavorite': false};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> reportAnnonce({
    required int annonceId,
    required String raison,
    required String description,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Annonce signalée avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> reportUser({
    required int reportedUserId,
    required String reason,
    String? description,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Utilisateur signalé avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getRegions() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'data': MockData.regions};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getCommunes(String region) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final communes = MockData.communesParRegion[region] ?? [];
      return {'success': true, 'data': communes};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> contactOwner({
    required int annonceId,
    required String message,
    required String contactInfo,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Message envoyé au propriétaire'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> shareAnnonce({
    required int annonceId,
    required String platform,
    String? message,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'message': 'Annonce partagée avec succès',
        'shareUrl': 'https://example.com/share/$annonceId',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAppSettings() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {
          'notifications': true,
          'darkMode': false,
          'language': 'fr',
          'currency': 'XOF',
        },
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> updateAppSettings(
    Map<String, dynamic> settings,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Paramètres mis à jour'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> sendFeedback({
    required String type,
    required String message,
    String? email,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Feedback envoyé avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getAppVersion() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {'version': '1.0.0', 'buildNumber': '1', 'platform': 'android'},
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> checkForUpdates() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {
          'hasUpdate': false,
          'latestVersion': '1.0.0',
          'updateUrl': null,
          'forceUpdate': false,
        },
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
