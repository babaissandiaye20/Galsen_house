import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'api_service.dart';

class UtilsService extends ApiService {
  UtilsService() : super('https://api.immobilier.com');

  // Récupérer toutes les régions
  Future<Map<String, dynamic>> getRegions() async {
    try {
      final response = await get('/utils/regions');
      return {
        'success': true,
        'data': response['data']['data'],
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Récupérer les communes d'une région
  Future<Map<String, dynamic>> getCommunesByRegion(String region) async {
    try {
      final response = await get('/utils/communes/$region');
      return {
        'success': true,
        'data': response['data']['data'],
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Récupérer les statistiques générales
  Future<Map<String, dynamic>> getStatistiques(int proprietaireId) async {
    try {
      final response = await get('/statistiques/proprietaire/$proprietaireId');
      return {
        'success': true,
        'data': response['data']['data'],
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Envoyer un message de contact
  Future<Map<String, dynamic>> sendContactMessage({
    required String nom,
    required String email,
    required String message,
    required String sujet,
  }) async {
    try {
      final response = await post('/contact', data: {
        'nom': nom,
        'email': email,
        'message': message,
        'sujet': sujet,
      });
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Message envoyé avec succès',
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Signaler une annonce
  Future<Map<String, dynamic>> reportAnnonce({
    required int annonceId,
    required String raison,
    required String description,
  }) async {
    try {
      final response = await post('/annonces/$annonceId/report', data: {
        'raison': raison,
        'description': description,
      });
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Signalement envoyé avec succès',
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Recherche avancée
  Future<Map<String, dynamic>> searchAnnonces({
    required String query,
    String? region,
    String? commune,
    double? prixMin,
    double? prixMax,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'page': page,
        'limit': limit,
      };

      if (region != null) queryParams['region'] = region;
      if (commune != null) queryParams['commune'] = commune;
      if (prixMin != null) queryParams['prixMin'] = prixMin;
      if (prixMax != null) queryParams['prixMax'] = prixMax;

      final response = await get('/search', queryParameters: queryParams);
      return {
        'success': true,
        'data': response['data']['data'],
        'pagination': response['data']['pagination'],
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Gérer les favoris
  Future<Map<String, dynamic>> addToFavorites(int annonceId) async {
    try {
      final response = await post('/favorites', data: {'annonceId': annonceId});
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Ajouté aux favoris',
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> removeFromFavorites(int annonceId) async {
    try {
      final response = await delete('/favorites/$annonceId');
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Retiré des favoris',
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> getFavorites() async {
    try {
      final response = await get('/favorites');
      return {
        'success': true,
        'data': response['data']['data'],
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Notifications
  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await get('/notifications');
      return {
        'success': true,
        'data': response['data']['data'],
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> markNotificationAsRead(int notificationId) async {
    try {
      final response = await put('/notifications/$notificationId/read');
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Notification marquée comme lue',
      };
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Validation des données
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^(\+221|00221)?[0-9]{9}$').hasMatch(phone);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Formatage des données
  String formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]} ',
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} semaines';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Gestion des erreurs avec méthode publique
  Map<String, dynamic> handleError(DioException error) {
    String message = 'Une erreur est survenue';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Délai de connexion dépassé';
        break;
      case DioExceptionType.badResponse:
        if (error.response?.data != null && error.response?.data['message'] != null) {
          message = error.response!.data['message'];
        } else {
          switch (error.response?.statusCode) {
            case 400:
              message = 'Requête invalide';
              break;
            case 401:
              message = 'Non autorisé';
              break;
            case 403:
              message = 'Accès interdit';
              break;
            case 404:
              message = 'Ressource non trouvée';
              break;
            case 500:
              message = 'Erreur serveur';
              break;
            default:
              message = 'Erreur HTTP ${error.response?.statusCode}';
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Requête annulée';
        break;
      case DioExceptionType.unknown:
        message = 'Erreur de connexion';
        break;
      default:
        message = 'Erreur inconnue';
    }

    return {
      'success': false,
      'message': message,
      'statusCode': error.response?.statusCode,
    };
  }
}

