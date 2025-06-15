import 'package:flutter/material.dart';

class PassengerRideConfirmErrorWidget extends StatelessWidget {
  String errorMessage;
  PassengerRideConfirmErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 100, color: Colors.red),
              SizedBox(height: 20),
              Text(
                'An error occurred while confirming the ride.',
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
