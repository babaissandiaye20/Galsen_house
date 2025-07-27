import 'package:get/get.dart';
import '../models/user.dart';
import '../models/annonce.dart';
import '../data/mocks/mock_data.dart';
import 'user_service.dart';
import 'api_service_mock.dart';

class UserServiceMock extends UserService {
  final ApiServiceMock _apiServiceMock = Get.find<ApiServiceMock>();

  UserServiceMock() : super();

  @override
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final user = MockData.users.firstWhere((user) => user.id == userId);
      return {'success': true, 'data': user};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': MockData.users.firstWhere((user) => user.id == userId).toJson(),
        'message': 'Profil mis à jour avec succès',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> uploadProfilePhoto(
    int userId,
    String filePath,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {'photoUrl': 'https://example.com/photos/profile.jpg'},
        'message': 'Photo de profil mise à jour',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getUserFavorites(
    int userId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': [],
        'pagination': {
          'current_page': page,
          'last_page': 1,
          'per_page': limit,
          'total': 0,
        },
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> addToFavorites(int userId, int annonceId) async {
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
  Future<Map<String, dynamic>> removeFromFavorites(
    int userId,
    int annonceId,
  ) async {
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
  Future<Map<String, dynamic>> getUserNotifications(
    int userId, {
    bool unreadOnly = false,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': [],
        'pagination': {
          'current_page': page,
          'last_page': 1,
          'per_page': limit,
          'total': 0,
        },
        'unreadCount': 0,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> markNotificationAsRead(
    int userId,
    int notificationId,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Notification marquée comme lue'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getUserStatistics(int userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {
          'annoncesCount': 5,
          'favoritesCount': 12,
          'viewsCount': 150,
          'contactsCount': 8,
        },
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteAccount(int userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Compte supprimé avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> updateNotificationSettings(
    int userId,
    Map<String, bool> settings,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'message': 'Paramètres de notification mis à jour',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getNotificationSettings(int userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {
          'emailNotifications': true,
          'pushNotifications': true,
          'smsNotifications': false,
          'marketingEmails': false,
        },
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> reportUser(
    int reporterId,
    int reportedUserId,
    String reason,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Utilisateur signalé avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> blockUser(int userId, int blockedUserId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Utilisateur bloqué'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> unblockUser(
    int userId,
    int blockedUserId,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Utilisateur débloqué'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getBlockedUsers(int userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'data': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> searchUsers(String query) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final users =
          MockData.users
              .where(
                (user) =>
                    user.prenom.toLowerCase().contains(query.toLowerCase()) ||
                    user.nom.toLowerCase().contains(query.toLowerCase()) ||
                    user.email.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      return {'success': true, 'data': users};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Map<String, String?> validateUserData(Map<String, dynamic> userData) {
    final errors = <String, String?>{};

    // Validation du prénom
    if (userData['prenom'] == null ||
        userData['prenom'].toString().trim().isEmpty) {
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
    if (userData['email'] == null ||
        userData['email'].toString().trim().isEmpty) {
      errors['email'] = 'L\'email est obligatoire';
    } else if (!GetUtils.isEmail(userData['email'].toString())) {
      errors['email'] = 'Format d\'email invalide';
    }

    // Validation du mot de passe (si fourni)
    if (userData['password'] != null &&
        userData['password'].toString().length < 6) {
      errors['password'] =
          'Le mot de passe doit contenir au moins 6 caractères';
    }

    return errors;
  }

  @override
  Future<Map<String, dynamic>> checkEmailAvailability(String email) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final isAvailable = !MockData.users.any((user) => user.email == email);
      return {
        'success': true,
        'available': isAvailable,
        'message': isAvailable ? 'Email disponible' : 'Email déjà utilisé',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getUsersByRole(String role) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final users =
          MockData.users
              .where((user) => user.role.name.toString() == role)
              .toList();
      return {'success': true, 'data': users};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getUsersByRegion(String region) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final users =
          MockData.users.where((user) => user.region == region).toList();
      return {'success': true, 'data': users};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
