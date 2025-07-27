import 'package:get/get.dart';
import '../services/api_service_mock.dart';
import '../services/auth_service_mock.dart';
import '../services/user_service_mock.dart';
import '../services/annonce_service_mock.dart';
import '../services/photo_service_mock.dart';
import '../services/utils_service_mock.dart';
import 'navigation_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services de base
    Get.lazyPut<ApiServiceMock>(() => ApiServiceMock(), fenix: true);
    Get.lazyPut<NavigationService>(() => NavigationService(), fenix: true);
    
    // Services métier mock
    Get.lazyPut<AuthServiceMock>(() => AuthServiceMock(), fenix: true);
    Get.lazyPut<UserServiceMock>(() => UserServiceMock(), fenix: true);
    Get.lazyPut<AnnonceServiceMock>(() => AnnonceServiceMock(), fenix: true);
    Get.lazyPut<PhotoServiceMock>(() => PhotoServiceMock(), fenix: true);
    Get.lazyPut<UtilsServiceMock>(() => UtilsServiceMock(), fenix: true);
  }
}

