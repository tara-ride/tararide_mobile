import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart' as google_maps_marker;
// ignore: library_prefixes
import 'package:tararide_mobile/models/geocoding_data.dart' as GeocodingDataModel;
import 'package:tararide_mobile/models/places_data.dart';
import 'package:tararide_mobile/repository/places_repository.dart';

import '../../../../bloc/driver_ride_status/driver_ride_status_bloc.dart';

// ignore: must_be_immutable
class DriverSelectingDestinationWidget extends StatefulWidget {
  LatLng selectedStartLocation;
  String pickupLocationFormattedAddress = "";
  final ValueChanged<String> onSelectDestination;
  final ValueChanged<LatLng> onSelectDestinationCoordinates;
  final ValueChanged<google_maps_marker.Marker> onSelectDestinationMarker;

  DriverSelectingDestinationWidget({super.key, required this.selectedStartLocation, required this.onSelectDestination, required this.onSelectDestinationCoordinates, required this.onSelectDestinationMarker});

  @override
  State<StatefulWidget> createState() => DriverSelectingDestinationWidgetState();
}

class DriverSelectingDestinationWidgetState extends State<DriverSelectingDestinationWidget> {
  final TextEditingController _destinationSearchBarController = TextEditingController();
  int _destinationItemSelectedIndex = -1;
  LatLng? _selectedDestinationLocation;
  String destinationLocationFormattedAddress = "";
  PlacesRepositoryImplementation placesRepositoryImplementation = PlacesRepositoryImplementation();
  List<Places> _placesList = [];

  @override
  Widget build(BuildContext context) {
    final driverRideStatusState = context.watch<DriverRideStatusBloc>().state as DriverSelectingDestination;
    if (_placesList.isEmpty) {
      placesRepositoryImplementation.getPlacesListOnce().then((updatedPlacesList) {
        setState(() {
          _placesList = updatedPlacesList.where((place) => place.name.contains(_destinationSearchBarController.text)).toList();
        });
      });
    }
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
                    controller: _destinationSearchBarController,
                    onChanged: (value) {
                      setState(() {
                        _placesList = _placesList.where((place) => place.name.toLowerCase().contains(value.toLowerCase())).toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Where's the destination?",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _destinationSearchBarController.clear();
                          setState(() {
                            _placesList = [];
                            _destinationItemSelectedIndex = -1;
                            _selectedDestinationLocation = null;
                            destinationLocationFormattedAddress = "";
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 8),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       if (_destinationSearchBarController.text.isEmpty) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(
              //             content: Text("Please enter a valid location"),
              //             duration: Duration(seconds: 2),
              //           ),
              //         );
              //         return;
              //       } else {
              //         try {
              //           // Here you can add logic to fetch the destination location
              //           context.read<DriverRideStatusBloc>().add(DriverSelectDestination(destinationLocation: _destinationSearchBarController.text));
              //         } catch (e) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             const SnackBar(
              //               content: Text("Cannot find location, please try again"),
              //               duration: Duration(seconds: 2),
              //             ),
              //           );
              //           print("Error: $e");
              //         }
              //       }
              //     },
              //     child: const Text("Go"),
              //   ),
              // ),
            ],
          ),
          // Expanded(
          //   child: SizedBox(
          //     height: double.infinity,
          //     width: double.infinity,
          //     child: ListView.builder(
          //       shrinkWrap: false,
          //       itemCount: driverRideStatusState.possibleDestinations.length,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: GestureDetector(
          //             onTap: () async {
          //               setState(() {
          //                 _destinationItemSelectedIndex = index;
          //               });
          //               _selectedDestinationLocation = LatLng(
          //                 driverRideStatusState.possibleDestinations[index].geometry.location.lat,
          //                 driverRideStatusState.possibleDestinations[index].geometry.location.lng,
          //               );
          //               widget.onSelectDestination(driverRideStatusState.possibleDestinations[index]);
          //               widget.onSelectDestinationCoordinates(_selectedDestinationLocation!);
          //               widget.onSelectDestinationMarker(
          //                 google_maps_marker.Marker(
          //                   markerId: const google_maps_marker.MarkerId("destination"),
          //                   position: _selectedDestinationLocation!,
          //                   icon: await BitmapDescriptor.asset(
          //                       const ImageConfiguration(
          //                         size: Size(90, 90),
          //                       ),
          //                       "assets/driver_destination_icon.png"),
          //                   infoWindow: google_maps_marker.InfoWindow(
          //                     title: driverRideStatusState.possibleDestinations[index].formattedAddress,
          //                   ),
          //                 ),
          //               );
          //               destinationLocationFormattedAddress = driverRideStatusState.possibleDestinations[index].formattedAddress;
          //               // _updateCameraView(LatLng(
          //               //   driverRideStatusState.possibleDestinations[index].geometry.location.lat,
          //               //   driverRideStatusState.possibleDestinations[index].geometry.location.lng,
          //               // ));
          //               print("Selected Location: ${driverRideStatusState.possibleDestinations[index].formattedAddress}");
          //             },
          //             child: AnimatedContainer(
          //               width: double.infinity,
          //               height: _destinationItemSelectedIndex == index ? 90 : 50,
          //               duration: const Duration(milliseconds: 300),
          //               curve: Curves.easeInOut,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(7),
          //                 color: Colors.white,
          //                 boxShadow: const <BoxShadow>[
          //                   BoxShadow(
          //                     color: Colors.black,
          //                     blurRadius: 3,
          //                     offset: Offset.zero,
          //                   )
          //                 ],
          //               ),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   const Padding(
          //                     padding: EdgeInsets.all(5),
          //                     child: Icon(Icons.location_on),
          //                   ),
          //                   Expanded(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           driverRideStatusState.possibleDestinations[index].addressComponents.first.longName,
          //                           overflow: TextOverflow.ellipsis,
          //                           maxLines: 1,
          //                           style: const TextStyle(
          //                             fontSize: 16,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                         Text(
          //                           "${driverRideStatusState.possibleDestinations[index].geometry.location.lat}, ${driverRideStatusState.possibleDestinations[index].geometry.location.lng}",
          //                           overflow: TextOverflow.ellipsis,
          //                           maxLines: 1,
          //                           style: const TextStyle(
          //                             fontSize: 12,
          //                             color: Colors.grey,
          //                           ),
          //                         ),
          //                         _destinationItemSelectedIndex == index
          //                             ? Text(
          //                                 driverRideStatusState.possibleDestinations[index].formattedAddress,
          //                                 softWrap: true,
          //                                 overflow: TextOverflow.ellipsis,
          //                                 maxLines: 2,
          //                                 style: const TextStyle(
          //                                   fontSize: 12,
          //                                   color: Colors.black,
          //                                 ),
          //                               )
          //                             : const SizedBox.shrink(),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _placesList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _destinationItemSelectedIndex = index;
                        });

                        _selectedDestinationLocation = LatLng(
                          _placesList[index].latitude,
                          _placesList[index].longitude,
                        );
                        destinationLocationFormattedAddress = _placesList[index].name;
                        widget.onSelectDestination(_placesList[index].name);
                        widget.onSelectDestinationCoordinates(_selectedDestinationLocation!);
                        widget.onSelectDestinationMarker(
                          google_maps_marker.Marker(
                            markerId: const google_maps_marker.MarkerId("destination"),
                            position: LatLng(_placesList[index].latitude, _placesList[index].longitude),
                            draggable: false,
                            icon: await BitmapDescriptor.asset(
                                const ImageConfiguration(
                                  size: Size(90, 90),
                                ),
                                "assets/passenger_destination_icon.png"),
                            infoWindow: google_maps_marker.InfoWindow(
                              title: _placesList[index].name,
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        width: double.infinity,
                        height: _destinationItemSelectedIndex == index ? 60 : 50,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          //rgb(93, 46, 123)
                          color: _destinationItemSelectedIndex == index ? const Color.fromARGB(255, 238, 211, 255) : Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 3,
                              offset: Offset.zero,
                            ),
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
                                    _placesList[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${cityValues.reverse[_placesList[index].city]}: ${_placesList[index].latitude}, ${_placesList[index].longitude}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color.fromARGB(255, 29, 29, 29),
                                    ),
                                  ),
                                  const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    if (_destinationItemSelectedIndex < 0 || _destinationItemSelectedIndex >= _placesList.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a valid location"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }

                    context
                        .read<DriverRideStatusBloc>()
                        .add(DriverInitializeConfirmRide(destinationCoordinates: _selectedDestinationLocation!, startCoordinates: widget.selectedStartLocation, startLocationFormattedAddress: widget.pickupLocationFormattedAddress, destinationFormattedAddress: destinationLocationFormattedAddress));
                  },
                  child: const Text("Select Destination")),
            ),
          ),
        ],
      ),
    );
  }
}
