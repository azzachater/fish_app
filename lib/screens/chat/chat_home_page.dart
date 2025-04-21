import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/theme.dart';
import 'chat_page.dart';
import 'group_page.dart';
import 'search_users_page.dart';
import 'create_search_group.dart';
import '../../widgets/chat/my_tab_bar.dart';
import '../../controllers/tab_bar_controller.dart'; // Import du contrôleur


class ChatHomePage extends StatelessWidget {
  ChatHomePage({super.key});

  final TabBarController tabBarController = Get.put(TabBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
  onPressed: () async {
    //await PusherService.to.connect(); // si nécessaire
    Get.back(); // reviens sans détruire MainScreen
  },
  icon: Icon(Icons.arrow_back, color:Colors.white),
),
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 0,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          SizedBox(height: 40),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  MyTabBar(tabController: tabBarController.tabController, key: Key('tab_bar')),
                  Expanded(
                    child: TabBarView(
                      controller: tabBarController.tabController,
                      children: [
                        ChatPage(),
                        GroupPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
      onPressed: () {
        if (tabBarController.currentTabIndex.value == 0) {
          Get.to(() => SearchUsersPage());
        } else {
          Get.to(() => CreateSearchGroup());
        }
      },
      backgroundColor: AppTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        tabBarController.currentTabIndex.value == 0
            ? Icons.message_outlined
            : Icons.add,
        color: Colors.white,
      ),
    )),
);
    
  }
}
