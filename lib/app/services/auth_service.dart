import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  AuthService() : super('https://api.immobilier.com'); // Remplacez par l'URL de votre API d'authentification

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return {'success': true, 'user': User.fromJson(response['data']['user']), 'token': response['data']['token'], 'message': response['data']['message'] ?? 'Connexion réussie'};
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await post('/auth/register', data: userData);
      return {'success': true, 'user': User.fromJson(response['data']['user']), 'token': response['data']['token'], 'message': response['data']['message'] ?? 'Inscription réussie'};
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await post('/auth/refresh');
      return {'success': true, 'token': response['data']['token']};
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile(int userId, Map<String, dynamic> userData) async {
    try {
      final response = await put('/users/$userId', data: userData);
      return {'success': true, 'data': response['data']['data'], 'message': response['data']['message'] ?? 'Profil mis à jour avec succès'};
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> changePassword(int userId, String currentPassword, String newPassword) async {
    try {
      final response = await put('/users/$userId/password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      return {'success': true, 'message': response['data']['message'] ?? 'Mot de passe modifié avec succès'};
    } on DioException catch (e) {
      return handleError(e);
    }
  }
}

