class User {
  final int id;
  String name;
  String email;
  String? token;
  String avatar;
  String bio;
  final bool emailVerified;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.avatar,
    required this.bio,
    this.emailVerified = false,
    this.createdAt,
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
      emailVerified: json['email_verified_at'] != null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'].toString())
          : null,
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
      'email_verified_at': emailVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? avatar,
    String? bio,
    bool? emailVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  // Define the empty static method to return an empty user object
  static User empty() {
    return User(id: 0, name: '', email: '', avatar: '', bio: '');
  }
}