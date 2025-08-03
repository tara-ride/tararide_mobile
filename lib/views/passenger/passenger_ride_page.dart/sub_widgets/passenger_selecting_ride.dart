import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';
import 'package:tararide_mobile/config/firebase_options.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/repository/gcp_distance_matrix_repository.dart';
import 'package:flutter_polyline_points/src/utils/polyline_result.dart';

class PassengerSelectingRideWidget extends StatefulWidget {
  PassengerSelectingRideWidget({
    super.key,
    required this.onRideSelected,
    required this.onPolylinesGenerated,
  });
  ValueChanged<List<LatLng>> onRideSelected;
  ValueChanged<Map<PolylineId, Polyline>> onPolylinesGenerated;
  @override
  State<PassengerSelectingRideWidget> createState() => _PassengerSelectingRideWidgetState();
}

class _PassengerSelectingRideWidgetState extends State<PassengerSelectingRideWidget> {
  String selectedSeatsToOccupy = '1';
  double estimatedFare = 200.80;
  int selectedRideIndex = 0;

  Future<double> getDistanceMatrix(LatLng sourceLocation, LatLng destination) async {
    GcpDistanceMatrixRepositoryImplementation gcpDistanceMatrixRepositoryImplementation = GcpDistanceMatrixRepositoryImplementation();

    var distanceMatrixData = await gcpDistanceMatrixRepositoryImplementation.getDistanceMatrixDataOnce(SystemConstants().getGoogleCloudAPIKey, sourceLocation, destination);

    return distanceMatrixData.rows[0].elements[0].distance.value.toDouble() * 0.001;
  }

  double calculateDistance(double overallRideDistance, double passengerRideDistance) {
    return passengerRideDistance / overallRideDistance;
  }

  Future<double> calculateEstimatedFare(LatLng rideSource, LatLng rideDestination, double requiredDistance, int seatsOccupied, double flagDownRate, double overallRideCost) async {
    double overallRideDistance = await getDistanceMatrix(rideSource, rideDestination);

    //Passenger Fare = Flagdown Rate + [(Passenger Distance ÷ Total Distance) × (Total Ride Cost - Flagdown Rate)]
    //
    return (flagDownRate + (requiredDistance / overallRideDistance) * (overallRideCost - flagDownRate)) * seatsOccupied.toDouble();
    // (passengerRideStatusState.rideInformationList[selectedRideIndex].rideCost + 15) * passengerRideStatusState.slotsToOccupy
  }

  @override
  Widget build(BuildContext buildContext) {
    final passengerRideStatusState = buildContext.watch<PassengerRideStatusBloc>().state as PassengerSelectingRide;
    List<RideInformationModel> filteredRideInformationList = passengerRideStatusState.rideInformationList.where((ride) => ride.availableSeats > 0).toList().where((ride) => ride.status == "active").toList().where((ride) {
      print("Ride Check: ${ride.rideId}");
      print("P Check: ${passengerRideStatusState.destinationLocation.latitude}");
      print("R Check: ${ride.rideDestination.latitude}");

      return (ride.rideDestination.longitude - passengerRideStatusState.destinationLocation.longitude).abs() <= 0.03 && (ride.rideDestination.latitude - passengerRideStatusState.destinationLocation.latitude).abs() <= 0.03;
    }).toList();

    double calculatedEstimatedFare = 0;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Text(
                "Select Ride",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: filteredRideInformationList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/pickup_inprogress.json",
                          width: 200,
                          height: 200,
                        ),
                        const Text(
                          "Waiting for rides...",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: filteredRideInformationList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: GestureDetector(
                            onTap: () async {
                              try {
                                List<LatLng> polylineCoordinates = [];
                                Map<PolylineId, Polyline> generatedPolylines = {};

                                PolylineResult polylineResult = await PolylinePoints().getRouteBetweenCoordinates(
                                  SystemConstants().getGoogleCloudAPIKey,
                                  PointLatLng(filteredRideInformationList[index].rideSourceLocation.latitude, filteredRideInformationList[index].rideSourceLocation.longitude),
                                  PointLatLng(filteredRideInformationList[index].rideDestination.latitude, filteredRideInformationList[index].rideDestination.longitude),
                                  travelMode: TravelMode.driving,
                                );
                                if (polylineResult.points.isNotEmpty) {
                                  polylineResult.points.forEach((PointLatLng point) {
                                    polylineCoordinates.add(LatLng(point.latitude, point.longitude));
                                  });
                                  generatedPolylines[PolylineId("polyline_${generatedPolylines.length}")] = Polyline(
                                    polylineId: PolylineId("polyline_${generatedPolylines.length}"),
                                    color: const Color.fromARGB(255, 0, 143, 226),
                                    width: 5,
                                    points: polylineCoordinates,
                                  );

                                  widget.onPolylinesGenerated(generatedPolylines);
                                } else {
                                  throw Exception("No points found in polyline result");
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error generating polylines: $e")),
                                );
                              }
                              setState(() {
                                selectedRideIndex = index;
                              });
                              widget.onRideSelected([
                                LatLng(filteredRideInformationList[index].rideSourceLocation.latitude, filteredRideInformationList[index].rideSourceLocation.longitude),
                                LatLng(filteredRideInformationList[index].rideDestination.latitude, filteredRideInformationList[index].rideDestination.longitude),
                              ]);
                            },
                            child: AnimatedContainer(
                              height: selectedRideIndex == index ? 90 : 60,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(7),
                                ),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 3,
                                    offset: Offset.zero,
                                  ),
                                ],
                                color: selectedRideIndex == index ? const Color.fromARGB(255, 228, 216, 255) : const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 13),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 14),
                                          child: Icon(Icons.location_city_outlined),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          filteredRideInformationList[index].rideTitle,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Available seats: ${filteredRideInformationList[index].availableSeats}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        selectedRideIndex == index
                                            ? Text(
                                                "Description: ${filteredRideInformationList[index].rideDescription}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          filteredRideInformationList.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: calculateEstimatedFare(
                              LatLng(filteredRideInformationList[selectedRideIndex].rideSourceLocation.latitude, filteredRideInformationList[selectedRideIndex].rideSourceLocation.longitude),
                              LatLng(filteredRideInformationList[selectedRideIndex].rideDestination.latitude, filteredRideInformationList[selectedRideIndex].rideDestination.longitude),
                              passengerRideStatusState.rideDistance * 0.001,
                              passengerRideStatusState.slotsToOccupy,
                              30,
                              filteredRideInformationList[selectedRideIndex].rideCost),
                          builder: (futureBuildContext, snapshot) {
                            if (snapshot.hasData) {
                              calculatedEstimatedFare = snapshot.data!;
                              return Padding(
                                padding: const EdgeInsets.only(left: 8, right: 4, bottom: 5),
                                child: Text("Estimated Fare: ₱${snapshot.data!.toStringAsFixed(2)}"),
                              );
                            }
                            return SizedBox.shrink();
                          }),
                      const Spacer(),
                    ],
                  ),
                ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 4, bottom: 5),
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                        onPressed: () {
                          buildContext.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize());
                        },
                        child: const Text("Cancel")),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8, bottom: 5),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (selectedRideIndex == -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select a ride first.")),
                              );
                              return;
                            }

                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? user = auth.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("User not authenticated.")),
                              );
                              return;
                            }
                            try {
                              FirebaseFirestore firestore = FirebaseFirestore.instance;

                              FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                              if (firebaseAuth.currentUser != null) {
                                await firestore.collection('account_information').doc(firebaseAuth.currentUser!.uid).update({
                                  "ride_id": filteredRideInformationList[selectedRideIndex].rideId,
                                  "status": "waiting_for_driver",
                                });
                                await firestore.collection('ride_information').doc(filteredRideInformationList[selectedRideIndex].rideId).update({
                                  'passengers_list': FieldValue.arrayUnion([
                                    {
                                      'passenger_id': user.uid,
                                      'passenger_email': user.email ?? '',
                                      'status': "waiting",
                                      'passenger_current_location': GeoPoint(
                                        passengerRideStatusState.pickupLocation.latitude,
                                        passengerRideStatusState.pickupLocation.longitude,
                                      ),
                                      'passenger_source_location': GeoPoint(
                                        passengerRideStatusState.pickupLocation.latitude,
                                        passengerRideStatusState.pickupLocation.longitude,
                                      ),
                                      'passenger_destination': GeoPoint(
                                        passengerRideStatusState.destinationLocation.latitude,
                                        passengerRideStatusState.destinationLocation.longitude,
                                      ),
                                      'estimated_fare': calculatedEstimatedFare,
                                      'passenger_source_location_name': passengerRideStatusState.pickupLocationFormattedAddress,
                                      'passenger_destination_name': passengerRideStatusState.destinationFormattedAddress,
                                      'ride_distance': passengerRideStatusState.rideDistance,
                                      'ride_duration': passengerRideStatusState.estimatedTime,
                                      'ride_started_at': Timestamp.now(),
                                      'ride_status': 'waiting',
                                      'seats_occupied': passengerRideStatusState.slotsToOccupy,
                                      'ride_completed_at': Timestamp.fromDate(DateTime(9999, 12, 31)), // Placeholder for future completion
                                    }
                                  ]),
                                  'available_seats': filteredRideInformationList[selectedRideIndex].availableSeats - passengerRideStatusState.slotsToOccupy,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Ride information updated successfully.")),
                                );
                                if (mounted) {
                                  context.read<PassengerRideStatusBloc>().add(PassengerRideStart(rideId: filteredRideInformationList[selectedRideIndex].rideId));
                                  context.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize());
                                }
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error updating ride informations: $e")),
                              );
                              return;
                            }

                            // context.read<PassengerRideStatusBloc>().add(PassengerRideStart());
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error starting ride: $e")),
                            );
                          }
                        },
                        child: const Text("Choose Ride")),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
