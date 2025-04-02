import 'package:fish_app/screens/journal/diary_screen.dart';
import 'package:fish_app/screens/marketplace/market_place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/widgets/custom_nav_bar.dart';
import 'screens/social_network/social_home_page.dart';
import 'screens/social_network/profile_page.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;

  List<Widget> get pages => [
    SocialHomePage(),
    Marketplace(),
    JournalScreen(),
    ProfilePage(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

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
