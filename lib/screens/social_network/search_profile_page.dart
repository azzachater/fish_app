import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'user_profile_page.dart';  // Import de la page de profil

class SearchProfilePage extends StatefulWidget {
  final List<User> users;

  const SearchProfilePage({super.key, required this.users});

  @override
  _SearchProfilePageState createState() => _SearchProfilePageState();
}

class _SearchProfilePageState extends State<SearchProfilePage> {
  // Liste des utilisateurs filtrés
  List<User> filteredUsers = [];

  // Contrôleur pour la recherche
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialiser filteredUsers avec tous les utilisateurs
    filteredUsers = widget.users;
  }

  // Fonction pour filtrer les utilisateurs en fonction du texte saisi
  void _filterUsers(String query) {
    final filtered = widget.users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: Colors.blue,
        actions: [
          // Champ de recherche dans l'AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Afficher le champ de recherche
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                    users: widget.users,
                    onQueryChanged: _filterUsers,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(user.avatar),
            ),
            title: Text(user.name), // Afficher seulement le nom
            onTap: () {
              // Lorsque l'utilisateur clique sur un autre utilisateur, naviguer vers son profil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Classe pour la recherche personnalisée
class CustomSearchDelegate extends SearchDelegate {
  final List<User> users;
  final Function(String) onQueryChanged;

  CustomSearchDelegate({required this.users, required this.onQueryChanged});

  @override
  String get searchFieldLabel => 'Search by name...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged(query);  // Réinitialiser le filtre
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredUsers = users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(user.avatar),
          ),
          title: Text(user.name),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(user: user),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredUsers = users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(user.avatar),
          ),
          title: Text(user.name),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(user: user),
              ),
            );
          },
        );
      },
    );
  }
}
