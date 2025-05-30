import 'package:fish_app/controller/data_selector_controller.dart';
import 'package:fish_app/controller/order_controller.dart';
import 'package:fish_app/controller/product_card_controller.dart';
import 'package:fish_app/controllers/notification_controller.dart';
import 'package:fish_app/controllers/profile_controller.dart';
import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/controller/add_journal_controller.dart';
import 'package:fish_app/controllers/auth_controller.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/screens/Authentification/signup_page.dart';
import 'package:fish_app/screens/Authentification/verify_code_page.dart';
import 'package:fish_app/screens/marketplace/product_detail_page.dart';
import 'package:fish_app/screens/prediction_ia/weather_predict_form.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/Authentification/home_page.dart';
import 'screens/Authentification/login_page.dart';
import 'package:fish_app/main_screen.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:fish_app/controller/favorite_controller.dart';
import 'package:fish_app/services/api_push_notif_service.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(FavoriteController());
  Get.put(EventController());
  Get.put(JournalController());
  Get.put(DateSelectorController());
  Get.put(AddJournalController());
  Get.put(OrderController());
  await Get.putAsync(() => PusherService().init());

  Get.put(UserController());
  Get.put(NotificationController());

  Get.put(ProfileController());
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fish Net',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
        GetPage(
          name: '/product',
          page: () => ProductDetailPage(product: Get.arguments),
        ),
        GetPage(
          name: '/fishing-prediction',
          page: () => WeatherPredictForm(),
        ),
        GetPage(
          name: '/verify-code',
          page:
              () => VerifyCodePage(
                email: Get.arguments['email'],
                userId: Get.arguments['userId'],
              ),
        ),
      ],
    );
  }
}