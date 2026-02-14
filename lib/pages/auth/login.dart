// ignore_for_file: deprecated_member_use

import 'package:fitlife/services/auth_services.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final user = await auth.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Berhasil!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Gagal. Cek email/password.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                /// EMAIL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
