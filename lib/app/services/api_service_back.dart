import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/annonce.dart';

class ApiServiceBack extends GetxService {
  late Dio _dio;
  final String baseUrl = 'https://api.immobilier.com'; // URL de votre API backend
  
  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Intercepteur pour les logs
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));

    // Intercepteur pour l'authentification
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Ajouter le token d'authentification si disponible
        final token = Get.find<AuthController>().token.value;
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Gérer les erreurs d'authentification
        if (error.response?.statusCode == 401) {
          Get.find<AuthController>().logout();
        }
        handler.next(error);
      },
    ));
  }

  // Authentification
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      return {
        'success': true,
        'user': response.data['user'],
        'token': response.data['token'],
        'message': response.data['message'] ?? 'Connexion réussie'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/auth/register', data: userData);

      return {
        'success': true,
        'user': response.data['user'],
        'token': response.data['token'],
        'message': response.data['message'] ?? 'Inscription réussie'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await _dio.post('/auth/refresh');

      return {
        'success': true,
        'token': response.data['token'],
      };
    } on DioException catch (e) {
      return _handleError(e);
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
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (region != null) queryParams['region'] = region;
      if (commune != null) queryParams['commune'] = commune;
      if (typeLogement != null) queryParams['typeLogement'] = typeLogement.toString().split('.').last;
      if (prixMin != null) queryParams['prixMin'] = prixMin;
      if (prixMax != null) queryParams['prixMax'] = prixMax;

      final response = await _dio.get('/annonces', queryParameters: queryParams);

      return {
        'success': true,
        'data': response.data['data'],
        'pagination': response.data['pagination'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAnnonceById(int id) async {
    try {
      final response = await _dio.get('/annonces/$id');

      return {
        'success': true,
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createAnnonce(Map<String, dynamic> annonceData) async {
    try {
      final response = await _dio.post('/annonces', data: annonceData);

      return {
        'success': true,
        'data': response.data['data'],
        'message': response.data['message'] ?? 'Annonce créée avec succès'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateAnnonce(int id, Map<String, dynamic> annonceData) async {
    try {
      final response = await _dio.put('/annonces/$id', data: annonceData);

      return {
        'success': true,
        'data': response.data['data'],
        'message': response.data['message'] ?? 'Annonce mise à jour avec succès'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteAnnonce(int id) async {
    try {
      final response = await _dio.delete('/annonces/$id');

      return {
        'success': true,
        'message': response.data['message'] ?? 'Annonce supprimée avec succès'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAnnoncesByProprietaire(int proprietaireId) async {
    try {
      final response = await _dio.get('/annonces/proprietaire/$proprietaireId');

      return {
        'success': true,
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Upload de photos
  Future<Map<String, dynamic>> uploadPhoto(String filePath, int annonceId) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
        'annonceId': annonceId,
      });

      final response = await _dio.post('/photos/upload', data: formData);

      return {
        'success': true,
        'data': response.data['data'],
        'message': response.data['message'] ?? 'Photo uploadée avec succès'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deletePhoto(int photoId) async {
    try {
      final response = await _dio.delete('/photos/$photoId');

      return {
        'success': true,
        'message': response.data['message'] ?? 'Photo supprimée avec succès'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Gestion du profil utilisateur
  Future<Map<String, dynamic>> updateProfile(int userId, Map<String, dynamic> userData) async {
    try {
      final response = await _dio.put('/users/$userId', data: userData);

      return {
        'success': true,
        'data': response.data['data'],
        'message': response.data['message'] ?? 'Profil mis à jour avec succès'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> changePassword(int userId, String currentPassword, String newPassword) async {
    try {
      final response = await _dio.put('/users/$userId/password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      return {
        'success': true,
        'message': response.data['message'] ?? 'Mot de passe modifié avec succès'
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Statistiques
  Future<Map<String, dynamic>> getStatistiques(int proprietaireId) async {
    try {
      final response = await _dio.get('/statistiques/proprietaire/$proprietaireId');

      return {
        'success': true,
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Utilitaires
  Future<Map<String, dynamic>> getRegions() async {
    try {
      final response = await _dio.get('/utils/regions');

      return {
        'success': true,
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getCommunesByRegion(String region) async {
    try {
      final response = await _dio.get('/utils/communes/$region');

      return {
        'success': true,
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Gestion des erreurs
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

// Import nécessaire pour AuthController (sera créé dans la phase suivante)
class AuthController extends GetxController {
  final token = ''.obs;
  
  void logout() {
    token.value = '';
    // Logique de déconnexion
  }
}

