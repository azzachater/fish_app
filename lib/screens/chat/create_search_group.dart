import 'package:flutter/material.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../constants/theme.dart';
import 'group_details_page.dart'; // Import GroupDetailsPage
import 'group_chat_page.dart';
import '../../data/user_data.dart';
import '../../data/group_data.dart';

class CreateSearchGroup extends StatefulWidget {
  const CreateSearchGroup({super.key});

  @override
  CreateSearchGroupState createState() => CreateSearchGroupState();
}

class CreateSearchGroupState extends State<CreateSearchGroup> {
  List<Group> filteredGroups = allGroups; // Initialize with all groups
  List<User> selectedUsers = [];
  List<User> filteredUsers = users; // Initialize with all users
  TextEditingController searchController = TextEditingController();

  void filterGroups(String query) {
    final List<Group> results = allGroups.where((group) {
      final String groupName = group.name.toLowerCase();
      final String searchQuery = query.toLowerCase();
      return groupName.contains(searchQuery);
    }).toList();

    setState(() {
      filteredGroups = results;
    });
  }

  void filterUsers(String query) {
    final List<User> results = users.where((user) {
      final String userName = user.name.toLowerCase();
      final String searchQuery = query.toLowerCase();
      return userName.contains(searchQuery);
    }).toList();

    setState(() {
      filteredUsers = results;
    });
  }

  // Fonction pour naviguer vers la page de détails du groupe
  void _navigateToGroupDetails() async {
    final newGroup = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailsPage(selectedUsers: selectedUsers),
      ),
    );

    if (newGroup != null) {
      setState(() {
        // Ajouter le groupe créé à la liste des groupes filtrés
        filteredGroups.add(newGroup);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)), // 0.7 * 255 = 179
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            filterUsers(value);
          },
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Partie 1: Créer un groupe
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Group',
                  style: AppTheme.heading2,
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final isSelected = selectedUsers.contains(user);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedUsers.remove(user);
                            } else {
                              selectedUsers.add(user);
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(user.avatar),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToGroupDetails,  // Appeler la fonction pour naviguer vers la page de détails du groupe
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          // Partie 2: Tous les groupes
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
              'All Groups',
              style: AppTheme.heading2,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredGroups.length,
              itemBuilder: (context, index) {
                final group = filteredGroups[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(group.avatar),
                  ),
                  title: Text(
                    group.name,
                    style: AppTheme.heading2.copyWith(fontSize: 16),
                  ),
                  subtitle: Text('${group.members.length} members'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatPage(group: group),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
