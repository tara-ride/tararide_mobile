import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/views/passenger/passenger_chat/passenger_chat.dart';
import 'package:tararide_mobile/views/passenger/passenger_history/passenger_history.dart';
import 'package:tararide_mobile/views/passenger/passenger_profile_page/passenger_profile.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/passenger_ride.dart';

class PassengerHomePage extends StatefulWidget {
  const PassengerHomePage({super.key, required this.title});

  final String title;

  @override
  State<PassengerHomePage> createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {
  int pageIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const PassengerRide(),
    PassengerChat(),
    PassengerHistory(),
    PassengerProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(pageIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
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
      ),
    );
  }
}
