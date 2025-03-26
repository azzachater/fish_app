import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/group_model.dart';
import '../../constants/theme.dart';
import '../../controllers/addusertogroup_controller.dart';

class AddUserToGroupPage extends StatelessWidget {
  final Group group;

  const AddUserToGroupPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final AddUserToGroupController controller = Get.put(AddUserToGroupController());

    // Ajouter les membres existants du groupe à la sélection initiale
    if (controller.selectedUsers.isEmpty) {
      controller.selectedUsers.addAll(group.members);
    }

    // Assurer que l'utilisateur actuel est membre du groupe par défaut
    if (!group.members.any((u) => u.id == controller.currentUser.id)) {
      group.members.add(controller.currentUser);
    }

    // Ajouter aussi l'utilisateur actuel à la sélection par défaut
    if (!controller.selectedUsers.any((u) => u.id == controller.currentUser.id)) {
      controller.selectedUsers.add(controller.currentUser);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add User to Group',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                controller.filterUsers(value); // Applique le filtre lors de la saisie
              },
            ),
          ),
          SizedBox(height: 10),
          // Liste des utilisateurs filtrés avec Obx uniquement pour la liste filtrée
          SizedBox(
  height: 80,
  child: Obx(() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.filteredUsers.length,
      itemBuilder: (context, index) {
        final user = controller.filteredUsers[index];
        final isGroupMember = group.members.any((u) => u.id == user.id);
        final isSelected = controller.selectedUsers.any((u) => u.id == user.id);

        return GestureDetector(
          onTap: () {
            if (!isGroupMember) {
              if (isSelected) {
                controller.selectedUsers.removeWhere((u) => u.id == user.id);
              } else {
                controller.selectedUsers.add(user);
              }
              controller.selectedUsers.refresh();
            }
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent, // Changer la bordure si sélectionné
                    width: 3,
                  ),
                ),
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
                    color: isGroupMember ? Colors.grey : Colors.green,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }),
),

          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                for (var user in controller.selectedUsers) {
                  if (!group.members.any((u) => u.id == user.id)) {
                    group.members.add(user);
                  }
                }
                controller.selectedUsers.clear(); // Réinitialiser la sélection après ajout
                Get.back(); // Ferme la page
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
              backgroundImage: AssetImage(group.admin.avatar),
            ),
            title: Text(
              group.admin.name,
              style: AppTheme.heading2.copyWith(fontSize: 16),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Group Members',
              style: AppTheme.heading2,
            ),
          ),
          Expanded(
            // Liste des membres sans Obx, car elle ne change pas en fonction d'une variable observable
            child: ListView.builder(
              itemCount: group.members.length,
              itemBuilder: (context, index) {
                final member = group.members[index];
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
