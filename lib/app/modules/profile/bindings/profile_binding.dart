import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../services/api_service_mock.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Enregistrer le service API s'il n'est pas déjà enregistré
    if (!Get.isRegistered<ApiServiceMock>()) {
      Get.lazyPut<ApiServiceMock>(() => ApiServiceMock(), fenix: true);
    }
    
    // Enregistrer le contrôleur de profil
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
  }
}

