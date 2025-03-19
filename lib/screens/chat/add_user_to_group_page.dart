import 'package:flutter/material.dart';
//import '../../data/group_data.dart';
import '../../data/user_data.dart';
import '../../models/user_model.dart';
import '../../models/group_model.dart';
import '../../constants/theme.dart';

class AddUserToGroupPage extends StatefulWidget {
  final Group group;

  const AddUserToGroupPage({super.key, required this.group});

  @override
  AddUserToGroupPageState createState() => AddUserToGroupPageState();
}

class AddUserToGroupPageState extends State<AddUserToGroupPage> {
  List<User> selectedUsers = [];
  List<User> filteredUsers = users; // Initialize with all users
  TextEditingController searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add User to Group',
          style: TextStyle(color: Colors.white), // Titre en blanc
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white), // Icône de retour en blanc
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Member (déplacé en haut)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Add Member',
              style: AppTheme.heading2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterUsers(value);
              },
            ),
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
              onPressed: () {
                // Logique pour ajouter les membres sélectionnés au groupe
                setState(() {
                  widget.group.members.addAll(selectedUsers);
                });
                Navigator.pop(context); // Retour à la page précédente
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                'Add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          // Group Admin
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Group Admin',
              style: AppTheme.heading2,
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(widget.group.admin.avatar),
            ),
            title: Text(
              widget.group.admin.name,
              style: AppTheme.heading2.copyWith(fontSize: 16),
            ),
          ),
          Divider(),
          // Group Members
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Group Members',
              style: AppTheme.heading2,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.group.members.length,
              itemBuilder: (context, index) {
                final member = widget.group.members[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(member.avatar),
                  ),
                  title: Text(
                    member.name,
                    style: AppTheme.heading2.copyWith(fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}