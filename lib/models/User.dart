class User {
  final int? id;
  final String username;
  final String email;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  /// This transforms map data into a User object because it is also a named constructor
  factory User.fromMap(Map<String, dynamic> userMap) {
    return User(
      id: userMap['id'],
      username: userMap['username'],
      email: userMap['email'],
      password: userMap['password'],
    );
  }

  /// This function transforms list data into a map format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
