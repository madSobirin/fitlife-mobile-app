import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import '../models/user_model.dart';

Future<UserModel?> login(String email, String password) async {
  final url = Uri.parse('${Config.baseUrl}/auth/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('🔍 API Response data: $data');
      print('🔍 User data: ${data['user']}');

      final user = UserModel.fromJson({
        ...data['user'],
        'token': data['token'],
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));

      return user;
    } else {
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

Future<UserModel?> register(String name, String email, String password) async {
  final url = Uri.parse('${Config.baseUrl}/auth/register');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    print('🔍 Register status: ${response.statusCode}');
    print('🔍 Register body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // Handle different response structures:
      // Case 1: { user: {...}, token: "..." }
      // Case 2: { id, name, email, ... } (flat response)
      // Case 3: { message: "...", user: {...} } (no token)
      Map<String, dynamic> userData;
      if (data['user'] != null && data['user'] is Map) {
        userData = {...data['user'], 'token': data['token'] ?? ''};
      } else if (data['id'] != null) {
        userData = {...data, 'token': data['token'] ?? ''};
      } else {
        // Registration succeeded but no user data returned — build minimal
        userData = {
          'id': 0,
          'name': name,
          'email': email,
          'role': data['role'] ?? 'user',
          'token': data['token'] ?? '',
        };
      }

      final user = UserModel.fromJson(userData);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));

      return user;
    } else {
      print('🔍 Register failed with status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print("Register Error: $e");
    return null;
  }
}
