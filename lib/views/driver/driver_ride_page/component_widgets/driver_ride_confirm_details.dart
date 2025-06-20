import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tararide_mobile/bloc/driver_ride_status/driver_ride_status_bloc.dart';

class DriverRideConfirmDetailsWidget extends StatefulWidget {
  final String rideTitle;
  final String rideDescription;
  final ValueChanged<Map<String, dynamic>> onCarpoolDetailsProcessed;
  const DriverRideConfirmDetailsWidget({super.key, required this.rideTitle, required this.rideDescription, required this.onCarpoolDetailsProcessed});

  @override
  State<StatefulWidget> createState() => _DriverRideConfirmDetailsState();
}

class _DriverRideConfirmDetailsState extends State<DriverRideConfirmDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    //final passengerRideStatusState = context.watch<PassengerRideStatusBloc>().state as PassengerRideConfirmDetails;
    final driverRideStatusState = context.watch<DriverRideStatusBloc>().state as DriverRideConfirmDetails;
    print("Distance Value: ${driverRideStatusState.distance.value}");
    print("Duration Value: ${driverRideStatusState.duration.value}");
    print("Distance Cost: ${(driverRideStatusState.distance.value * 0.001) * 24.81}");
    double estimatedFare = (driverRideStatusState.distance.value * 0.001) * 24.81;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              "Carpool Ride Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 2.5,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Ride Title",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(3)), boxShadow: <BoxShadow>[
                        BoxShadow(color: Colors.black, blurRadius: 0.5, spreadRadius: 0.5),
                      ]),
                      child: Center(
                        child: Text(widget.rideTitle),
                      ),
                    ),
                  ),
                  const Text(
                    "Ride Description",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(3)), boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.black, blurRadius: 0.5, spreadRadius: 0.5),
                        ]),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Center(
                            child: Text(
                              widget.rideDescription,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Estimated Time of Arrival: ${driverRideStatusState.duration.text}"),
                  Text("Distance: ${driverRideStatusState.distance.text}"),
                  Text("Estimated Ride Cost: ₱ ${estimatedFare.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  bool _processCompleted = false;
                  Map<PolylineId, Polyline> polylines = driverRideStatusState.polylines;
                  String ride_id = "";
                  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                  try {
                    var documentInstance = firebaseFirestore.collection("ride_information").doc();
                    ride_id = documentInstance.id;

                    if (firebaseAuth.currentUser != null) {
                      var personalInformationInstance = firebaseFirestore.collection("personal_information").doc(firebaseAuth.currentUser!.uid);

                      var personalInformationDocument = await personalInformationInstance.get();

                      if (personalInformationDocument.data() != null || personalInformationDocument.exists) {
                        var personalInfo = personalInformationDocument.data();

                        await documentInstance.set({
                          "ride_title": widget.rideTitle,
                          "ride_description": widget.rideDescription,
                          "available_seats": 4,
                          "car_type": "sedan",
                          "driver_email": firebaseAuth.currentUser!.email,
                          "driver_id": firebaseAuth.currentUser!.uid,
                          "driver_name": "${personalInfo!["first_name"]} ${personalInfo["last_name"]}",
                          "passengers_list": [],
                          "driver_current_location": GeoPoint(driverRideStatusState.startCoordinates.latitude, driverRideStatusState.startCoordinates.longitude),
                          "ride_destination": GeoPoint(driverRideStatusState.destinationCoordinates.latitude, driverRideStatusState.destinationCoordinates.longitude),
                          "ride_id": documentInstance.id,
                          "ride_source_location": GeoPoint(driverRideStatusState.startCoordinates.latitude, driverRideStatusState.startCoordinates.longitude),
                          "ride_type": "single_trip",
                          "seats_allocated": 4,
                          "status": "active",
                          "ride_earnings": 0,
                          "ride_cost": estimatedFare,
                          "ride_posted_date": DateTime.now(),
                          "ride_end_date": DateTime(9999, 12, 31, 0),
                        }).then((onValue) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your ride details has been posted! Passengers will see your post. So be ready!")));
                          _processCompleted = true;
                        });
                      }
                    }
                    if (_processCompleted) {
                      if (firebaseAuth.currentUser != null) {
                        var accountInstance = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);

                        await accountInstance.update({
                          "status": "in_a_ride",
                          "ride_id": ride_id,
                        }).then((onValue) {
                          print("UPDATED STATUS INTO: IN_A_RIDE");
                          widget.onCarpoolDetailsProcessed({
                            "polylines": polylines,
                            "distanceMatrix": "",
                            "durationMatrix": "",
                            "startLocationFormattedAddress": "",
                            "destinationFormattedAddress": "",
                            "startCoordinates": "",
                            "destinationCoordinates": "",
                            "distance": "",
                            "duration": "",
                          });
                          context.read<DriverRideStatusBloc>().add(DriverStartRide(rideId: ride_id));
                        });
                      } else {
                        context.read<DriverRideStatusBloc>().add(DriverRideStatusError(errorMessage: "Cannot find user context. Please contact administrator"));
                      }
                    }
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$err")));
                    context.read<DriverRideStatusBloc>().add(DriverRideStatusError(errorMessage: err.toString()));
                  }
                },
                child: const Text("Confirm and Post")),
          ),
        ),
      ],
    );
  }
}
