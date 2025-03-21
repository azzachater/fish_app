import 'package:flutter/material.dart'; 
import '../../widgets/chat/recent_group_chat.dart';
import '../../widgets/chat/all_groups.dart';
import '../../constants/theme.dart';
import '../../data/group_data.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // Met à jour l'affichage des groupes quand on revient
  }

  @override
  Widget build(BuildContext context) {
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
          RecentGroups(key: widget.key),
          AllGroups(key: widget.key),
        ],
      ),
    );
  }
}
