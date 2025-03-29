class User {
  final int id;
  String name;
  String avatar;
  String email;
  String password;
  String passwordConfirmation;
  String bio;
  String? token;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.bio,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'] ?? '',
      email: json['email'],
      password: json['password'] ?? '',
      passwordConfirmation: json['password_confirmation'] ?? '',
      bio: json['bio'] ?? '',
      token: json['token'], // Ajout de token si disponible
    );
  }

  // 🔥 **Ajout de la méthode toJson**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'password': password, // Attention : éviter d'inclure le mot de passe en clair
      'password_confirmation': passwordConfirmation,
      'bio': bio,
      'token': token,
    };
  }

  User copyWith({
    String? avatar,
    String? bio,
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? token,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      bio: bio ?? this.bio,
      token: token ?? this.token,
    );
  }
}
