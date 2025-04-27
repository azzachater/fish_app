import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    required this.tabController,
    required Key key,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, 
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25.0), 
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab, 
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: const Color.fromARGB(255, 170, 196, 247),
        ),
        labelColor: const Color.fromARGB(255, 61, 100, 215),
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w500, 
        ),
        tabs: const [
          Tab(text: 'Chats'),
          Tab(text: 'Groups'),
        ],
      ),
    );
  }
}
