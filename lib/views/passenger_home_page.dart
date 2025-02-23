import 'package:flutter/material.dart';

class PassengerHomePage extends StatefulWidget {
  const PassengerHomePage({super.key, required this.title});

  final String title;

  @override
  State<PassengerHomePage> createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Main App, initializations happen here."),
      ),
    );
  }
}