import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import '../config/config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    final url = Uri.parse('${Config.baseUrl}$endpoint');
    return await http.get(url, headers: _getHeaders(token));
  }

  Future<http.Response> post(String endpoint, dynamic body) async {
    final token = await _getToken();
    final url = Uri.parse('${Config.baseUrl}$endpoint');
    return await http.post(
      url,
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, dynamic body) async {
    final token = await _getToken();
    final url = Uri.parse('${Config.baseUrl}$endpoint');
    return await http.put(
      url,
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String endpoint, dynamic body) async {
    final token = await _getToken();
    final url = Uri.parse('${Config.baseUrl}$endpoint');
    return await http.patch(
      url,
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    final url = Uri.parse('${Config.baseUrl}$endpoint');
    return await http.delete(url, headers: _getHeaders(token));
  }

  /// Helper to handle response and return data or throw error
  dynamic handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Terjadi kesalahan pada server');
    }
  }

  Future<http.Response> postMultipart(String endpoint, String fileField, String filePath) async {
    final token = await _getToken();
    final url = Uri.parse('${Config.baseUrl}$endpoint');
    
    var request = http.MultipartRequest('POST', url);
    
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    
    final ext = filePath.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
    
    request.files.add(await http.MultipartFile.fromPath(
      fileField, 
      filePath,
      contentType: MediaType('image', ext),
    ));
    
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
