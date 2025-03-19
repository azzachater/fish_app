import 'package:flutter/material.dart';
import '../../widgets/chat/recent_group_chat.dart';
import '../../widgets/chat/all_groups.dart';
import '../../constants/theme.dart';
import '../../data/group_data.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Vérifier si les deux listes sont vides
    if (allGroups.isEmpty && recentGroups.isEmpty) {
      return Center(
        child: Text(
          'No groups available',
          style: AppTheme.bodyText1,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          RecentGroups(key: key),
          AllGroups(key: key),
        ],
      ),
    );
  }
}