class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  /// Safely extract a String from a value that might be a List or String
  static String _toString(dynamic value, [String fallback = '']) {
    if (value is List)
      return value.isNotEmpty ? value.first.toString() : fallback;
    return value?.toString() ?? fallback;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: _toString(json['name']),
      email: _toString(json['email']),
      role: _toString(json['role']),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
    };
  }
}
