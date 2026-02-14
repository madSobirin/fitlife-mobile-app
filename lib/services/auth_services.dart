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
