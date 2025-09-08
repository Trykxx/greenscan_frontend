import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Simule un chargement

    await Future.delayed(Duration(seconds: 2));

    // Vérifier si l'utilisateur est déjà connecté
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Utilisateur connecté → Aller à l'accueil
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Utilisateur non connecté → Aller au login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo-greenscan.svg',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
            Text(
              'Greenscan',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF228b22),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Scannez, Réduisez, Protégez',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF228b22),
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF228b22)),
            ),
          ],
        ),
      ),
    );
  }

}
