class PerhitunganModel {
  final int id;
  final int userId;
  final double tinggiBadan;
  final double beratBadan;
  final double bmi;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PerhitunganModel({
    required this.id,
    required this.userId,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.bmi,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PerhitunganModel.fromJson(Map<String, dynamic> json) {
    return PerhitunganModel(
      id: json['id'],
      userId: json['user_id'],
      tinggiBadan: (json['tinggi_badan'] as num).toDouble(),
      beratBadan: (json['berat_badan'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tinggi_badan': tinggiBadan,
      'berat_badan': beratBadan,
      'bmi': bmi,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
