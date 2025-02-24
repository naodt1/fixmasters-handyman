import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixmasters_handyman_app/bindings/rootBindings.dart';
import 'package:fixmasters_handyman_app/controller/auth_controller.dart';
import 'package:fixmasters_handyman_app/controller/user_controller.dart';
import 'package:fixmasters_handyman_app/view/screens/auth_screen/loginPage.dart';
import 'package:fixmasters_handyman_app/view/screens/auth_screen/signupPage.dart';
import 'package:fixmasters_handyman_app/view/screens/booking_screen/bookingPage.dart';
import 'package:fixmasters_handyman_app/view/screens/chat_screen/chatPage.dart';
import 'package:fixmasters_handyman_app/view/screens/home_screen/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/bottom_nav_controller.dart';
import 'controller/chatController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Ensure AuthController is initialized
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(ChatController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color(0xff424242).withOpacity(0.002),
        statusBarIconBrightness:  Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(
              name: '/', page: () => HomePage(), transition: Transition.fade),
          GetPage(
              name: '/booking',
              page: () => BookingPage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/chatpage',
              page: () => ChatPage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/login',
              page: () => LoginPage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/signup',
              page: () => SignupPage(),
              transition: Transition.fadeIn),
          // GetPage(name: '/profile', page: () => ProfilePage(), transition: Transition.rightToLeftWithFade),
        ],
        initialBinding: RootBindings(),
        title: 'FixMasters',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange, brightness: Brightness.light),
          useMaterial3: false,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange, brightness: Brightness.dark),
          useMaterial3: false,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        home: GetX<BottomNavigationController>(builder: (controller) {
          return controller.currentPage;
        }),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
