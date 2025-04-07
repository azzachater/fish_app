class User {
  final int id;
  String name;
  String email;
  String? token;
  String avatar;
  String bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.avatar,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Extrait les données du profil si elles existent
    final profile = json['profile'] is Map ? json['profile'] : {};
    
    return User(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: json['token']?.toString(),
      avatar: profile['avatar']?.toString() ?? 'assets/images/default_avatar.png',
      bio: profile['bio']?.toString() ?? 'je suis un pecheur et sa c est mon profile..!',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'avatar': avatar,
      'bio': bio,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? avatar,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
    );
  }
}