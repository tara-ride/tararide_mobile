import 'package:flutter/material.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key, required this.title});

  final String title;

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Driver Main App, initializations happen here.",),
      ),
    );
  }
}