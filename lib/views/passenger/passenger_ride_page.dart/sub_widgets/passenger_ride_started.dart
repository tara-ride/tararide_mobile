import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

class PassengerRideStartedWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PassengerRideStartedWidget();
}

class _PassengerRideStartedWidget extends State<PassengerRideStartedWidget> {
  @override
  Widget build(BuildContext context) {
    PassengerRideStarted passengerRideStartedState = context.watch<PassengerRideStatusBloc>().state as PassengerRideStarted;
    // TODO: implement build
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Lottie.asset(
              'assets/sedan_car_driving.json',
              width: 150,
              height: 150,
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Your driver is on the way", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Driver:"),
                  const Text("Car: Toyota Vios"),
                  const Text("Plate Number: ABC1234"),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            context.read<PassengerRideStatusBloc>().add(PassengerRideProgress());
                          },
                          child: const Text("Confirm")),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
