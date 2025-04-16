class User {
  final int id;
  String name;
  String avatar;
  String email;
  String bio;
  String? token;
  final bool emailVerified;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.bio,
    this.token,
    this.emailVerified = false,
    this.createdAt,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      emailVerified: json['email_verified_at'] != null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,

    );
  }


  // 🔥 **Ajout de la méthode toJson**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'bio': bio,
      'token': token,
      'email_verified_at': emailVerified,
    };
  }

  User copyWith({
    String? avatar,
    String? bio,
    String? name,
    String? email,
    String? token,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      emailVerified: emailVerified ?? this.emailVerified,
      token: token ?? this.token,
    );
  }
}
