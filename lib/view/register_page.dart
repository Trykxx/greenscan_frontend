import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Exposant
  final _nomSocieteController = TextEditingController();
  final _numeroSirenController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isVisiteur = true;
  bool _isLoading = false;
  bool _isCheckingEmail = false;
  bool? _emailExists;
  Timer? _emailDebounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Greenscan",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF228b22),
                ),
              ),

              const SizedBox(height: 10),

              // Slogan
              const Text(
                "Scannez, Réduisez, Protégez",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF228b22),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 40),

              _buildTextField(
                controller: _lastNameController,
                hintText: 'Nom',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              _buildTextField(
                controller: _firstNameController,
                hintText: 'Prénom',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                onChanged: _checkEmail,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Email invalide';
                  }
                  if (_emailExists == true) {
                    return 'Cet email est déjà utilisé';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              _buildPasswordField(
                controller: _passwordController,
                hintText: 'Mot de passe',
                isVisible: _isPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              _buildPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirmez votre mot de passe',
                isVisible: _isConfirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  const Text(
                    'Je suis :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 20),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isVisiteur = true;

                        // Clear les champs quand il n'est pas exposant
                        _nomSocieteController.clear();
                        _numeroSirenController.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isVisiteur ? const Color(0xFF228b22) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Visiteur',
                        style: TextStyle(
                          color: _isVisiteur ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isVisiteur = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: !_isVisiteur ? const Color(0xFF228b22) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Exposant',
                        style: TextStyle(
                          color: !_isVisiteur ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (!_isVisiteur) ...[
                const SizedBox(height: 30),

                // Titre pour les informations d'entreprise
                const Text(
                  'Informations de votre entreprise',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 15),

                // Champ Nom de la société
                _buildTextField(
                  controller: _nomSocieteController,
                  hintText: 'Nom de la société',
                  validator: (value) {
                    if (!_isVisiteur && (value == null || value.isEmpty)) {
                      return 'Veuillez entrer le nom de votre société';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Champ Numéro KBIS
                _buildTextField(
                  controller: _numeroSirenController, // 👈 Nouveau nom
                  hintText: 'Numéro SIREN (9 chiffres)',
                  keyboardType: TextInputType.number,
                  maxLength: 9, // 👈 Limiter à 9 chiffres
                  validator: (value) {
                    if (!_isVisiteur && (value == null || value.isEmpty)) {
                      return 'Veuillez entrer votre numéro SIREN';
                    }
                    if (!_isVisiteur && value != null && value.length != 9) {
                      return 'Le SIREN doit contenir exactement 9 chiffres';
                    }
                    if (!_isVisiteur && value != null && !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Le SIREN ne doit contenir que des chiffres';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 40),

              Container(
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF228b22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'J\'ai déjà un compte',
                    style: TextStyle(
                      color: Color(0xFF228b22),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    )
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLength,
    void Function(String)? onChanged,
  }) {

    Widget? suffixIcon;
    if (hintText == 'Email') {
      if (_isCheckingEmail) {
        suffixIcon = Container(
          width: 20,
          height: 20,
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      } else if (_emailExists == true) {
        suffixIcon = Icon(Icons.error, color: Colors.red);
      } else if (_emailExists == false) {
        suffixIcon = Icon(Icons.check_circle, color: Colors.green);
      }
    }
    return Container(
      height: 55,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLength: maxLength,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF228b22)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          counterText: maxLength != null ? '' : null,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,

  }) {
    return Container(
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: onToggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF4CAF50)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }

  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final body = {
        'lastName': _lastNameController.text,
        'firstName': _firstNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'user_type': _isVisiteur ? 'visiteur' : 'exposant',
      };

      // Champs exposant
      if (!_isVisiteur) {
        body['company_name'] = _nomSocieteController.text;
        body['siren_number'] = _numeroSirenController.text;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      print('Status Code: ${response.statusCode}'); // 👈 AJOUTEZ ÇA
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription réussie !'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final error = json.decode(response.body);
        print('Erreur lors de l\'inscription');
        print('Détails: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailDebounce?.cancel();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Exposant
    _nomSocieteController.dispose();
    _numeroSirenController.dispose();
    super.dispose();
  }

  void _checkEmail(String email) {
    if (_emailDebounce?.isActive ?? false) _emailDebounce!.cancel();

    _emailDebounce = Timer(const Duration(milliseconds: 800), () async {
      if (email.isNotEmpty && email.contains('@')) {
        setState(() {
          _isCheckingEmail = true;
          _emailExists = null;
        });

        try {
          final response = await http.post(
            Uri.parse('$baseUrl/check-email'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            setState(() {
              _isCheckingEmail = false;
              _emailExists = data['exists'] ?? false;
            });
          }
        } catch (e) {
          setState(() {
            _isCheckingEmail = false;
            _emailExists = null;
          });
          print('Erreur vérification email: $e');
        }
      }
    });
  }
}
