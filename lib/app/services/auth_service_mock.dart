import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../data/mocks/mock_data.dart';
import 'auth_service.dart';
import 'api_service_mock.dart';

class AuthServiceMock extends AuthService {
  final ApiServiceMock _apiServiceMock = Get.find<ApiServiceMock>();

  AuthServiceMock() : super(); // Appelle le constructeur de la classe parente

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Simulation de délai réseau

      // Chercher l'utilisateur dans les données mock
      final user = MockData.users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Email ou mot de passe incorrect'),
      );

      // Générer un token mock
      final token =
          'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

      await _saveAuthData(user, token);
      return {
        'success': true,
        'message': 'Connexion réussie',
        'user': user,
        'token': token,
      };
    } catch (e) {
      return {'success': false, 'message': 'Email ou mot de passe incorrect'};
    }
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiServiceMock.register(userData);
      if (response['success']) {
        final registeredUser = User.fromJson(response['user']);
        final token = response['token'];
        await _saveAuthData(registeredUser, token);
        return {
          'success': true,
          'message': 'Inscription réussie',
          'user': registeredUser,
        };
      } else {
        return {'success': false, 'message': response['message']};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<void> logout() async {
    await _clearAuthData();
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      // Simulation d'un refresh token
      await Future.delayed(Duration(milliseconds: 500));
      final newToken =
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
      await _saveToken(newToken);
      return {'success': true, 'message': 'Token rafraîchi', 'token': newToken};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      // Simulation du changement de mot de passe
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Mot de passe modifié avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      // Simulation de l'envoi d'email de récupération
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Email de récupération envoyé'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      // Simulation de la réinitialisation du mot de passe
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'message': 'Mot de passe réinitialisé avec succès',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> _saveAuthData(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    await prefs.setString('token', token);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('user');
    if (userJsonString != null) {
      try {
        final userMap = jsonDecode(userJsonString) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        print('Erreur lors de la désérialisation de l\'utilisateur: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
