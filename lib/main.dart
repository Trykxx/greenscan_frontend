import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/view/edit_profile_page.dart';
import 'view/splash_screen.dart';
import 'package:frontend/view/login_page.dart';
import 'view/profile_page.dart';
import 'view/register_page.dart';
import 'view/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔍 DIAGNOSTIC FIREBASE
  print('🔥 Firebase initialisé');

  // 🔐 Authentification forcée
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    print('✅ Utilisateur anonyme: ${userCredential.user?.uid}');
  } catch (e) {
    print('❌ Erreur auth anonyme: $e');
  }

  // 📦 Test Storage Bucket
  try {
    final storageRef = FirebaseStorage.instance.ref();
    print('✅ Storage référence: ${storageRef.bucket}');
    print('✅ Storage root: ${storageRef.fullPath}');
  } catch (e) {
    print('❌ Erreur Storage: $e');
  }

  runApp(MyApp());
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
        '/edit-profile': (context) => EditProfilePage(userData: {},),
      },
    );
  }
}