import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

class PassengerRide extends StatefulWidget {
  const PassengerRide({super.key});

  @override
  State<StatefulWidget> createState() => PassengerRideState();
}

class PassengerRideState extends State<PassengerRide> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(bearing: 192.8334901395799, target: LatLng(37.43296265331129, -122.08832357078792), tilt: 59.440717697143555, zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PassengerRideStatusBloc()..add(PassengerRideStatusInitialize()),
        )
      ],
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: BlocConsumer<PassengerRideStatusBloc, PassengerRideStatusState>(
                listener: (passengerRideStatusContext, passengerRideStatusState) {},
                builder: (passengerRideStatusContext, passengerRideStatusState) {
                  if (passengerRideStatusState is PassengerRideStatusInitial) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("Ride now"),
                      ),
                    );
                  } else if (passengerRideStatusState is PassengerSelectingPickupLocation) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("Select your pick up location"),
                      ),
                    );
                  } else if (passengerRideStatusState is PassengerSelectingDestination) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("Select Destination"),
                      ),
                    );
                  } else if (passengerRideStatusState is PassengerSelectingRide) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("Select Available Driver"),
                      ),
                    );
                  } else if (passengerRideStatusState is PassengerRideStarted) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("Riding"),
                      ),
                    );
                  } else if (passengerRideStatusState is PassengerRidePaymentStarted) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("Payment Starts here"),
                      ),
                    );
                  } else if (passengerRideStatusState is PassengerRideFeedbackStarted) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("Feedback Start Here"),
                      ),
                    );
                  } else if (passengerRideStatusState is PassengerRideFeedbackCompleted) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text("FeedbackCompleted"),
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                    );
                  }
                },
              )),
        ],
      ),
    ));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
