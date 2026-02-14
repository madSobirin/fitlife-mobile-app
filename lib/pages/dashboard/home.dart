// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:fitlife/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// ====== BODY CONTROLLER ======
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const Center(child: Text("Halaman Kalkulator"));
      case 2:
        return const Center(child: Text("Halaman Menu"));
      case 3:
        return const Center(child: Text("Halaman Artikel"));
      case 4:
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  /// ====== HOME CONTENT ======
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // HERO SECTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1AB673), Color(0xFF0E8F5A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Selamat Datang di FitLife.id',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Platform manajemen diet dan pola makan digital untuk hidup lebih sehat dan bahagia',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          Text(
            'Fitur Unggulan',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dapatkan semua yang anda butuhkan untuk mencapai tujuan kesehatan anda',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.black54),
          ),
          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 25,
              runSpacing: 25,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureCard(
                  Icons.calculate,
                  'Kalkulator BMI',
                  'Hitung indeks massa tubuh anda dan dapatkan rekomendasi berat badan ideal',
                  iconColor: Colors.orange,
                ),
                _buildFeatureCard(
                  Icons.restaurant_menu,
                  'Menu Sehat',
                  'Temukan berbagai pilihan menu makanan sehat untuk diet anda',
                  iconColor: Colors.pink,
                ),
                _buildFeatureCard(
                  Icons.article,
                  'Artikel',
                  'Baca artikel dan tips seputar diet serta pola hidup sehat',
                  iconColor: Colors.blue,
                ),
                _buildFeatureCard(
                  Icons.person,
                  'Profil',
                  'Kelola informasi pribadi dan pantau perkembangan kesehatan anda',
                  iconColor: Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  /// ====== PROFILE CONTENT ======
  Future<UserModel?> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  Widget _buildProfileContent() {
    return FutureBuilder<UserModel?>(
      future: _getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;

        return Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  user?.name ?? 'User',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? '-',
                  style: GoogleFonts.poppins(color: Colors.black54),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('user');
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  child: Text(
                    "Logout",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ====== FEATURE CARD ======
  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String desc, {
    Color iconColor = Colors.green,
    double iconSize = 45,
  }) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.black54, fontSize: 18),
          ),
        ],
      ),
    );
  }

  /// ====== BUILD ======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'FitLife.id',
          style: GoogleFonts.poppins(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
