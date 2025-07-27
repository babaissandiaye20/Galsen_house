import 'package:get/get.dart';
import '../models/annonce.dart';
import 'api_service.dart';

class AnnonceService extends ApiService {
  AnnonceService() : super('https://api.immobilier.com');

  // Récupérer toutes les annonces avec filtres
  Future<Map<String, dynamic>> getAnnonces({
    String? region,
    String? commune,
    TypeLogement? typeLogement,
    double? prixMin,
    double? prixMax,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};

    if (region != null) queryParams['region'] = region;
    if (commune != null) queryParams['commune'] = commune;
    if (typeLogement != null)
      queryParams['typeLogement'] = typeLogement.toString().split('.').last;
    if (prixMin != null) queryParams['prixMin'] = prixMin;
    if (prixMax != null) queryParams['prixMax'] = prixMax;

    final result = await get('/annonces', queryParameters: queryParams);

    if (result['success']) {
      return {
        'success': true,
        'data': result['data']['data'],
        'pagination': result['data']['pagination'],
      };
    }

    return result;
  }

  // Récupérer une annonce par ID
  Future<Map<String, dynamic>> getAnnonceById(int id) async {
    return await get('/annonces/$id');
  }

  // Créer une nouvelle annonce
  Future<Map<String, dynamic>> createAnnonce(
    Map<String, dynamic> annonceData,
  ) async {
    final result = await post('/annonces', data: annonceData);

    if (result['success']) {
      return {
        'success': true,
        'data': result['data']['data'],
        'message': result['data']['message'] ?? 'Annonce créée avec succès',
      };
    }

    return result;
  }

  // Mettre à jour une annonce
  Future<Map<String, dynamic>> updateAnnonce(
    int id,
    Map<String, dynamic> annonceData,
  ) async {
    final result = await put('/annonces/$id', data: annonceData);

    if (result['success']) {
      return {
        'success': true,
        'data': result['data']['data'],
        'message':
            result['data']['message'] ?? 'Annonce mise à jour avec succès',
      };
    }

    return result;
  }

  // Supprimer une annonce
  Future<Map<String, dynamic>> deleteAnnonce(int id) async {
    final result = await delete('/annonces/$id');

    if (result['success']) {
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Annonce supprimée avec succès',
      };
    }

    return result;
  }

  // Récupérer les annonces d'un propriétaire
  Future<Map<String, dynamic>> getAnnoncesByProprietaire(
    int proprietaireId,
  ) async {
    return await get('/annonces/proprietaire/$proprietaireId');
  }

  // Upload de photos pour une annonce
  Future<Map<String, dynamic>> uploadPhoto(
    String filePath,
    int annonceId,
  ) async {
    return await uploadFile(
      '/photos/upload',
      filePath,
      'photo',
      additionalData: {'annonceId': annonceId},
    );
  }

  // Supprimer une photo
  Future<Map<String, dynamic>> deletePhoto(int photoId) async {
    final result = await delete('/photos/$photoId');

    if (result['success']) {
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Photo supprimée avec succès',
      };
    }

    return result;
  }
}
