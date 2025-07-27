import 'package:get/get.dart';
import '../controllers/annonce_controller.dart';
import '../../../services/api_service_mock.dart';

class AnnonceBinding extends Bindings {
  @override
  void dependencies() {
    // Enregistrer le service API s'il n'est pas déjà enregistré
    if (!Get.isRegistered<ApiServiceMock>()) {
      Get.lazyPut<ApiServiceMock>(() => ApiServiceMock(), fenix: true);
    }
    
    // Enregistrer le contrôleur des annonces
    Get.lazyPut<AnnonceController>(
      () => AnnonceController(),
      fenix: true,
    );
  }
}

