import 'package:flutter/material.dart';
import 'package:jumper/onboarding/screens/scanningScreen.dart';

void main() {
  runApp(const Kookaburra());
}

class Kookaburra extends StatelessWidget {
  const Kookaburra({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kookaburra',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // This is fine for now, should probably be changed in the future
      home: ScanningScreen(),
    );
  }
}