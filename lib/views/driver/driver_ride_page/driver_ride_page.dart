// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, implementation_imports

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_settings;
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart' as google_maps_marker;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/views/driver/driver_ride_page/component_widgets/driver_load_weather_data.dart';
import 'package:tararide_mobile/views/driver/driver_ride_page/component_widgets/driver_post_ride_form_displayed.dart';
import 'package:tararide_mobile/views/driver/driver_ride_page/component_widgets/driver_ride_confirm_details.dart';
import 'package:tararide_mobile/views/driver/driver_ride_page/component_widgets/driver_ride_started.dart';
import 'package:tararide_mobile/views/driver/driver_ride_page/component_widgets/driver_selecting_start_location.dart';

import '../../../bloc/driver_ride_status/driver_ride_status_bloc.dart';
import 'component_widgets/driver_ride_confirm_loading_widget.dart';
import 'component_widgets/driver_selecting_destination.dart';

class DriverRidePage extends StatefulWidget {
  // This class is currently empty, but it can be used to manage the driver's ride page.
  // You can add properties and methods as needed to handle the driver's ride information.
  const DriverRidePage({super.key});
  @override
  State<StatefulWidget> createState() => _DriverRidePageState();
}

class _DriverRidePageState extends State<DriverRidePage> {
  // for handling google maps
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  final Set<google_maps_marker.Marker> _currentMarkers = {};
  LatLng? _currentPos;
  final location_settings.Location _locationController = location_settings.Location();
  location_settings.LocationData? _currentLocation;
  LatLng? _selectedStartLocation;
  String startLocationFormattedAddress = "";
  String destinationLocationFormattedAddress = "";
  LatLng? _selectedDestinationLocation;

  String _rideTitle = "";
  String _rideDescription = "";

  static const CameraPosition _liveCameraPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(14.410864386525509, 121.0380144417286),
    tilt: 0,
    zoom: 19.151926040649414,
  );

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Map<String, dynamic> mapSettings = {};
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

  Future<void> _updateCameraView(LatLng coordinatesValue) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: coordinatesValue, zoom: 18.0)));
  }

  Future<void> getLocationUpdates(String rideId) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(const ImageConfiguration(size: Size(90, 90)), "assets/driver_car_icon.png");
    serviceEnabled = await _locationController.serviceEnabled();

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var rideInfoDocument = firebaseFirestore.collection("ride_information").doc(rideId);

    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        if (mounted) {
          print("Driver Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}");
          await rideInfoDocument.update({
            "driver_current_location": GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
          });
          setState(() {
            _currentPos = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _currentMarkers.add(
              google_maps_marker.Marker(
                markerId: const google_maps_marker.MarkerId("current_location"),
                icon: bitmapIcon,
                position: _currentPos!,
                infoWindow: const google_maps_marker.InfoWindow(title: "Current Location"),
              ),
            );
          });
        }
      }
    });
  }

  // ignore: unused_element
  void _cameraToPosition() async {
    _currentLocation = await _locationController.getLocation();
    if (_currentLocation == null) {
      return;
    }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          _currentLocation!.latitude ?? 0.0,
          _currentLocation!.longitude ?? 0.0,
        ),
        zoom: 19.151926040649414,
        tilt: 0,
        bearing: 0,
      ),
    ));
  }

  // for UI Changes
  bool hideContainer = false;
  double currentStateContainerHeight = 180;
  double heightAdjustment = 180;

  @override
  Widget build(BuildContext context) {
    // This method builds the UI for the driver's ride page.
    // You can customize it to display the driver's ride information.
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: MultiBlocProvider(
        providers: [
          BlocProvider<DriverRideStatusBloc>(
            create: (driverRideStatusContext) => DriverRideStatusBloc()..add(const DriverRideInitialize()),
          ),
        ],
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              buildingsEnabled: true,
              initialCameraPosition: _liveCameraPosition,
              polylines: Set<Polyline>.of(polylines.values),
              markers: _currentMarkers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (hideContainer) {
                        setState(() {
                          hideContainer = false;
                          currentStateContainerHeight = heightAdjustment;
                        });
                      } else {
                        setState(() {
                          hideContainer = true;
                          currentStateContainerHeight = 0;
                        });
                      }
                    },
                    child: Text(hideContainer ? "Show" : "Hide"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: hideContainer && currentStateContainerHeight == heightAdjustment ? 0 : currentStateContainerHeight,
                    width: double.infinity,
                    child: BlocConsumer<DriverRideStatusBloc, DriverRideStatusState>(
                      listener: (driverRideStatusBlocContext, driverStatusBlocState) async {
                        if (driverStatusBlocState is DriverRideStatusInitial) {
                          setState(() {
                            currentStateContainerHeight = 180;
                          });
                          await Future.delayed(const Duration(seconds: 1));

                          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                          FirebaseAuth firebaseAuth = FirebaseAuth.instance;

                          if (firebaseAuth.currentUser != null) {
                            var accountInstance = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);
                            var documentInstance = await accountInstance.get();

                            if (documentInstance.data() != null || documentInstance.exists) {
                              var data = documentInstance.data()!;

                              if (data["status"] == "in_a_ride") {
                                driverRideStatusBlocContext.read<DriverRideStatusBloc>().add(DriverStartRide(rideId: data["ride_id"].toString()));
                              } else {
                                driverRideStatusBlocContext.read<DriverRideStatusBloc>().add(const DriverRideStatusLoadWeatherData());
                              }
                            } else {
                              driverRideStatusBlocContext.read<DriverRideStatusBloc>().add(const DriverRideStatusLoadWeatherData());
                            }
                          } else {
                            driverRideStatusBlocContext.read<DriverRideStatusBloc>().add(const DriverRideStatusLoadWeatherData());
                          }
                        }

                        if (driverStatusBlocState is DriverPostRideFormDisplayed) {
                          setState(() {
                            heightAdjustment = 380;
                            currentStateContainerHeight = heightAdjustment;
                          });
                        }

                        if (driverStatusBlocState is DriverRideConfirmDetails) {
                          setState(() {
                            heightAdjustment = 320;
                            currentStateContainerHeight = heightAdjustment;
                          });
                        }
                        if (driverStatusBlocState is DriverRidePolylinesLoaded) {
                          polylines = driverStatusBlocState.generatedPolylines;
                          setState(() {});
                        }
                        if (driverStatusBlocState is DriverRidePassengersLoaded) {
                          await getLocationUpdates(driverStatusBlocState.rideInformation.rideId);
                          _currentMarkers.add(
                            google_maps_marker.Marker(
                              markerId: const google_maps_marker.MarkerId("start_location"),
                              position: LatLng(driverStatusBlocState.rideInformation.rideSourceLocation.latitude, driverStatusBlocState.rideInformation.rideSourceLocation.longitude),
                              draggable: false,
                              icon: await BitmapDescriptor.asset(
                                  const ImageConfiguration(
                                    size: Size(90, 90),
                                  ),
                                  "assets/driver_start_icon.png"),
                            ),
                          );
                          _currentMarkers.add(google_maps_marker.Marker(
                            markerId: const google_maps_marker.MarkerId("destination"),
                            position: LatLng(driverStatusBlocState.rideInformation.rideDestination.latitude, driverStatusBlocState.rideInformation.rideDestination.longitude),
                            icon: await BitmapDescriptor.asset(
                                const ImageConfiguration(
                                  size: Size(90, 90),
                                ),
                                "assets/driver_destination_icon.png"),
                          ));
                          if (mapSettings["checkDestination"] != null) {
                            _updateCameraView(LatLng(
                              mapSettings["checkDestination"].latitude,
                              mapSettings["checkDestination"].longitude,
                            ));
                            mapSettings.remove("checkDestination");
                          }
                          setState(() {
                            heightAdjustment = 360;
                            currentStateContainerHeight = heightAdjustment;
                          });
                        }
                        if (driverStatusBlocState is DriverRideStarted) {
                          //run an isolate to handle the location updates

                          setState(() {
                            heightAdjustment = 320;
                            currentStateContainerHeight = heightAdjustment;
                          });
                        }

                        if (driverStatusBlocState is DriverRideCompleted) {
                          polylines = {};
                          _currentMarkers.removeWhere(
                            (marker) => marker.markerId.value == "start_location",
                          );
                          _currentMarkers.removeWhere(
                            (marker) => marker.markerId.value == "destination",
                          );
                          setState(() {
                            heightAdjustment = 280;
                            currentStateContainerHeight = heightAdjustment;
                          });
                        }
                      },
                      builder: (driverRideStatusBlocContext, driverStatusBlocState) {
                        if (hideContainer) {
                          return const SizedBox.shrink();
                        } else {
                          if (driverStatusBlocState is DriverRideStatusInitial) {
                            return const Center(
                              child: Text(
                                "Loading...",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          if (driverStatusBlocState is DriverRideStatusWeatherDataLoaded) {
                            return DriverLoadWeatherDataWidget(
                              weatherData: driverStatusBlocState,
                            );
                          }
                          if (driverStatusBlocState is DriverPostRideFormDisplayed) {
                            return DriverPostRideFormDisplayedWidget(
                              onCarpoolDetailsCollected: (value) {
                                _rideTitle = value["ride_title"]!;
                                _rideDescription = value["ride_description"]!;
                              },
                            );
                          }
                          if (driverStatusBlocState is DriverSelectingStartLocation) {
                            return DriverSelectingStartLocationWidget(
                              onSelectStartLocation: (pickUpLocation) {
                                startLocationFormattedAddress = pickUpLocation;
                              },
                              onSelectStartCoordinates: (pickUpCoordinates) {
                                _selectedStartLocation = LatLng(
                                  pickUpCoordinates.latitude,
                                  pickUpCoordinates.longitude,
                                );

                                _updateCameraView(LatLng(
                                  pickUpCoordinates.latitude,
                                  pickUpCoordinates.longitude,
                                ));
                              },
                              onSelectStartMarker: (pickUpMarker) {
                                _currentMarkers.removeWhere(
                                  (marker) => marker.markerId.value == "start_location",
                                );
                                _currentMarkers.add(pickUpMarker);
                                setState(() {});
                              },
                            );
                          }
                          if (driverStatusBlocState is DriverSelectingDestination) {
                            return DriverSelectingDestinationWidget(
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
                              selectedStartLocation: _selectedStartLocation!,
                            );
                          }
                          if (driverStatusBlocState is DriverRideConfirmLoading) {
                            return const DriverRideConfirmLoadingWidget();
                          }
                          if (driverStatusBlocState is DriverRidePolylinesLoaded) {
                            return const DriverRideConfirmLoadingWidget();
                          }
                          if (driverStatusBlocState is DriverRideConfirmDetails) {
                            return DriverRideConfirmDetailsWidget(
                              rideTitle: _rideTitle,
                              rideDescription: _rideDescription,
                              onCarpoolDetailsProcessed: (processedValue) {},
                            );
                          }
                          if (driverStatusBlocState is DriverRidePassengersLoaded) {
                            return DriverRideStartedWidget(
                              onUpdateRide: (Map<String, dynamic> mapUpdate) async {
                                // RideCoordinates sourceLocation = mapUpdate["sourceLocation"] as RideCoordinates;
                                // RideCoordinates destination = mapUpdate["destination"] as RideCoordinates;
                                //polylines[PolylineId("poly")] = mapUpdate["polylines"] as Polyline;
                                // generatePolylineFromPoints([
                                //   LatLng(sourceLocation.latitude, sourceLocation.longitude),
                                //   LatLng(
                                //     destination.latitude,
                                //     destination.longitude,
                                //   )
                                // ]);

                                mapSettings.addAll(mapUpdate);
                                //_currentMarkers.removeWhere((marker) => marker.markerId.value == "current_location");
                                //_currentMarkers.add(Marker(markerId: MarkerId("current_location"), position: LatLng(latitude, longitude)));
                              },
                            );
                          }

                          if (driverStatusBlocState is DriverRideCompleted) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Lottie.asset('assets/congratulations.json', fit: BoxFit.cover),
                                ),
                                Text(
                                  "Congratulations! You have earned ₱ ${driverStatusBlocState.rideInformation.rideEarnings.toStringAsFixed(2)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                            FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                                            var accountInstance = firebaseFirestore.collection("account_information").doc(firebaseAuth.currentUser!.uid);
                                            await accountInstance.update({
                                              "status": "idle",
                                              "ride_id": "",
                                            });
                                            await firebaseFirestore.collection("ride_information").doc(driverStatusBlocState.rideInformation.rideId).update({
                                              "ride_status": "completed",
                                            });
                                            await firebaseFirestore.collection("ride_information").doc(driverStatusBlocState.rideInformation.rideId).collection("passenger_information").get().then((value) {
                                              for (var element in value.docs) {
                                                element.reference.update({
                                                  "ride_status": "completed",
                                                });
                                              }
                                            });
                                          } catch (e) {
                                            print("Error: $e");
                                          }
                                          driverRideStatusBlocContext.read<DriverRideStatusBloc>().add(const DriverRideInitialize());
                                        },
                                        child: const Text("I want to do it again!")),
                                  ),
                                )
                              ],
                            );
                          }
                          return const Icon(Icons.help_outline);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
