class User {
  final int id;
  final String name;
  final String avatar;
  final String email; // Ajout de l'email

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email, // Ajout de l'email dans le constructeur
  });

  User copyWith({String? avatar, String? bio, String? name, String? email}) {
    return User(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email, // Inclure l'email dans copyWith
    );
  }
}
