import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/views/driver/driver_profile/driver_profile_page.dart';
import 'package:tararide_mobile/views/driver/driver_ride_page/driver_ride_page.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key, required this.title});

  final String title;

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int pageIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const DriverRidePage(),
    SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: LottieBuilder.asset("assets/under_construction.json"),
          ),
          const Text(
            "Chat",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text("This area is still under construction."),
          const Text("We'll get there soon!"),
        ],
      ),
    ),
    SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: LottieBuilder.asset("assets/under_construction.json"),
          ),
          const Text(
            "History",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text("This area is still under construction."),
          const Text("We'll get there soon!"),
        ],
      ),
    ),
    const DriverProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(pageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          print("Value $value");

          setState(() {
            pageIndex = value;
          });
          print("$pageIndex");
        },
        backgroundColor: const Color.fromARGB(255, 93, 47, 123),
        type: BottomNavigationBarType.shifting,
        selectedItemColor: const Color.fromARGB(255, 93, 47, 123),
        unselectedItemColor: const Color.fromARGB(255, 119, 107, 128),
        elevation: 14,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
