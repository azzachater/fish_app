class User {
  final int id;
  String name;
  String avatar;
  String email;
  String password;  // Ajoutez le mot de passe
  String passwordConfirmation;  // Ajoutez la confirmation du mot de passe
  String bio;  // Ajoutez la bio

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.password,  // Ajoutez le mot de passe dans le constructeur
    required this.passwordConfirmation,  // Ajoutez la confirmation du mot de passe
    required this.bio,  // Ajoutez la bio
  });

  User copyWith({
    String? avatar,
    String? bio,
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      bio: bio ?? this.bio,
    );
  }
}
