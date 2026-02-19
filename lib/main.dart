import 'package:fitlife/pages/dashboard/home.dart';
import 'package:flutter/material.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';
import 'pages/dashboard/profile.dart';

void main() {
  runApp(const FitLifeApp());
}

class FitLifeApp extends StatelessWidget {
  const FitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitLife.id',
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => Home(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
