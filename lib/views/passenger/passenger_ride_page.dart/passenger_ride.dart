// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/sub_widgets/passenger_ride_confirm_error.dart';
import 'package:tararide_mobile/views/passenger/passenger_ride_page.dart/sub_widgets/passenger_ride_feedback_started.dart';
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
  final Set<Circle> _currentCircles = {};
  LatLng? _currentPos;
  final location_settings.Location _locationController = location_settings.Location();

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

  Future<void> getLocationUpdateByRide(RideInformationModel rideInformation) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var rideInformationReference = FirebaseFirestore.instance.collection("ride_information").doc(rideInformation.rideId);

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

    _locationController.onLocationChanged.listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            _currentPos = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _currentMarkers.add(
              google_maps_marker.Marker(
                markerId: const google_maps_marker.MarkerId("current_location"),
                position: _currentPos!,
                icon: BitmapDescriptor.defaultMarker,
                //icon: bitmapIcon,
                infoWindow: const google_maps_marker.InfoWindow(title: "Current Location"),
              ),
            );
          });

          try {
            if (firebaseAuth.currentUser != null && rideInformation.passengersList.isNotEmpty) {
              int index = 0;
              index = rideInformation.passengersList.indexWhere((item) {
                return item.passengerId == firebaseAuth.currentUser!.uid;
              });

              rideInformation.passengersList[index].passengerCurrentLocation = RideCoordinates(latitude: currentLocation.latitude!, longitude: currentLocation.longitude!);
              List<Map<String, dynamic>> passengerRideUpdateList = [];

              for (int i = 0; i < rideInformation.passengersList.length; i++) {
                //

                print("unit test $i : ${rideInformation.passengersList[i].rideStatus}");
                passengerRideUpdateList.add({
                  "passenger_id": rideInformation.passengersList[i].passengerId,
                  "passenger_email": rideInformation.passengersList[i].passengerEmail,
                  "passenger_current_location": GeoPoint(rideInformation.passengersList[i].passengerCurrentLocation.latitude, rideInformation.passengersList[i].passengerCurrentLocation.longitude),
                  "passenger_source_location": GeoPoint(rideInformation.passengersList[i].passengerSourceLocation.latitude, rideInformation.passengersList[i].passengerSourceLocation.longitude),
                  "passenger_destination": GeoPoint(rideInformation.passengersList[i].passengerDestination.latitude, rideInformation.passengersList[i].passengerDestination.longitude),
                  "estimated_fare": rideInformation.passengersList[i].estimatedFare,
                  "passenger_source_location_name": rideInformation.passengersList[i].passengerSourceLocationName,
                  "passenger_destination_name": rideInformation.passengersList[i].passengerDestinationName,
                  "ride_duration": rideInformation.passengersList[i].rideDuration,
                  "ride_started_at": rideInformation.passengersList[i].rideStartedAt,
                  "ride_distance": rideInformation.passengersList[i].rideDistance,
                  "seats_occupied": rideInformation.passengersList[i].seatsOccupied,
                  "ride_status": rideInformation.passengersList[i].rideStatus,
                  "ride_completed_at": rideInformation.passengersList[i].rideCompletedAt,
                });
              }

              await rideInformationReference.update({
                "passengers_list": passengerRideUpdateList,
              });
            }
          } catch (err) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Error updating location: $err"),
            ));
          }
        }
      }
    });

    return;
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
    return PopScope(
      canPop: false,
      //onPopInvoked: (didPop) => didPop ? null : context.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize()),
      child: Scaffold(
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
              onCameraMove: (cameraPos) {},
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _liveCameraPosition,
              buildingsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _currentMarkers,
              polylines: Set<Polyline>.of(polylines.values),
              //trafficEnabled: true,
              circles: _currentCircles,
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

                                  if (data["status"] == "waiting_for_driver") {
                                    passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideStart(rideId: data["ride_id"].toString()));
                                    // driverRideStatusBlocContext.read<DriverRideStatusBloc>().add(DriverStartRide(rideId: data["ride_id"].toString()));
                                  } else if (data["status"] == "in_a_ride") {
                                    passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideProgress(rideId: data["ride_id"].toString()));
                                  } else if (data["status"] == "for_payment") {
                                    passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRidePaymentStart(rideId: data["ride_id"].toString()));
                                  } else if (data["status"] == "for_feedback") {
                                    passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackStart(rideId: data["ride_id"].toString()));
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

                            case PassengerRideInProgress():
                              //getLocationUpdateByRide(passengerRideStatusState.rideInformation);
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
                            case PassengerRideStarted():
                              //getLocationUpdateByRide(passengerRideStatusState.rideInformation);
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

                              //getLocationUpdates();
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
                            case PassengerRideFeedbackStarted():
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
                                pickupLocationFormattedAddress = pickUpLocation;
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
                              selectedPickUpLocation: _selectedPickupLocation!,
                              onSelectDestination: (destinationLocation) {
                                destinationLocationFormattedAddress = destinationLocation;
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
                              pickupLocationFormattedAddress: pickupLocationFormattedAddress,
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
                            return PassengerSelectingRideWidget(
                              onRideSelected: (selectedCoordinates) {
                                _currentMarkers.removeWhere(
                                  (marker) => marker.markerId.value == "unique_ride_source_location",
                                );
                                _currentMarkers.removeWhere(
                                  (marker) => marker.markerId.value == "unique_ride_destination",
                                );
                                _currentCircles.removeWhere(
                                  (circle) => circle.circleId.value == "unique_ride_desination_circle",
                                );
                                _currentMarkers.add(
                                  google_maps_marker.Marker(
                                    markerId: const google_maps_marker.MarkerId("unique_ride_source_location"),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
                                    position: selectedCoordinates[0],
                                    infoWindow: const google_maps_marker.InfoWindow(title: "Ride Source Location"),
                                    zIndex: 2,
                                  ),
                                );
                                _currentMarkers.add(
                                  google_maps_marker.Marker(
                                    markerId: const google_maps_marker.MarkerId("unique_ride_destination"),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
                                    position: selectedCoordinates[1],
                                    infoWindow: const google_maps_marker.InfoWindow(title: "Ride Destination"),
                                    zIndex: 2,
                                  ),
                                );

                                _currentCircles.add(
                                  Circle(
                                    circleId: const CircleId("unique_ride_desination_circle"),
                                    center: selectedCoordinates[1],
                                    radius: 500,
                                    fillColor: Colors.blue.withOpacity(0.2),
                                    strokeColor: Colors.blue,
                                    strokeWidth: 2,
                                  ),
                                );
                              },
                              onPolylinesGenerated: (Map<PolylineId, Polyline> value) {
                                polylines = value;
                                setState(() {});
                              },
                            );
                          } else if (passengerRideStatusState is PassengerRideStarted) {
                            return PassengerRideStartedWidget(
                              onRideCancelled: (rideStatus) {},
                            );
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
                                        Text("Driver: ${passengerRideStatusState.rideInformation.driverName}"),
                                        Text("Destination: ${passengerRideStatusState.rideInformation.rideTitle}"),
                                        Text("ETA: ${Random().nextInt(20) + 7} mins"),
                                        const Expanded(child: SizedBox()),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 40,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  try {
                                                    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                                    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                                                    var accountInstance = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);
                                                    accountInstance.update({
                                                      "status": "for_payment",
                                                      "ride_id": passengerRideStatusState.rideInformation.rideId,
                                                    });

                                                    var rideInformationReference = firebaseFirestore.collection("ride_information").doc(passengerRideStatusState.rideInformation.rideId);

                                                    var index = passengerRideStatusState.rideInformation.passengersList.indexWhere((item) {
                                                      return item.passengerId == firebaseAuth.currentUser!.uid;
                                                    });

                                                    // passengerRideStatusState.rideInformation.passengersList[index].rideStatus = "completed";
                                                    // List<Map<String, dynamic>> updatedPassengersList = [];
                                                    // for (var item in passengerRideStatusState.rideInformation.passengersList) {
                                                    //   updatedPassengersList.add(
                                                    //     {
                                                    //       "estimated_fare": item.estimatedFare,
                                                    //       "passenger_current_location": GeoPoint(item.passengerCurrentLocation.latitude, item.passengerCurrentLocation.longitude),
                                                    //       "passenger_destination": GeoPoint(item.passengerDestination.latitude, item.passengerDestination.longitude),
                                                    //       "passenger_destination_name": item.passengerDestinationName,
                                                    //       "passenger_email": item.passengerEmail,
                                                    //       "passenger_id": item.passengerId,
                                                    //       "passenger_source_location_name": item.passengerSourceLocationName,
                                                    //       "passenger_source_location": GeoPoint(item.passengerSourceLocation.latitude, item.passengerSourceLocation.longitude),
                                                    //       "ride_duration": item.rideDuration,
                                                    //       "ride_started_at": item.rideStartedAt,
                                                    //       "ride_distance": item.rideDistance,
                                                    //       "seats_occupied": item.seatsOccupied,
                                                    //       "ride_status": item.rideStatus,
                                                    //       "ride_completed_at": item.rideCompletedAt,
                                                    //     },
                                                    //   );
                                                    // }
                                                    // print("Updated Passengers List: ${passengerRideStatusState.rideInformation.passengersList[0].toJson().toString()}");
                                                    // await rideInformationReference.update({
                                                    //   "passengers_list": updatedPassengersList,
                                                    // });
                                                  } catch (e) {
                                                    print("Error: $e");
                                                  }
                                                  passengerRideStatusContext.read<PassengerRideStatusBloc>().add(
                                                        PassengerRidePaymentStart(rideId: passengerRideStatusState.rideInformation.rideId),
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
                            return const PassengerRideFeedbackStartedWidget();
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
      )),
    );
  }

  Future<void> _updateCameraView(LatLng coordinatesValue) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: coordinatesValue, zoom: 18.0)));
  }
}
