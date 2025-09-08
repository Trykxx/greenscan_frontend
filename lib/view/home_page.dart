import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              iconSize: 35,
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
          child: Column(
            children: [
              SizedBox(height: 0),

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
              FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF228b22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 13),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/scan');
                  },
                  child:const Text(
                      "Scanner un QR Code",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                  )
              ),

              const SizedBox(height: 50),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: const Text(
                    "Votre bibliothèque",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}