import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PassengerRideConfirmLoadingWidget extends StatefulWidget {
  const PassengerRideConfirmLoadingWidget({super.key});

  @override
  State<PassengerRideConfirmLoadingWidget> createState() => _PassengerRideConfirmLoadingWidgetState();
}

class _PassengerRideConfirmLoadingWidgetState extends State<PassengerRideConfirmLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Lottie.asset('assets/loading_animation.json', width: 100, height: 100),
        ),
      ),
    );
  }
}
