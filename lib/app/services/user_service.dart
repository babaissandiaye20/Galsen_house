import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_service.dart';

class UserService extends ApiService {
  UserService() : super('https://api.immobilier.com');

  // Récupérer le profil utilisateur
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final response = await get('/users/$userId');
      return {
        'success': true,
        'data': User.fromJson(response['data']['data']),
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Mettre à jour le profil utilisateur
  Future<Map<String, dynamic>> updateUserProfile(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await put('/users/$userId', data: userData);
      return {
        'success': true,
        'data': User.fromJson(response['data']['data']),
        'message': response['data']['message'] ?? 'Profil mis à jour avec succès',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Changer le mot de passe
  Future<Map<String, dynamic>> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await put('/users/$userId/password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Mot de passe modifié avec succès',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Supprimer le compte utilisateur
  Future<Map<String, dynamic>> deleteUserAccount(int userId) async {
    try {
      final response = await delete('/users/$userId');
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Compte supprimé avec succès',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Récupérer les statistiques utilisateur (pour les propriétaires)
  Future<Map<String, dynamic>> getUserStatistics(int userId) async {
    try {
      final response = await get('/users/$userId/statistics');
      return {
        'success': true,
        'data': response['data']['data'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Récupérer l'historique des activités
  Future<Map<String, dynamic>> getUserActivity(
    int userId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await get(
        '/users/$userId/activity',
        queryParameters: {'page': page, 'limit': limit},
      );
      return {
        'success': true,
        'data': response['data']['data'],
        'pagination': response['data']['pagination'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Récupérer les favoris de l'utilisateur
  Future<Map<String, dynamic>> getUserFavorites(
    int userId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await get(
        '/users/$userId/favorites',
        queryParameters: {'page': page, 'limit': limit},
      );
      return {
        'success': true,
        'data': response['data']['data'],
        'pagination': response['data']['pagination'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Ajouter/retirer des favoris
  Future<Map<String, dynamic>> toggleFavorite(
    int userId,
    int annonceId,
  ) async {
    try {
      final response = await post('/users/$userId/favorites/toggle', data: {
        'annonceId': annonceId,
      });
      return {
        'success': true,
        'isFavorite': response['data']['isFavorite'],
        'message': response['data']['message'] ?? 
            (response['data']['isFavorite'] ? 'Ajouté aux favoris' : 'Retiré des favoris'),
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Récupérer les notifications de l'utilisateur
  Future<Map<String, dynamic>> getUserNotifications(
    int userId, {
    bool unreadOnly = false,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await get(
        '/users/$userId/notifications',
        queryParameters: {
          'unreadOnly': unreadOnly,
          'page': page,
          'limit': limit,
        },
      );
      return {
        'success': true,
        'data': response['data']['data'],
        'pagination': response['data']['pagination'],
        'unreadCount': response['data']['unreadCount'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Marquer une notification comme lue
  Future<Map<String, dynamic>> markNotificationAsRead(
    int userId,
    int notificationId,
  ) async {
    try {
      final response = await put('/users/$userId/notifications/$notificationId/read');
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Notification marquée comme lue',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Marquer toutes les notifications comme lues
  Future<Map<String, dynamic>> markAllNotificationsAsRead(int userId) async {
    try {
      final response = await put('/users/$userId/notifications/read-all');
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Toutes les notifications marquées comme lues',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Mettre à jour les préférences de notification
  Future<Map<String, dynamic>> updateNotificationPreferences(
    int userId,
    Map<String, bool> preferences,
  ) async {
    try {
      final response = await put('/users/$userId/notification-preferences', data: preferences);
      return {
        'success': true,
        'data': response['data']['data'],
        'message': response['data']['message'] ?? 'Préférences mises à jour',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Upload de photo de profil
  Future<Map<String, dynamic>> uploadProfilePhoto(
    int userId,
    String filePath,
  ) async {
    try {
      final response = await uploadFile(
        '/users/$userId/photo',
        filePath,
        'photo',
      );
      return {
        'success': true,
        'data': response['data']['data'],
        'message': response['data']['message'] ?? 'Photo de profil mise à jour',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Supprimer la photo de profil
  Future<Map<String, dynamic>> deleteProfilePhoto(int userId) async {
    try {
      final response = await delete('/users/$userId/photo');
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Photo de profil supprimée',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Récupérer les utilisateurs (pour admin)
  Future<Map<String, dynamic>> getUsers({
    String? search,
    String? role,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null) queryParams['search'] = search;
      if (role != null) queryParams['role'] = role;

      final response = await get('/users', queryParameters: queryParams);
      return {
        'success': true,
        'data': response['data']['data'],
        'pagination': response['data']['pagination'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Bloquer/débloquer un utilisateur (pour admin)
  Future<Map<String, dynamic>> toggleUserStatus(
    int userId,
    bool isBlocked,
  ) async {
    try {
      final response = await put('/users/$userId/status', data: {
        'isBlocked': isBlocked,
      });
      return {
        'success': true,
        'message': response['data']['message'] ?? 
            (isBlocked ? 'Utilisateur bloqué' : 'Utilisateur débloqué'),
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Validation des données utilisateur
  Map<String, String?> validateUserData(Map<String, dynamic> userData) {
    final errors = <String, String?>{};

    // Validation du prénom
    if (userData['prenom'] == null || userData['prenom'].toString().trim().isEmpty) {
      errors['prenom'] = 'Le prénom est obligatoire';
    } else if (userData['prenom'].toString().length < 2) {
      errors['prenom'] = 'Le prénom doit contenir au moins 2 caractères';
    }

    // Validation du nom
    if (userData['nom'] == null || userData['nom'].toString().trim().isEmpty) {
      errors['nom'] = 'Le nom est obligatoire';
    } else if (userData['nom'].toString().length < 2) {
      errors['nom'] = 'Le nom doit contenir au moins 2 caractères';
    }

    // Validation de l'email
    if (userData['email'] == null || userData['email'].toString().trim().isEmpty) {
      errors['email'] = 'L\'email est obligatoire';
    } else if (!GetUtils.isEmail(userData['email'].toString())) {
      errors['email'] = 'Format d\'email invalide';
    }

    // Validation du mot de passe (si fourni)
    if (userData['password'] != null && userData['password'].toString().length < 6) {
      errors['password'] = 'Le mot de passe doit contenir au moins 6 caractères';
    }

    return errors;
  }

  // Gestion des erreurs privée
  Map<String, dynamic> _handleError(DioException error) {
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
              message = 'Données invalides';
              break;
            case 401:
              message = 'Non autorisé';
              break;
            case 403:
              message = 'Accès interdit';
              break;
            case 404:
              message = 'Utilisateur non trouvé';
              break;
            case 409:
              message = 'Email déjà utilisé';
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

