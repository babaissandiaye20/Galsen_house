import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../services/api_service_mock.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Enregistrer le service API
    Get.lazyPut<ApiServiceMock>(() => ApiServiceMock(), fenix: true);
    
    // Enregistrer le contrôleur d'authentification
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );
  }
}

