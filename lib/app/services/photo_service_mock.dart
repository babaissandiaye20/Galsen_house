import 'package:get/get.dart';
import '../models/photo.dart';
import '../data/mocks/mock_data.dart';
import 'photo_service.dart';
import 'api_service_mock.dart';

class PhotoServiceMock extends PhotoService {
  final ApiServiceMock _apiServiceMock = Get.find<ApiServiceMock>();

  PhotoServiceMock() : super();

  @override
  Future<Map<String, dynamic>> uploadPhoto(
    String filePath,
    int annonceId,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': {
          'photoUrl': 'https://example.com/photos/uploaded.jpg',
          'photoId': DateTime.now().millisecondsSinceEpoch,
        },
        'message': 'Photo uploadée avec succès',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> getPhotosByAnnonce(int annonceId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final photos =
          MockData.photos.where((p) => p.annonceId == annonceId).toList();
      return {'success': true, 'data': photos.map((p) => p.toJson()).toList()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> deletePhoto(int photoId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Photo supprimée avec succès'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> updatePhoto(
    int photoId,
    Map<String, dynamic> photoData,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {
        'success': true,
        'data': photoData,
        'message': 'Photo mise à jour avec succès',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> reorderPhotos(
    int annonceId,
    List<int> photoIds,
  ) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return {'success': true, 'message': 'Ordre des photos mis à jour'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
