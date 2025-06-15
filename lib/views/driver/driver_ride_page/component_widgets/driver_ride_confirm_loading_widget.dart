import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DriverRideConfirmLoadingWidget extends StatefulWidget {
  const DriverRideConfirmLoadingWidget({super.key});

  @override
  State<DriverRideConfirmLoadingWidget> createState() => _DriverRideConfirmLoadingWidgetState();
}

class _DriverRideConfirmLoadingWidgetState extends State<DriverRideConfirmLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Lottie.asset('assets/loading_animation.json', width: 360, height: 360),
        ),
      ),
    );
  }
}
