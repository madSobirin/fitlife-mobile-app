import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuDetailPage extends StatelessWidget {
  final Map<String, dynamic> menu;

  const MenuDetailPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          menu["nama_menu"] ?? "Detail Menu",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (menu["gambar"] != null)
              Image.network(
                menu["gambar"],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          menu["nama_menu"] ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1AB673).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          menu["target_status"] ?? "",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1AB673),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      _buildInfoItem(Icons.local_fire_department, "${menu["kalori"]} kal", Colors.orange),
                      const SizedBox(width: 20),
                      _buildInfoItem(Icons.access_time, "${menu["waktu_memasak"]} menit", Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Deskripsi",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    menu["deskripsi"] ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  // Resep/Cara Membuat (jika ada di masa depan, saat ini pakai placeholder)
                  Text(
                    "Cara Membuat",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ikuti langkah-langkah sehat untuk menyajikan menu ini. Pastikan bahan yang digunakan segar dan porsi sesuai dengan kebutuhan kalori harian Anda.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}