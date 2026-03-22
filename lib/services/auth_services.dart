import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final ApiService _api = ApiService();

  // ── Login Manual ──
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _api.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = _api.handleResponse(response);
      final user = UserModel.fromJson({
        ...data['user'],
        'token': data['token'],
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));
      await prefs.setString('token', data['token']);

      return {'success': true, 'user': user};
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst('Exception: ', '')};
    }
  }

  // ── Register ──
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _api.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      final data = _api.handleResponse(response);

      // Register berhasil — ada token langsung
      if (data['token'] != null) {
        final user = UserModel.fromJson({
          ...data['user'],
          'token': data['token'],
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(user.toJson()));
        await prefs.setString('token', data['token']);

        return {'success': true, 'user': user};
      }
      // Register berhasil tanpa token (perlu login)
      return {'success': true, 'user': null};
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst('Exception: ', '')};
    }
  }

  // ── Login Google ──
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: Config.googleClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return {'success': false, 'message': 'Login dibatalkan.'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return {'success': false, 'message': 'Gagal mendapatkan token Google.'};
      }

      final response = await _api.post('/auth/google', {'id_token': idToken});
      final data = _api.handleResponse(response);

      final user = UserModel.fromJson({
        ...data['user'],
        'token': data['token'],
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));
      await prefs.setString('token', data['token']);

      return {'success': true, 'user': user};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // ── Logout ──
  Future<void> logout() async {
    try {
      final response = await _api.post('/auth/logout', {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Logged out successfully from server
      }
    } catch (_) {}

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
    } catch (_) {}

    // Hapus semua local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
  }

  // ── Get current user dari local storage ──
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return null;
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (_) {
      return null;
    }
  }

  // ── Get token ──
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
