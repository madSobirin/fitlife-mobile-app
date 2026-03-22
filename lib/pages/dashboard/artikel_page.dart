import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/artikel_service.dart';
import '../../models/artikel_model.dart';

class ArtikelPage extends StatefulWidget {
  final VoidCallback onBack;
  const ArtikelPage({super.key, required this.onBack});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  final ArtikelService _artikelService = ArtikelService();
  int selectedCategory = 0;

  final categories = [
    "Semua",
    "Tips Diet",
    "Pola Hidup",
    "Olahraga",
    "Resep Sehat",
  ];

  Widget _categoryChip(String label, int index) {
    final isSelected = selectedCategory == index;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1AB673)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _articleCard(ArtikelModel artikel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[300],
              image: DecorationImage(
                image: NetworkImage(artikel.gambar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artikel.kategori.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1AB673),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artikel.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${artikel.penulis} • ${artikel.dibaca} Kali Baca",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArtikelModel>>(
      future: _artikelService.getArtikels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1AB673)));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final allArtikels = snapshot.data ?? [];
        final filteredArtikels = selectedCategory == 0
            ? allArtikels
            : allArtikels.where((a) => a.kategori == categories[selectedCategory]).toList();

        final featuredArtikel = allArtikels.firstWhere((a) => a.isFeatured, orElse: () => allArtikels.first);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Artikel & Tips",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// HERO CARD (Featured)
              if (allArtikels.isNotEmpty)
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: NetworkImage(featuredArtikel.gambar),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        featuredArtikel.judul,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              /// CATEGORY FILTER
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    categories.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _categoryChip(categories[index], index),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// LIST TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Terbaru Untukmu",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1AB673),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ARTICLE LIST
              if (filteredArtikels.isEmpty)
                const Center(child: Text("Tidak ada artikel di kategori ini."))
              else
                ...filteredArtikels.map((artikel) => _articleCard(artikel)),
            ],
          ),
        );
      },
    );
  }
}

