import 'package:fish_app/screens/journal/diary_screen.dart';
import 'package:fish_app/screens/marketplace/market_place.dart';
import 'package:fish_app/screens/prediction_ia/weather_predict_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/widgets/custom_nav_bar.dart';

import 'screens/social_network/social_home_page.dart';
import 'screens/social_network/profile_page.dart';
import 'services/api_push_notif_service.dart'; // Ajoute ce import

class MainController extends GetxController {
  var selectedIndex = 0.obs;

  List<Widget> get pages => [
    SocialHomePage(),
    Marketplace(),
    JournalScreen(),
    WeatherPredictForm(),
    ProfilePage(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainController controller = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPusher();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => CustomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTabChange: controller.changeTab,
        ),
      ),
    );
  }
}

void _initPusher() async {
  try {
    print('Initializing Pusher service...');
    await PusherService.to.init();

    // Attendre un court instant avant de se connecter
    await Future.delayed(Duration(milliseconds: 500));

    await PusherService.to.connect();
    print('Pusher initialization completed');
  } catch (e) {
    print('Error initializing Pusher: $e');
    // Réessayer après un délai
    Future.delayed(Duration(seconds: 3), () => _initPusher());
  }
}
