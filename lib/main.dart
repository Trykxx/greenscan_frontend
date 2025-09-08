import 'package:flutter/material.dart';
import 'package:frontend/view/edit_profile_page.dart';
import 'view/splash_screen.dart';
import 'package:frontend/view/login_page.dart';
import 'view/profile_page.dart';
import 'view/register_page.dart';
import 'view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greenscan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/splash',
      routes: {
        '/profile': (context) => ProfilePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(title: "Greenscan"),
        '/splash': (context) => SplashScreen(),
        '/edit-profile': (context) => EditProfilePage(),
      },
    );
  }
}