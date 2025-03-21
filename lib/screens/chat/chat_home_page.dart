import 'package:fish_app/screens/chat/group_page.dart';
import '../../constants/theme.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'search_users_page.dart';
import 'create_search_group.dart';
import 'package:logger/logger.dart';
import '../social_network/social_home_page.dart';
import '../../widgets/chat/my_tab_bar.dart'; // Assurez-vous d'importer votre widget MyTabBar

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<ChatHomePage> with TickerProviderStateMixin {
  late TabController tabController;
  int currentTabIndex = 0;
  final logger = Logger();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
      logger.d('Current tab index: $currentTabIndex');
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(onTabChange);
  }

  @override
  void dispose() {
    tabController.removeListener(onTabChange);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SocialHomePage()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        //centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          SizedBox(height: 40), // Espace avant le TabBar
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
                  MyTabBar(tabController: tabController, key: Key('tab_bar')), // Utilisation de MyTabBar
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentTabIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchUsersPage()),
            );
          } else if (currentTabIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateSearchGroup()),
            );
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          currentTabIndex == 0 ? Icons.message_outlined : Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
