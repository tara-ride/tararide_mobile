// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/views/passenger/passenger_payment/passenger_payment.dart';

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

  double getDistance() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      for (var passenger in widget.rideInformation.passengersList) {
        if (passenger.passengerId == firebaseUser.uid) {
          return passenger.rideDistance;
        }
      }
      return 0;
    } else {
      return 0;
    }
  }

  String getETA() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      for (var passenger in widget.rideInformation.passengersList) {
        if (passenger.passengerId == firebaseUser.uid) {
          return passenger.rideDuration;
        }
      }
      return "N/A";
    } else {
      return "N/A";
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
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text("Distance Traveled: ${getDistance()}"),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text("Time Taken: ${getETA()}"),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text("Total Amount: ₱ ${getFare().toStringAsFixed(2)}"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      print("DID WE CLICK DIS SHII");
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
                            "available_seats": FieldValue.increment(getOccupiedSeats()),
                          });

                          var paymentReference = firebaseFirestore.collection("payment_information").doc();
                          await paymentReference.set({
                            "payment_id": paymentReference.id,
                            "ride_id": widget.rideInformation.rideId,
                            "payment_method": "cash",
                            "amount_paid": getFare(),
                            "amount_paid_on": DateTime.now(),
                          });

                          var accountReference = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);
                          await accountReference.update({"status": "for_feedback"});

                          var historyReference = firebaseFirestore.collection("ride_history_information").doc();
                          await historyReference.set({
                            "history_id": historyReference.id,
                            "ride_id": widget.rideInformation.rideId,
                            "ride_title": widget.rideInformation.rideTitle,
                            "ride_description": widget.rideInformation.rideDescription,
                            "ride_completed_at": DateTime.now(),
                            "ride_destination": GeoPoint(widget.rideInformation.rideDestination.latitude, widget.rideInformation.rideDestination.longitude),
                            "ride_source_location": GeoPoint(widget.rideInformation.rideSourceLocation.latitude, widget.rideInformation.rideSourceLocation.longitude),
                            "passenger_id": firebaseAuth.currentUser!.uid,
                            "payment_id": paymentReference.id,
                          });

                          var rideInformationReference = firebaseFirestore.collection("ride_information").doc(widget.rideInformation.rideId);

                          if (firebaseAuth.currentUser != null) {
                            widget.rideInformation.passengersList.removeWhere((item) {
                              return item.passengerId == firebaseAuth.currentUser!.uid;
                            });
                          }
                          await rideInformationReference.update({
                            "passengers_list": widget.rideInformation.passengersList,
                          });
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Payment has been completed!"),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        context.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackStart(rideId: widget.rideInformation.rideId));
                      } catch (error) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$error"),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
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
                    onPressed: () async {
                      FirebaseAuth firebaseAuth = FirebaseAuth.instance;

                      const String url = 'https://api.paymongo.com/v1/checkout_sessions';
                      const String basicAuth = 'Basic c2tfdGVzdF9wRVFSeXZtRU5ydWVURVhNSDNjMjdxTUg6'; // Your base64 encoded API key

                      final Map<String, dynamic> requestBody = {
                        "data": {
                          "attributes": {
                            "send_email_receipt": false,
                            "show_description": false,
                            "show_line_items": true,
                            "line_items": [
                              {
                                "currency": "PHP",
                                "amount": (getFare() * 100).toInt(), // Amount in cents/centavos (200.00 PHP)
                                "name": "passenger_payment_${firebaseAuth.currentUser!.uid}",
                                "quantity": 1
                              }
                            ],
                            "payment_method_types": ["qrph", "gcash"]
                          }
                        }
                      };

                      try {
                        final http.Response response = await http.post(
                          Uri.parse(url),
                          headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                            'Authorization': basicAuth,
                          },
                          body: jsonEncode(requestBody), // Convert Dart Map to JSON string
                        );

                        if (response.statusCode == 200) {
                          // Successful response
                          final Map<String, dynamic> responseData = jsonDecode(response.body);
                          print('Response Data:');
                          print(jsonEncode(responseData)); // Print the full JSON response

                          // You can also access specific fields:
                          print('Checkout Session ID: ${responseData['data']['id']}');
                          print('Checkout Session URL: ${responseData['data']['attributes']['checkout_url']}');
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PassengerPayment(
                              checkoutURL: responseData['data']['attributes']['checkout_url'].toString(),
                            );
                          }));
                        } else {
                          // Handle error response
                          print('Request failed with status: ${response.statusCode}');
                          print('Response Body: ${response.body}');
                        }
                      } catch (e) {
                        // Handle any network or other errors
                        print('An error occurred: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Payment gateway server has issues. Please proceed to pay in cash."),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                      Future.delayed(const Duration(seconds: 10));
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
                          "available_seats": FieldValue.increment(getOccupiedSeats()),
                        });

                        var paymentReference = firebaseFirestore.collection("payment_information").doc();
                        await paymentReference.set({
                          "payment_id": paymentReference.id,
                          "ride_id": widget.rideInformation.rideId,
                          "payment_method": "cash",
                          "amount_paid": getFare(),
                          "amount_paid_on": DateTime.now(),
                        });

                        var accountReference = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);
                        await accountReference.update({"status": "for_feedback"});

                        var historyReference = firebaseFirestore.collection("ride_history_information").doc();
                        await historyReference.set({
                          "history_id": historyReference.id,
                          "ride_id": widget.rideInformation.rideId,
                          "ride_title": widget.rideInformation.rideTitle,
                          "ride_description": widget.rideInformation.rideDescription,
                          "ride_completed_at": DateTime.now(),
                          "ride_destination": GeoPoint(widget.rideInformation.rideDestination.latitude, widget.rideInformation.rideDestination.longitude),
                          "ride_source_location": GeoPoint(widget.rideInformation.rideSourceLocation.latitude, widget.rideInformation.rideSourceLocation.longitude),
                          "passenger_id": firebaseAuth.currentUser!.uid,
                          "payment_id": paymentReference.id,
                        });

                        var rideInformationReference = firebaseFirestore.collection("ride_information").doc(widget.rideInformation.rideId);

                        if (firebaseAuth.currentUser != null) {
                          widget.rideInformation.passengersList.removeWhere((item) {
                            return item.passengerId == firebaseAuth.currentUser!.uid;
                          });
                        }
                        await rideInformationReference.update({
                          "passengers_list": widget.rideInformation.passengersList,
                        });
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Payment has been completed!"),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      Future.delayed(const Duration(seconds: 4));
                      context.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackStart(rideId: widget.rideInformation.rideId));

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
