import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: MainAppWrapper(),
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}


class MainAppWrapper extends StatelessWidget {
  const MainAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: const MainApp(),
    );
  }
}