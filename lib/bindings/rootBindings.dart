import 'package:fixmasters_handyman_app/controller/auth_controller.dart';
import 'package:fixmasters_handyman_app/controller/bottom_nav_controller.dart';
import 'package:fixmasters_handyman_app/controller/user_controller.dart';
import 'package:get/get.dart';

class RootBindings extends Bindings{
  @override
  void dependencies() {
    // Get.put(ServiceProvidersController());
    Get.put(BottomNavigationController());
    Get.put(AuthController());
    Get.put(UserController());
  }

}