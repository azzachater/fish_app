import 'package:flutter/material.dart';
import '../../constants/theme.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    required this.tabController,
    required Key key,
  }) : super(key: key);
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      height: 80,
      color:  AppTheme.primaryColor,
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 4, color: AppTheme.accentColor),
          ),
          boxShadow: [
            BoxShadow(
            color: AppTheme.accentColor.withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        unselectedLabelColor: Colors.grey[700], // Gris plus foncé
        tabs: [
          Tab(
            icon: Text(
              'Chat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            icon: Text(
              'groups',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}