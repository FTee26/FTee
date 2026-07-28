import 'package:flutter/material.dart';

void main() {
  runApp(const TomHubApp());
}

class TomHubApp extends StatelessWidget {
  const TomHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TomHub',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Startseite(),
    );
  }
}

class Startseite extends StatelessWidget {
  const Startseite({super.key});

  void _buttonGedrueckt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Benachrichtigung wurde ausgelöst'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _buttonGedrueckt(context),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(36),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 8,
          ),
          child: const Icon(
            Icons.mail,
            size: 64,
          ),
        ),
      ),
    );
  }
}