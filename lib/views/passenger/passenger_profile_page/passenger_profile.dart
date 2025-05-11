import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PassengerProfile extends StatefulWidget {
  const PassengerProfile({super.key});

  @override
  State<StatefulWidget> createState() => PassengerProfileState();
}

class PassengerProfileState extends State<PassengerProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "User Profile",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(blurRadius: 8, blurStyle: BlurStyle.outer, color: Colors.black, offset: Offset(0, 0), spreadRadius: 0),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/New-York-City-Backgrounds-HD.jpg"),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      height: 70,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [
                          0.0,
                          1.0
                        ], colors: [
                          Color.fromARGB(255, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0),
                        ]),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Container(
                                height: 60,
                                width: 200,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Juan Dela Cruz",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "id: uVwwevbt1h1wt114",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: AnimatedContainer(
                        height: 120,
                        width: 120,
                        duration: const Duration(seconds: 1),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 234, 222, 255),
                           boxShadow: [
                            BoxShadow(blurRadius: 2, blurStyle: BlurStyle.outer, color: Colors.black, offset: Offset(0, 0), spreadRadius: 0),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        curve: Curves.easeInOut,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Center(
                              child: Text(
                                "100",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                            )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: Text(
                                "Rides Completed",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: AnimatedContainer(
                        height: 120,
                        width: 120,
                        duration: const Duration(seconds: 1),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 255, 242),
                          boxShadow: [
                            BoxShadow(blurRadius: 2, blurStyle: BlurStyle.outer, color: Colors.black, offset: Offset(0, 0), spreadRadius: 0),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        curve: Curves.easeInOut,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Center(
                              child: Text(
                                "0.3",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                            )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: Text(
                                "Distance Travelled (km)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Settings",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "My Account",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "My Personal Data",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "My Contacts and Addresses",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
