import 'package:flutter/material.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.green,

      ),
      body: const Center(
        child: Text(
          'Page de scan',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}