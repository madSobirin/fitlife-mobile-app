import 'dart:convert';
import '../models/perhitungan_model.dart';
import 'api_service.dart';

class PerhitunganService {
  final ApiService _api = ApiService();

  /// Ambil riwayat perhitungan BMI (response = array langsung)
  Future<List<PerhitunganModel>> getHistory() async {
    try {
      final response = await _api.get('/perhitungan');
      final body = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Backend returns raw array langsung
        if (body is List) {
          return body.map((item) => PerhitunganModel.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil riwayat perhitungan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data riwayat perhitungan: $e');
    }
  }

  /// Hitung BMI — backend menghitung sendiri, hanya kirim tinggi & berat
  /// Response: { bmi: 24.2, status: "Normal" }
  Future<Map<String, dynamic>> hitungBMI({
    required double tinggiBadan,
    required double beratBadan,
  }) async {
    try {
      final response = await _api.post('/perhitungan', {
        'tinggi_badan': tinggiBadan,
        'berat_badan': beratBadan,
      });

      final body = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'bmi': (body['bmi'] as num).toDouble(),
          'status': body['status'] as String,
        };
      } else {
        throw Exception(body['message'] ?? 'Gagal menghitung BMI');
      }
    } catch (e) {
      throw Exception('Gagal menyimpan data perhitungan: $e');
    }
  }
}
