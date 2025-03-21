import 'package:flutter/material.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../constants/theme.dart';
import 'group_details_page.dart';
import '../../data/user_data.dart';
import '../../data/group_data.dart';
import 'dart:io';
import 'group_chat_page.dart';

class CreateSearchGroup extends StatefulWidget {
  const CreateSearchGroup({super.key});

  @override
  CreateSearchGroupState createState() => CreateSearchGroupState();
}

class CreateSearchGroupState extends State<CreateSearchGroup> {
  List<Group> filteredGroups = List.from(allGroups);
  List<User> selectedUsers = [currentUser]; // currentUser est sélectionné par défaut
  List<User> filteredUsers = List.from(users);
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //selectedUsers.add(); // currentUser est sélectionné par défaut
  }

  void filterUsers(String query) {
    final List<User> results = users.where((user) {
      final String userName = user.name.toLowerCase();
      return userName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsers = results;
    });
  }

  void _navigateToGroupDetails() async {
     if (!selectedUsers.contains(currentUser)) {
    selectedUsers.add(currentUser);
  }
    final newGroup = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailsPage(selectedUsers: selectedUsers),
      ),
    );

    if (newGroup != null) {
      setState(() {
        allGroups.add(newGroup);
        filteredGroups = List.from(allGroups); // Met à jour la liste affichée
        selectedUsers.clear(); // Désélectionne les utilisateurs
        selectedUsers.add(currentUser); // Réajoute currentUser par défaut
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
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: filterUsers,
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Group', style: AppTheme.heading2),
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
                            isSelected ? selectedUsers.remove(user) : selectedUsers.add(user);
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
                                child: Icon(Icons.check_circle, color: Colors.green),
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
                    onPressed: _navigateToGroupDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text('All Groups', style: AppTheme.heading2),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredGroups.length,
              itemBuilder: (context, index) {
                final group = filteredGroups[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: group.avatar.startsWith('/')
                        ? FileImage(File(group.avatar)) as ImageProvider
                        : AssetImage(group.avatar),
                  ),
                  title: Text(group.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
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