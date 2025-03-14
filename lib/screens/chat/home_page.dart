import 'package:fish_app/screens/chat/group_page.dart';

import '../../constants/theme.dart';
import 'package:flutter/material.dart';
import '../../widgets/chat/chat_widgets.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController tabController;
  int currentTabIndex = 0;

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
      print(currentTabIndex);
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
      
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),color: Colors.white,
        ),
        title: Text(
          'Chattie',
          style: AppTheme.chatTitle.copyWith(
    color: Colors.white, // Changer la couleur en blanc
  ),
        
        ),
        centerTitle: true, 
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),color: Colors.white,
            onPressed: () {},
          )
        ],
        elevation: 0,
      ),
      backgroundColor:  AppTheme.primaryColor,
      body: Column(
        children: [
        MyTabBar(key: UniqueKey(), tabController: tabController), // Pass the key parameter
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: TabBarView(
                controller: tabController,
                children: [
                  ChatPage(),
                  GroupPage(),
                  
                ],
              ),
            ),
          )
        ],
     ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          currentTabIndex == 0
              ? Icons.message_outlined
              : currentTabIndex == 1
                  ? Icons.add
                  : Icons.call,
          color: Colors.white,
        ),
      ),
    );
  }
}