import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu_detail.dart';

class MenuPage extends StatefulWidget {
  final VoidCallback onBack;
  const MenuPage({super.key, required this.onBack});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String search = "";

  final List<Map<String, dynamic>> menus = [
    {
      "name": "Salad Sayur",
      "image": "https://source.unsplash.com/400x300/?salad",
      "calories": 150,
      "time": "10 menit",
      "desc": "Salad segar rendah kalori",
      "recipe": "Campur sayur + saus sehat"
    },
    {
      "name": "Oatmeal Buah",
      "image": "https://source.unsplash.com/400x300/?oatmeal",
      "calories": 200,
      "time": "5 menit",
      "desc": "Sarapan sehat tinggi serat",
      "recipe": "Masak oatmeal + topping buah"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMenus = menus
        .where((m) =>
            m["name"].toLowerCase().contains(search.toLowerCase()))
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
          ...filteredMenus.map((menu) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MenuDetailPage(menu: menu),
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
                          image: NetworkImage(menu["image"]),
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
                            menu["name"],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(menu["desc"]),
                          const SizedBox(height: 6),
                          Text(
                            "${menu["calories"]} kal • ${menu["time"]}",
                            style: const TextStyle(color: Colors.grey),
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
  }
}