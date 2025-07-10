class Service {
  final String id;
  final String name;
  final String username;
  final String password;

  Service({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  factory Service.fromMap(String id, Map<String, dynamic> data) {
    return Service(
      id: id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'password': password,
    };
  }
}
