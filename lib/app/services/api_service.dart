import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

abstract class ApiService extends GetxService {
  late dio.Dio _dio;
  final String baseUrl;

  ApiService(this.baseUrl);

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur pour les logs
    _dio.interceptors.add(
      dio.LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ),
    );

    // Intercepteur pour l'authentification
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ajouter le token d'authentification si disponible
          try {
            final authController = Get.find<AuthController>();
            final token = authController.token.value;
            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            // AuthController pas encore initialisé
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Gérer les erreurs d'authentification
          if (error.response?.statusCode == 401) {
            try {
              Get.find<AuthController>().logout();
            } catch (e) {
              // AuthController pas encore initialisé
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  // Méthodes génériques
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return {'success': true, 'data': response.data};
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return {'success': true, 'data': response.data};
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return {'success': true, 'data': response.data};
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return {'success': true, 'data': response.data};
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    String filePath,
    String fieldName, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        fieldName: await dio.MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(endpoint, data: formData);
      return {'success': true, 'data': response.data};
    } on dio.DioException catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _handleError(dio.DioException error) {
    String message = 'Une erreur est survenue';
    int statusCode = 500;

    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        message = 'Erreur de connexion. Vérifiez votre connexion internet.';
        break;
      case dio.DioExceptionType.badResponse:
        if (error.response?.data != null &&
            error.response?.data['message'] != null) {
          message = error.response!.data['message'];
        } else {
          message = 'Erreur serveur (${error.response?.statusCode})';
        }
        statusCode = error.response?.statusCode ?? 500;
        break;
      case dio.DioExceptionType.cancel:
        message = 'Requête annulée';
        break;
      case dio.DioExceptionType.unknown:
      default:
        message = 'Erreur inconnue';
        break;
    }

    return {'success': false, 'message': message, 'statusCode': statusCode};
  }

  // Gestion des erreurs publique pour les services enfants
  Map<String, dynamic> handleError(dio.DioException error) {
    return _handleError(error);
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
