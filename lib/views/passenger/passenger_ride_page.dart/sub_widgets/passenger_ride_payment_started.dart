import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';

class PassengerRidePaymentStartedWidget extends StatefulWidget {
  final RideInformationModel rideInformation;

  const PassengerRidePaymentStartedWidget({super.key, required this.rideInformation});

  @override
  State<StatefulWidget> createState() => _PassengerRidePaymentStartedState();
}

class _PassengerRidePaymentStartedState extends State<PassengerRidePaymentStartedWidget> {
  int getOccupiedSeats() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      for (var passenger in widget.rideInformation.passengersList) {
        if (passenger.passengerId == firebaseUser.uid) {
          return passenger.seatsOccupied;
        }
      }
    }
    return 0;
  }

  double getFare() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      for (var passenger in widget.rideInformation.passengersList) {
        if (passenger.passengerId == firebaseUser.uid) {
          return passenger.estimatedFare;
        }
      }
      return 0;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Payment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Lottie.asset('assets/payment_loading.json'),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text("Distance Traveled: 11 km"),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text("Time Taken: 15 mins"),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text("Total Amount: ₱ ${getFare()}"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                        if (firebaseAuth.currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("An error occurred, please check your network availability and try again."),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                          var documentReference = firebaseFirestore.collection("ride_information").doc(widget.rideInformation.rideId);
                          await documentReference.update({
                            "ride_earnings": FieldValue.increment(getFare()),
                            "available_seats": FieldValue.increment(getOccupiedSeats() * -1),
                          });

                          var paymentReference = firebaseFirestore.collection("payment_information").doc();
                          await paymentReference.set({
                            "payment_id": paymentReference.id,
                            "ride_id": widget.rideInformation.rideId,
                            "amount_paid": getFare(),
                            "amount_paid_on": DateTime.now(),
                          });

                          var historyReference = firebaseFirestore.collection("ride_history_information").doc();
                          await historyReference.set({
                            "history_id": historyReference.id,
                            "ride_id": widget.rideInformation.rideId,
                            "ride_title": widget.rideInformation.rideTitle,
                            "ride_description": widget.rideInformation.rideDescription,
                            "ride_destination": widget.rideInformation.rideDestination,
                            "ride_source_location": widget.rideInformation.rideSourceLocation,
                            "passenger_id": firebaseAuth.currentUser!.uid,
                            "payment_id": paymentReference.id,
                            "feedback_id": "",
                          });
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$error"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Payment has been completed!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      context.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackStart());
                    },
                    child: const Text(
                      "Pay in Cash",
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Payment gateway server has issues. Please proceed to pay in cash."),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      //context.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackStart());
                    },
                    child: const Text(
                      "Pay via E-wallet",
                    ))),
          ),
        ],
      ),
    );
  }
}
