// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

import 'package:tararide_mobile/repository/gcp_weather_api_repository.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/sub_widgets/passenger_ride_confirm_error.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/sub_widgets/passenger_ride_payment_started.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/sub_widgets/passenger_ride_started.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/sub_widgets/passenger_selecting_pickup_location.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/sub_widgets/passenger_selecting_ride.dart';
import 'package:location/location.dart' as location_settings;
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:geocoding_platform_interface/src/models/location.dart' as geocoding_location;
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart' as google_maps_marker;
import 'sub_widgets/passenger_ride_confirm_details.dart';
import 'sub_widgets/passenger_ride_confirm_loading.dart';
import 'sub_widgets/passenger_ride_load_weather_data.dart';
import 'sub_widgets/passenger_selecting_destination.dart';

import 'dart:ui' as dart_ui;

class PassengerRide extends StatefulWidget {
  const PassengerRide({super.key});

  @override
  State<StatefulWidget> createState() => PassengerRideState();
}

class PassengerRideState extends State<PassengerRide> {
  // for handling google maps
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  final Set<google_maps_marker.Marker> _currentMarkers = {};
  LatLng? _currentPos = null;
  location_settings.Location _locationController = location_settings.Location();

  static const CameraPosition _liveCameraPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(14.410864386525509, 121.0380144417286),
    tilt: 0,
    zoom: 19.151926040649414,
  );

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  // for UI Changes
  bool hideContainer = false;
  double currentStateContainerHeight = 180;
  double heightAdjustment = 180;

// for selecting pickup location
  int _pickupItemSelectedIndex = -1;
  final TextEditingController _pickupSearchBarController = TextEditingController();
  String pickupLocationFormattedAddress = "";
  LatLng? _selectedPickupLocation;
  List<geocoding_location.Location> possiblePickupLocations = [
    geocoding_location.Location(
      latitude: 14.383,
      longitude: 120.9773,
      timestamp: DateTime.now(),
    ),
  ];
// for selecting destination location

  int _destinationItemSelectedIndex = -1;
  final TextEditingController _destinationSearchBarController = TextEditingController();
  String destinationLocationFormattedAddress = "";
  LatLng? _selectedDestinationLocation;

  // for ride confirmation
  String _selectedSeatsToOccupy = '1';

// for feedback
  double feedback_rating = 0;
  final TextEditingController _feedbackCommentController = TextEditingController();

  Future<LatLng> getLocationUpdateByRide(String rideId) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(const ImageConfiguration(size: dart_ui.Size(90, 90)), "assets/passenger_icon.png");
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return LatLng(0, 0);
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return LatLng(0, 0);
      }
    }

    // _locationController.onLocationChanged.listen()

    return LatLng(0, 0);
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(const ImageConfiguration(size: dart_ui.Size(90, 90)), "assets/passenger_current_location.png");
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            _currentPos = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _currentMarkers.add(
              google_maps_marker.Marker(
                markerId: const google_maps_marker.MarkerId("current_location"),
                position: _currentPos!,
                icon: bitmapIcon,
                infoWindow: const google_maps_marker.InfoWindow(title: "Current Location"),
              ),
            );
          });
        }
      }
    });
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoords) {
    PolylineId polylineId = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: polylineId,
      color: const Color.fromARGB(255, 0, 160, 77),
      points: polylineCoords,
      width: 9,
    );
    setState(() {
      polylines[polylineId] = polyline;
    });
  }

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
            onCameraMove: (cameraPos) {
              print("HOPYA");
              print(cameraPos.target);
            },
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _liveCameraPosition,
            buildingsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _currentMarkers,
            polylines: Set<Polyline>.of(polylines.values),
            //trafficEnabled: true,

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(
                          () {
                            hideContainer = !hideContainer;
                            if (hideContainer) {
                              currentStateContainerHeight = 0;
                            } else {
                              currentStateContainerHeight = heightAdjustment;
                            }
                          },
                        );
                      },
                      child: Text(hideContainer == false ? "Hide" : "Show"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOutCirc,
                    width: double.infinity,
                    height: currentStateContainerHeight,
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
                    child: BlocConsumer<PassengerRideStatusBloc, PassengerRideStatusState>(
                      listener: (passengerRideStatusContext, passengerRideStatusState) async {
                        double? newHeight; // Use nullable double to indicate if height needs change

                        // Determine the target height based on the state
                        switch (passengerRideStatusState) {
                          case PassengerRideStatusInitial():
                            setState(() {
                              currentStateContainerHeight = 180;
                            });
                            // await Future.delayed(const Duration(seconds: 1));

                            FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                            FirebaseAuth firebaseAuth = FirebaseAuth.instance;

                            if (firebaseAuth.currentUser != null) {
                              var accountInstance = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);
                              var documentInstance = await accountInstance.get();

                              if (documentInstance.data() != null || documentInstance.exists) {
                                var data = documentInstance.data()!;

                                if (data["status"] == "in_a_ride") {
                                  passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideStart(rideId: data["ride_id"].toString()));
                                  // driverRideStatusBlocContext.read<DriverRideStatusBloc>().add(DriverStartRide(rideId: data["ride_id"].toString()));
                                } else {
                                  passengerRideStatusContext.read<PassengerRideStatusBloc>().add(const PassengerRideStatusLoadWeatherData());
                                }
                              } else {
                                passengerRideStatusContext.read<PassengerRideStatusBloc>().add(const PassengerRideStatusLoadWeatherData());
                              }
                            } else {
                              passengerRideStatusContext.read<PassengerRideStatusBloc>().add(const PassengerRideStatusLoadWeatherData());
                            }

                            break;
                          case PassengerRideStarted():
                            newHeight = 220;
                            polylines = passengerRideStatusState.generatedPolylines;
                            _currentMarkers.removeWhere(
                              (marker) => marker.markerId.value == "pickup_location",
                            );
                            _currentMarkers.removeWhere(
                              (marker) => marker.markerId.value == "destination",
                            );
                            double sourceLatitude = passengerRideStatusState.rideInformation.rideSourceLocation.latitude;
                            double sourceLongitude = passengerRideStatusState.rideInformation.rideSourceLocation.longitude;
                            double destinationLatitude = passengerRideStatusState.rideInformation.rideDestination.latitude;
                            double destinationLongitude = passengerRideStatusState.rideInformation.rideDestination.longitude;
                            double rideCurrentLocLatitude = passengerRideStatusState.rideInformation.driverCurrentLocation.latitude;
                            double rideCurrentLocLongitude = passengerRideStatusState.rideInformation.driverCurrentLocation.longitude;
                            print("VELLA ${rideCurrentLocLatitude} :  ${rideCurrentLocLongitude}");
                            _currentMarkers.add(
                              google_maps_marker.Marker(
                                markerId: const google_maps_marker.MarkerId("pickup_location"),
                                icon: await BitmapDescriptor.asset(const ImageConfiguration(size: dart_ui.Size(90, 90)), "assets/general_start_icon.png"),
                                position: LatLng(
                                  sourceLatitude,
                                  sourceLongitude,
                                ),
                              ),
                            );
                            _currentMarkers.add(
                              google_maps_marker.Marker(
                                markerId: const google_maps_marker.MarkerId("destination"),
                                icon: await BitmapDescriptor.asset(const ImageConfiguration(size: dart_ui.Size(90, 90)), "assets/general_destination_icon.png"),
                                position: LatLng(
                                  destinationLatitude,
                                  destinationLongitude,
                                ),
                              ),
                            );
                            _currentMarkers.add(
                              google_maps_marker.Marker(
                                markerId: const google_maps_marker.MarkerId("ride_current_location"),
                                icon: await BitmapDescriptor.asset(const ImageConfiguration(size: dart_ui.Size(40, 40)), "assets/driver_car_icon.png"),
                                position: LatLng(
                                  rideCurrentLocLatitude,
                                  rideCurrentLocLongitude,
                                ),
                              ),
                            );
                            break;
                          case PassengerRideFeedbackCompleted():
                            newHeight = 180;
                            break;
                          case PassengerSelectingPickupLocation():
                            print("HOPALAISTIAL: ${passengerRideStatusState.possiblePickupLocations.length}");
                            newHeight = 280;
                            _pickupItemSelectedIndex = -1;
                            break;

                          case PassengerSelectingDestination():
                            newHeight = 280;
                            _destinationItemSelectedIndex = -1;
                            break;

                          case PassengerRidePolylinesLoaded():
                            polylines = passengerRideStatusState.generatedPolylines;
                            setState(() {});
                            break;
                          case PassengerSelectingRide():
                            polylines = {};

                            getLocationUpdates();
                            if (passengerRideStatusState.rideInformationList.isEmpty) {
                              newHeight = 180;
                            } else {
                              newHeight = 400;
                            }

                            // passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerSelectRide(
                            //       pickupLocation: passengerRideStatusState.pickupLocation,
                            //       estimatedTime: passengerRideStatusState.estimatedTime,
                            //       rideDistance: passengerRideStatusState.rideDistance,
                            //       slotsToOccupy: passengerRideStatusState.slotsToOccupy,
                            //       destinationLocation: passengerRideStatusState.destinationLocation,
                            //       pickupLocationFormattedAddress: passengerRideStatusState.pickupLocationFormattedAddress,
                            //       destinationFormattedAddress: passengerRideStatusState.destinationFormattedAddress,
                            //     ));

                            break;
                          case PassengerRideConfirmDetails():
                            newHeight = 480;
                            break;

                          case PassengerRidePaymentStarted():
                            newHeight = 520;
                            break;

                          case PassengerRideStatusWeatherDataLoaded():
                            newHeight = 180;
                            break;

                          default:
                            // No height change for this state
                            break;
                        }

                        // Only call setState if a new height was determined AND it's different
                        if (newHeight != null && newHeight != currentStateContainerHeight) {
                          setState(() {
                            currentStateContainerHeight = newHeight!;
                            heightAdjustment = currentStateContainerHeight; // Assuming this always mirrors currentStateContainerHeight
                          });
                        }

                        // Handle specific actions/side effects for individual states
                        if (passengerRideStatusState is PassengerSelectingPickupLocation) {
                          print("HOPYA MANIPAPCARN ${passengerRideStatusState.possiblePickupLocations!.length}");
                        } else if (passengerRideStatusState is PassengerRideConfirmDetails) {
                          // Assuming 'polylines' is a mutable field in your StatefulWidget's State class
                          polylines = passengerRideStatusState.polylines;
                        } else if (passengerRideStatusState is PassengerRideFeedbackCompleted) {
                          // Dispatch event after a delay for the feedback completed state
                          Future.delayed(const Duration(seconds: 2), () {
                            passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize());
                          });
                        }

                        // Always log the height adjustment after potential setState
                        print("Height Adjustment: $heightAdjustment");
                      },
                      builder: (passengerRideStatusContext, passengerRideStatusState) {
                        if (passengerRideStatusState is PassengerRideStatusInitial) {
                          return const SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Text("Please wait while we load..."),
                            ),
                          );
                        } else if (passengerRideStatusState is PassengerRideStatusWeatherDataLoaded) {
                          return PassengerRideLoadWeatherDataWidget(
                            weatherData: passengerRideStatusState,
                          );
                        } else if (passengerRideStatusState is PassengerSelectingPickupLocation) {
                          return PassengerSelectingPickupLocationWidget(
                            onSelectPickupLocation: (pickUpLocation) {
                              pickupLocationFormattedAddress = pickUpLocation.formattedAddress;
                            },
                            onSelectPickupCoordinates: (pickUpCoordinates) {
                              _selectedPickupLocation = LatLng(
                                pickUpCoordinates.latitude,
                                pickUpCoordinates.longitude,
                              );

                              _updateCameraView(LatLng(
                                pickUpCoordinates.latitude,
                                pickUpCoordinates.longitude,
                              ));
                            },
                            onSelectPickupMarker: (pickUpMarker) {
                              _currentMarkers.removeWhere(
                                (marker) => marker.markerId.value == "pickup_location",
                              );
                              _currentMarkers.add(pickUpMarker);
                              setState(() {});
                            },
                          );
                        } else if (passengerRideStatusState is PassengerSelectingDestination) {
                          return PassengerSelectingDestinationWidget(
                            onSelectDestination: (destinationLocation) {
                              destinationLocationFormattedAddress = destinationLocation.formattedAddress;
                            },
                            onSelectDestinationCoordinates: (destinationCoordinates) {
                              _selectedDestinationLocation = LatLng(
                                destinationCoordinates.latitude,
                                destinationCoordinates.longitude,
                              );

                              _updateCameraView(LatLng(
                                destinationCoordinates.latitude,
                                destinationCoordinates.longitude,
                              ));
                            },
                            onSelectDestinationMarker: (destinationMarker) {
                              _currentMarkers.removeWhere(
                                (marker) => marker.markerId.value == "destination",
                              );
                              _currentMarkers.add(destinationMarker);
                              setState(() {});
                            },
                            selectedPickUpLocation: _selectedPickupLocation!,
                          );
                        } else if (passengerRideStatusState is PassengerRideConfirmLoading) {
                          return const PassengerRideConfirmLoadingWidget();
                        } else if (passengerRideStatusState is PassengerRidePolylinesLoaded) {
                          return const PassengerRideConfirmLoadingWidget();
                        } else if (passengerRideStatusState is PassengerRideConfirmError) {
                          return PassengerRideConfirmErrorWidget(
                            errorMessage: passengerRideStatusState.errorMessage,
                          );
                        } else if (passengerRideStatusState is PassengerRideConfirmDetails) {
                          return PassengerRideConfirmDetailsWidget(
                            pickupLocationFormattedAddress: pickupLocationFormattedAddress,
                            destinationFormattedAddress: destinationLocationFormattedAddress,
                          );
                        } else if (passengerRideStatusState is PassengerRideConfirmation) {
                          return Container();
                        } else if (passengerRideStatusState is PassengerSelectingRide) {
                          return const PassengerSelectingRideWidget();
                        } else if (passengerRideStatusState is PassengerRideStarted) {
                          return PassengerRideStartedWidget();
                        } else if (passengerRideStatusState is PassengerRideInProgress) {
                          return SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Row(
                              children: [
                                Lottie.asset(
                                  'assets/pickup_inprogress.json',
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
                                      const Text("We are on the way", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text("Driver: John Doe"),
                                      const Text("Destination: SM Mall"),
                                      const Text("ETA: 10 mins"),
                                      const Expanded(child: SizedBox()),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                passengerRideStatusContext.read<PassengerRideStatusBloc>().add(
                                                      PassengerRidePaymentStart(rideInformation: passengerRideStatusState.rideInformation),
                                                    );
                                              },
                                              child: const Text("Drop Off Now")),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          );
                        } else if (passengerRideStatusState is PassengerRidePaymentStarted) {
                          return PassengerRidePaymentStartedWidget(
                            rideInformation: passengerRideStatusState.rideInformation,
                          );
                        } else if (passengerRideStatusState is PassengerRideFeedbackStarted) {
                          return SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  child: Text(
                                    "Rate your driver",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  child: Container(
                                    height: 140,
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
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: Image.asset("assets/profilepicture_driver_sample.jpg").image,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      color: Colors.white,
                                                      borderRadius: const BorderRadius.all(
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
                                                          "Car: Toyota Vios",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Plate Number: ABC1234",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.normal,
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: Text(
                                    "How was your ride?",
                                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: AnimatedRatingStars(
                                    onChanged: (rating) {
                                      feedback_rating = rating;
                                      setState(() {});
                                    },
                                    customFilledIcon: Icons.star,
                                    customHalfFilledIcon: Icons.star_half,
                                    customEmptyIcon: Icons.star_border,
                                    starSize: 30,
                                    animationDuration: const Duration(milliseconds: 50),
                                    animationCurve: Curves.easeInOutCirc,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Leave a comment",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: TextField(
                                        controller: _feedbackCommentController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Please type your comment here",
                                          hintStyle: TextStyle(fontSize: 12),
                                        ),
                                        maxLines: 9,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackComplete());
                                          },
                                          child: const Text(
                                            "Submit Feedback",
                                          ))),
                                ),
                              ],
                            ),
                          );
                        } else if (passengerRideStatusState is PassengerRideFeedbackCompleted) {
                          return const SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Text("Thank you for your feedback!"),
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
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Future<void> _updateCameraView(LatLng coordinatesValue) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: coordinatesValue, zoom: 18.0)));
  }
}
