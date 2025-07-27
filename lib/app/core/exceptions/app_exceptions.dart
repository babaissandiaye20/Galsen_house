// Exception de base pour l'application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

// Exception réseau
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

// Exception d'authentification
class AuthException extends AppException {
  const AuthException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

// Exception de validation
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(
    String message, {
    String? code,
    this.fieldErrors,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

// Exception serveur
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
    String message, {
    String? code,
    this.statusCode,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

// Exception de données non trouvées
class NotFoundException extends AppException {
  const NotFoundException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

// Exception de permissions
class PermissionException extends AppException {
  const PermissionException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

// Exception de fichier
class FileException extends AppException {
  const FileException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

// Exception de cache
class CacheException extends AppException {
  const CacheException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

// Gestionnaire d'exceptions global
class ExceptionHandler {
  static String getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    } else if (error is FormatException) {
      return 'Format de données invalide';
    } else if (error is TypeError) {
      return 'Erreur de type de données';
    } else {
      return 'Une erreur inattendue s\'est produite';
    }
  }

  static AppException handleDioError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return const NetworkException('Pas de connexion internet');
    } else if (error.toString().contains('TimeoutException')) {
      return const NetworkException('Délai de connexion dépassé');
    } else if (error.response?.statusCode == 401) {
      return const AuthException('Session expirée, veuillez vous reconnecter');
    } else if (error.response?.statusCode == 403) {
      return const PermissionException('Accès non autorisé');
    } else if (error.response?.statusCode == 404) {
      return const NotFoundException('Ressource non trouvée');
    } else if (error.response?.statusCode == 422) {
      return ValidationException(
        'Données invalides',
        fieldErrors: _parseValidationErrors(error.response?.data),
      );
    } else if (error.response?.statusCode != null && error.response!.statusCode! >= 500) {
      return ServerException(
        'Erreur serveur, veuillez réessayer plus tard',
        statusCode: error.response!.statusCode,
      );
    } else {
      return NetworkException(
        error.response?.data?['message'] ?? 'Erreur de connexion',
        originalError: error,
      );
    }
  }

  static Map<String, List<String>>? _parseValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null) {
        return errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.cast<String>());
          } else if (value is String) {
            return MapEntry(key, [value]);
          } else {
            return MapEntry(key, [value.toString()]);
          }
        });
      }
    }
    return null;
  }

  static void logError(dynamic error, {StackTrace? stackTrace}) {
    // En développement, afficher l'erreur dans la console
    print('ERROR: $error');
    if (stackTrace != null) {
      print('STACK TRACE: $stackTrace');
    }
    
    // En production, envoyer à un service de logging comme Crashlytics
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}

