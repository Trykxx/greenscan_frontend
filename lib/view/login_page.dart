import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // ← Ajoutez cet import
import 'dart:convert'; // ← Et celui-ci


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 80),

              // Logo et titre
              _buildHeader(),

              SizedBox(height: 60),

              // Formulaire
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEmailField(),

                    SizedBox(height: 20),

                    _buildPasswordField(),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Bouton connexion
              _buildLoginButton(),

              SizedBox(height: 30),

              // Lien inscription
              _buildSignupLink(),

              SizedBox(height: 20),

              // CGU
              _buildTermsText(),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Greenscan',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF228b22),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Scannez, Réduisez, Protégez',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF228b22),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'L\'email est requis';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Email invalide';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF228b22), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Le mot de passe est requis';
        }
        if (value!.length < 6) {
          return 'Minimum 6 caractères';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Mot de passe',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF228b22), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade500,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF228b22),
          disabledBackgroundColor: Color(0xFF4CAF50).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          shadowColor: Color(0xFF228b22).withOpacity(0.3),
        ),
        child: _isLoading
            ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          'Se connecter',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
          children: [
            TextSpan(text: 'Vous n\'avez pas de compte ? '),
            TextSpan(
              text: 'Inscrivez-vous',
              style: TextStyle(
                color: Color(0xFF228b22),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, '/register');
                  // Navigation vers la page d'inscription
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          children: [
            TextSpan(text: 'En vous connectant, vous acceptez nos '),
            TextSpan(
              text: 'CGU',
              style: TextStyle(
                color: Color(0xFF228b22),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Ouvrir les CGU
                },
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('🚀 Tentative de connexion...'); // DEBUG

        // VRAIE requête vers votre API Laravel
        final response = await http.post(
          Uri.parse('http://10.0.2.2:9005/api/login'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          }),
        );

        print('📡 Status: ${response.statusCode}'); // DEBUG
        print('📄 Response: ${response.body}'); // DEBUG

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['success'] == true) {
            // 🔑 SAUVEGARDER LE TOKEN (pas juste un booléen !)
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', data['data']['token']); // ← LE TOKEN !

            print('✅ Token sauvegardé: ${data['data']['token']}'); // DEBUG

            setState(() {
              _isLoading = false;
            });

            // Message de succès
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Connexion réussie !'),
                backgroundColor: Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Navigation vers l'accueil
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Erreur de l'API
            _showError(data['message'] ?? 'Erreur de connexion');
          }
        } else if (response.statusCode == 401) {
          _showError('Email ou mot de passe incorrect');
        } else {
          _showError('Erreur du serveur (${response.statusCode})');
        }
      } catch (e) {
        print('💥 Exception: $e'); // DEBUG
        _showError('Erreur de connexion: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
