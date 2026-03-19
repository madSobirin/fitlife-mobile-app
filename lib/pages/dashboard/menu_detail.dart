import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuDetailPage extends StatelessWidget {
  final Map<String, dynamic> menu;

  const MenuDetailPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(menu["name"])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(menu["image"]),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu["name"],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text("${menu["calories"]} kalori"),
                  Text("Waktu: ${menu["time"]}"),

                  const SizedBox(height: 20),

                  Text("Deskripsi"),
                  Text(menu["desc"]),

                  const SizedBox(height: 20),

                  Text("Resep"),
                  Text(menu["recipe"]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}