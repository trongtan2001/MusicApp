class User {
  final int? id;
  final String name;
  final String image;
  final String role;
  final String email;
  final String password;

  User ({
      required this.id,
      required this.name,
      this.image = 'assets/image1.jpg',
      required this.role,
      required this.email,
      required this.password
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        name: map['name'],
        image: map['image'] ?? 'assets/image1.jpg',
        role: map['role'],
        email: map['email'],
        password: map['password']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'role': role,
      'email': email,
      'password': password,
    };
  }
}

const String ROLE_MEMBER = 'member';
const String ROLE_PLUS = 'plus';
const String ROLE_PREMIUM = 'premium';
