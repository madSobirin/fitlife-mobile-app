import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/menu_service.dart';
import '../../models/menu_model.dart';
import 'menu_detail.dart';

class MenuPage extends StatefulWidget {
  final VoidCallback onBack;
  const MenuPage({super.key, required this.onBack});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuService _menuService = MenuService();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuModel>>(
      future: _menuService.getMenus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1AB673)));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final allMenus = snapshot.data ?? [];
        final filteredMenus = allMenus
            .where((m) =>
                m.namaMenu.toLowerCase().contains(search.toLowerCase()))
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Menu Sehat",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Bar
              TextField(
                onChanged: (value) => setState(() => search = value),
                decoration: InputDecoration(
                  hintText: "Cari menu sehat...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // List Menu
              if (filteredMenus.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text("Menu tidak ditemukan"),
                ))
              else
                ...filteredMenus.map((menu) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MenuDetailPage(menu: menu.toJson()),
                        ),
                      );
                    },
                    child: Container(
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
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(menu.gambar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu.namaMenu,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  menu.deskripsi,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${menu.kalori} kal",
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.access_time, size: 14, color: Colors.blue),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${menu.waktuMemasak} menit",
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}