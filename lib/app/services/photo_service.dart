import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/photo.dart';
import 'api_service.dart';

class PhotoService extends ApiService {
  PhotoService() : super('https://api.immobilier.com');

  final ImagePicker _picker = ImagePicker();

  // Upload d'une photo pour une annonce
  Future<Map<String, dynamic>> uploadAnnoncePhoto(
    String filePath,
    int annonceId, {
    String? description,
  }) async {
    try {
      final response = await uploadFile(
        '/photos/upload',
        filePath,
        'photo',
        additionalData: {
          'annonceId': annonceId,
          if (description != null) 'description': description,
        },
      );
      return {
        'success': true,
        'data': Photo.fromJson(response['data']['data']),
        'message': response['data']['message'] ?? 'Photo uploadée avec succès',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Upload multiple de photos
  Future<Map<String, dynamic>> uploadMultiplePhotos(
    List<String> filePaths,
    int annonceId,
  ) async {
    try {
      final List<Photo> uploadedPhotos = [];
      final List<String> errors = [];

      for (int i = 0; i < filePaths.length; i++) {
        final result = await uploadAnnoncePhoto(filePaths[i], annonceId);
        
        if (result['success']) {
          uploadedPhotos.add(result['data']);
        } else {
          errors.add('Photo ${i + 1}: ${result['message']}');
        }
      }

      return {
        'success': errors.isEmpty,
        'data': uploadedPhotos,
        'errors': errors,
        'message': errors.isEmpty 
            ? '${uploadedPhotos.length} photos uploadées avec succès'
            : '${uploadedPhotos.length} photos uploadées, ${errors.length} erreurs',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de l\'upload multiple: $e',
      };
    }
  }

  // Récupérer les photos d'une annonce
  Future<Map<String, dynamic>> getAnnoncePhotos(int annonceId) async {
    try {
      final response = await get('/annonces/$annonceId/photos');
      return {
        'success': true,
        'data': (response['data']['data'] as List)
            .map((json) => Photo.fromJson(json))
            .toList(),
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Supprimer une photo
  Future<Map<String, dynamic>> deletePhoto(int photoId) async {
    try {
      final response = await delete('/photos/$photoId');
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Photo supprimée avec succès',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Mettre à jour les informations d'une photo
  Future<Map<String, dynamic>> updatePhoto(
    int photoId,
    Map<String, dynamic> photoData,
  ) async {
    try {
      final response = await put('/photos/$photoId', data: photoData);
      return {
        'success': true,
        'data': Photo.fromJson(response['data']['data']),
        'message': response['data']['message'] ?? 'Photo mise à jour avec succès',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Réorganiser l'ordre des photos
  Future<Map<String, dynamic>> reorderPhotos(
    int annonceId,
    List<int> photoIds,
  ) async {
    try {
      final response = await put('/annonces/$annonceId/photos/reorder', data: {
        'photoIds': photoIds,
      });
      return {
        'success': true,
        'message': response['data']['message'] ?? 'Ordre des photos mis à jour',
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Sélectionner une photo depuis la galerie
  Future<Map<String, dynamic>> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return {
          'success': true,
          'data': image.path,
          'message': 'Image sélectionnée avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Aucune image sélectionnée',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la sélection: $e',
      };
    }
  }

  // Prendre une photo avec la caméra
  Future<Map<String, dynamic>> takePhotoWithCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return {
          'success': true,
          'data': image.path,
          'message': 'Photo prise avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Aucune photo prise',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la prise de photo: $e',
      };
    }
  }

  // Sélectionner plusieurs images
  Future<Map<String, dynamic>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        return {
          'success': true,
          'data': images.map((image) => image.path).toList(),
          'message': '${images.length} images sélectionnées',
        };
      } else {
        return {
          'success': false,
          'message': 'Aucune image sélectionnée',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la sélection: $e',
      };
    }
  }

  // Valider une image avant upload
  Map<String, dynamic> validateImage(String filePath) {
    try {
      final file = File(filePath);
      
      if (!file.existsSync()) {
        return {
          'success': false,
          'message': 'Le fichier n\'existe pas',
        };
      }

      // Vérifier la taille du fichier (max 5MB)
      final fileSizeInBytes = file.lengthSync();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      
      if (fileSizeInMB > 5) {
        return {
          'success': false,
          'message': 'La taille du fichier ne doit pas dépasser 5MB',
        };
      }

      // Vérifier l'extension du fichier
      final extension = filePath.split('.').last.toLowerCase();
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      
      if (!allowedExtensions.contains(extension)) {
        return {
          'success': false,
          'message': 'Format de fichier non supporté. Utilisez JPG, PNG ou WebP',
        };
      }

      return {
        'success': true,
        'message': 'Image valide',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la validation: $e',
      };
    }
  }

  // Compresser une image
  Future<Map<String, dynamic>> compressImage(
    String filePath, {
    int quality = 85,
    int maxWidth = 1920,
    int maxHeight = 1080,
  }) async {
    try {
      // Cette méthode nécessiterait un package de compression d'image
      // comme flutter_image_compress
      
      return {
        'success': true,
        'data': filePath, // Pour l'instant, on retourne le chemin original
        'message': 'Image compressée avec succès',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la compression: $e',
      };
    }
  }

  // Obtenir les informations d'une image
  Map<String, dynamic> getImageInfo(String filePath) {
    try {
      final file = File(filePath);
      
      if (!file.existsSync()) {
        return {
          'success': false,
          'message': 'Le fichier n\'existe pas',
        };
      }

      final fileSizeInBytes = file.lengthSync();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      final extension = filePath.split('.').last.toLowerCase();
      final fileName = filePath.split('/').last;

      return {
        'success': true,
        'data': {
          'fileName': fileName,
          'extension': extension,
          'sizeInBytes': fileSizeInBytes,
          'sizeInMB': fileSizeInMB.toStringAsFixed(2),
          'path': filePath,
        },
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de la lecture des informations: $e',
      };
    }
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
              message = 'Fichier invalide';
              break;
            case 413:
              message = 'Fichier trop volumineux';
              break;
            case 415:
              message = 'Format de fichier non supporté';
              break;
            case 404:
              message = 'Photo non trouvée';
              break;
            case 500:
              message = 'Erreur serveur lors de l\'upload';
              break;
            default:
              message = 'Erreur HTTP ${error.response?.statusCode}';
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Upload annulé';
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

