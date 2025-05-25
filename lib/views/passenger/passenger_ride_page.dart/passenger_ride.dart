import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';
import 'package:tararide_mobile/repository/gcp_weather_api_repository.dart';

class PassengerRide extends StatefulWidget {
  const PassengerRide({super.key});

  @override
  State<StatefulWidget> createState() => PassengerRideState();
}

class PassengerRideState extends State<PassengerRide> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  bool hideContainer = false;
  double currentStateContainerHeight = 180;
  double heightAdjustment = 180;
  double feedback_rating = 0;
  int _pickupItemSelectedIndex = 0;
  final TextEditingController _pickupSearchBarController = TextEditingController();
  final TextEditingController _destinationSearchBarController = TextEditingController();
  final TextEditingController _feedbackCommentController = TextEditingController();
  List<Location> possiblePickupLocations = [
    Location(
      latitude: 14.383,
      longitude: 120.9773,
      timestamp: DateTime.now(),
    ),
  ];
  static const CameraPosition _liveCameraPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(14.410864386525509, 121.0380144417286),
    tilt: 0,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PassengerRideStatusBloc(GcpWeatherApiRepositoryImplementation())..add(PassengerRideStatusInitialize()),
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
                  )
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
                        if (passengerRideStatusState is PassengerRideStatusInitial) {
                          setState(
                            () {
                              currentStateContainerHeight = 180;
                              heightAdjustment = currentStateContainerHeight;
                            },
                          );
                          print("Height Adjustment: $heightAdjustment");
                        }
                        if (passengerRideStatusState is PassengerSelectingPickupLocation) {
                          setState(
                            () {
                              currentStateContainerHeight = 300;
                              heightAdjustment = currentStateContainerHeight;
                            },
                          );

                          print("HOPYA MANIPAPCARN ${passengerRideStatusState.possiblePickupLocations!.length}");
                          print("Height Adjustment: $heightAdjustment");
                        }
                        if (passengerRideStatusState is PassengerSelectingRide) {
                          setState(
                            () {
                              currentStateContainerHeight = 280;
                              heightAdjustment = currentStateContainerHeight;
                            },
                          );
                          print("Height Adjustment: $heightAdjustment");
                        }

                        if (passengerRideStatusState is PassengerRideStarted) {
                          setState(
                            () {
                              currentStateContainerHeight = 180;
                              heightAdjustment = currentStateContainerHeight;
                            },
                          );
                          print("Height Adjustment: $heightAdjustment");
                        }
                        if (passengerRideStatusState is PassengerRidePaymentStarted) {
                          setState(
                            () {
                              currentStateContainerHeight = 520;
                              heightAdjustment = currentStateContainerHeight;
                            },
                          );
                          print("Height Adjustment: $heightAdjustment");
                        }
                        if (passengerRideStatusState is PassengerRideFeedbackCompleted) {
                          setState(
                            () {
                              currentStateContainerHeight = 180;
                              heightAdjustment = currentStateContainerHeight;
                            },
                          );
                          Future.delayed(const Duration(seconds: 2), () {
                            passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize());
                          });
                          print("Height Adjustment: $heightAdjustment");
                        }
                      },
                      builder: (passengerRideStatusContext, passengerRideStatusState) {
                        if (passengerRideStatusState is PassengerRideStatusWeatherDataLoaded) {
                          return SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(255, 217, 243, 255),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: double.infinity,
                                          child: Lottie.asset('assets/sunny_day.json'),
                                        ),
                                        Text(
                                          "${passengerRideStatusState.weatherDataFromAPI.temperature.degrees.toString()} °C",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text("Weather Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Time: ${DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())}"),
                                      Text("Time: ${DateTime.now().timeZoneName}"),
                                      // Text("Humidity: ${passengerRideStatusState.weatherDataFromAPI.relativeHumidity}%"),
                                      Text(passengerRideStatusState.weatherDataFromAPI.weatherCondition.description.text),
                                      const Expanded(child: SizedBox()),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerSelectPickupLocation());
                                              },
                                              child: const Text("Ride Now")),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (passengerRideStatusState is PassengerSelectingPickupLocation) {
                          return SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller: _pickupSearchBarController,
                                          decoration: InputDecoration(
                                            hintText: "Where to pick you up?",
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _pickupSearchBarController.clear();
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_pickupSearchBarController.text.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("Please enter a valid location"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            return;
                                          } else {
                                            try {
                                              passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerSelectPickupLocation(pickupLocation: _pickupSearchBarController.text));
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Cannot find location, please try again"),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                              print("Error: $e");
                                            }
                                          }
                                        },
                                        child: const Text("Go"),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: ListView.builder(
                                      shrinkWrap: false,
                                      itemCount: passengerRideStatusState.possiblePickupLocations.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _pickupItemSelectedIndex = index;
                                              });
                                              _updateCameraView(LatLng(
                                                passengerRideStatusState.possiblePickupLocations[index].geometry.location.lat,
                                                passengerRideStatusState.possiblePickupLocations[index].geometry.location.lng,
                                              ));
                                              print("Selected Location: ${passengerRideStatusState.possiblePickupLocations[index].formattedAddress}");
                                            },
                                            child: AnimatedContainer(
                                              width: double.infinity,
                                              height: _pickupItemSelectedIndex == index ? 120 : 50,
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(7),
                                                color: Colors.white,
                                                boxShadow: const <BoxShadow>[
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 3,
                                                    offset: Offset.zero,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(Icons.location_on),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          passengerRideStatusState.possiblePickupLocations[index].addressComponents.first.longName,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${passengerRideStatusState.possiblePickupLocations[index].geometry.location.lat}, ${passengerRideStatusState.possiblePickupLocations[index].geometry.location.lng}",
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        _pickupItemSelectedIndex == index
                                                            ? Text(
                                                                passengerRideStatusState.possiblePickupLocations[index].formattedAddress,
                                                                softWrap: true,
                                                                maxLines: 3,
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.black,
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerSelectDestination());
                                        },
                                        child: const Text("Select Pickup Location")),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (passengerRideStatusState is PassengerSelectingDestination) {
                          return SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: SearchBar(
                                    hintText: "Where to go?",
                                    elevation: WidgetStatePropertyAll(5),
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
                                        child: ListView.builder(
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text("Location ${index.toString()}"),
                                            );
                                          },
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerSelectRide());
                                        },
                                        child: const Text("Select Destination")),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (passengerRideStatusState is PassengerSelectingRide) {
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ListView.builder(
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(7),
                                              ),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 3,
                                                  offset: Offset.zero,
                                                )
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Icon(Icons.directions_car),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Driver ${index.toString()}"),
                                                      Text("Available seats: ${Random().nextInt(4) + 1}"),
                                                    ],
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Icon(Icons.arrow_forward_ios),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideStart());
                                        },
                                        child: const Text("Choose Driver")),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (passengerRideStatusState is PassengerRideStarted) {
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
                                        const Text("Driver: John Doe"),
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
                                                  passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideProgress());
                                                },
                                                child: const Text("Confirm")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ));
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
                                                  passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRidePaymentStart());
                                                },
                                                child: const Text("Drop Off Now")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ));
                        } else if (passengerRideStatusState is PassengerRidePaymentStarted) {
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
                                  child: Text("Distance Traveled: 10 km"),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text("Time Taken: 15 mins"),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text("Total Amount: ₱ 200.00"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("Payment has been completed!"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackStart());
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
                                                content: Text("Payment has been completed!"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            passengerRideStatusContext.read<PassengerRideStatusBloc>().add(PassengerRideFeedbackStart());
                                          },
                                          child: const Text(
                                            "Pay via E-wallet",
                                          ))),
                                ),
                              ],
                            ),
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
