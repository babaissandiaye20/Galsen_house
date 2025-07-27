import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../services/api_service_mock.dart';
import '../../../services/annonce_service_mock.dart';
import '../../../services/utils_service_mock.dart';
import '../../chat/controllers/chat_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Enregistrer les services s'ils ne sont pas déjà enregistrés
    if (!Get.isRegistered<ApiServiceMock>()) {
      Get.lazyPut<ApiServiceMock>(() => ApiServiceMock(), fenix: true);
    }

    if (!Get.isRegistered<AnnonceServiceMock>()) {
      Get.lazyPut<AnnonceServiceMock>(() => AnnonceServiceMock(), fenix: true);
    }

    if (!Get.isRegistered<UtilsServiceMock>()) {
      Get.lazyPut<UtilsServiceMock>(() => UtilsServiceMock(), fenix: true);
    }

    // Enregistrer le contrôleur de la page d'accueil
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    // Enregistrer le contrôleur du chat
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
  }
}
