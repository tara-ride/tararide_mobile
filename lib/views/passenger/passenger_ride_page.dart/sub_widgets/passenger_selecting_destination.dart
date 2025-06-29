import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart' as google_maps_marker;
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';
// ignore: library_prefixes
import 'package:tararide_mobile/models/geocoding_data.dart' as GeocodingDataModel;

// ignore: must_be_immutable
class PassengerSelectingDestinationWidget extends StatefulWidget {
  LatLng selectedPickUpLocation;
  String pickupLocationFormattedAddress = "";
  final ValueChanged<GeocodingDataModel.Result> onSelectDestination;
  final ValueChanged<LatLng> onSelectDestinationCoordinates;
  final ValueChanged<google_maps_marker.Marker> onSelectDestinationMarker;

  PassengerSelectingDestinationWidget({super.key, required this.selectedPickUpLocation, required this.onSelectDestination, required this.onSelectDestinationCoordinates, required this.onSelectDestinationMarker});

  @override
  State<StatefulWidget> createState() => PassengerSelectingDestinationWidgetState();
}

class PassengerSelectingDestinationWidgetState extends State<PassengerSelectingDestinationWidget> {
  final TextEditingController _destinationSearchBarController = TextEditingController();
  int _destinationItemSelectedIndex = -1;
  LatLng? _selectedDestinationLocation;
  String destinationLocationFormattedAddress = "";

  @override
  Widget build(BuildContext context) {
    final passengerRideStatusState = context.watch<PassengerRideStatusBloc>().state as PassengerSelectingDestination;

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
                    decoration: InputDecoration(
                      hintText: "Where to drop you off?",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _destinationSearchBarController.clear();
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
                    if (_destinationSearchBarController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid location"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    } else {
                      try {
                        // Here you can add logic to fetch the destination location
                        context.read<PassengerRideStatusBloc>().add(PassengerSelectDestination(destinationLocation: _destinationSearchBarController.text));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cannot find location, please try again"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        
                      }
                    }
                  },
                  child: const Text("Go"),
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: passengerRideStatusState.possibleDestinations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _destinationItemSelectedIndex = index;
                        });
                        _selectedDestinationLocation = LatLng(
                          passengerRideStatusState.possibleDestinations[index].geometry.location.lat,
                          passengerRideStatusState.possibleDestinations[index].geometry.location.lng,
                        );
                        widget.onSelectDestination(passengerRideStatusState.possibleDestinations[index]);
                        widget.onSelectDestinationCoordinates(_selectedDestinationLocation!);
                        widget.onSelectDestinationMarker(
                          google_maps_marker.Marker(
                            markerId: const google_maps_marker.MarkerId("destination"),
                            position: _selectedDestinationLocation!,
                            icon: await BitmapDescriptor.asset(
                                const ImageConfiguration(
                                  size: Size(90, 90),
                                ),
                                "assets/passenger_destination_icon.png"),
                            infoWindow: google_maps_marker.InfoWindow(
                              title: passengerRideStatusState.possibleDestinations[index].formattedAddress,
                            ),
                          ),
                        );
                        destinationLocationFormattedAddress = passengerRideStatusState.possibleDestinations[index].formattedAddress;
                        // _updateCameraView(LatLng(
                        //   passengerRideStatusState.possibleDestinations[index].geometry.location.lat,
                        //   passengerRideStatusState.possibleDestinations[index].geometry.location.lng,
                        // ));
                        
                      },
                      child: AnimatedContainer(
                        width: double.infinity,
                        height: _destinationItemSelectedIndex == index ? 90 : 50,
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
                                    passengerRideStatusState.possibleDestinations[index].addressComponents.first.longName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${passengerRideStatusState.possibleDestinations[index].geometry.location.lat}, ${passengerRideStatusState.possibleDestinations[index].geometry.location.lng}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  _destinationItemSelectedIndex == index
                                      ? Text(
                                          passengerRideStatusState.possibleDestinations[index].formattedAddress,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
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
                    if (_destinationItemSelectedIndex < 0 || _destinationItemSelectedIndex >= passengerRideStatusState.possibleDestinations.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a valid location"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }
                    context.read<PassengerRideStatusBloc>().add(
                        PassengerInitializeConfirmRide(destinationCoordinates: _selectedDestinationLocation!, pickupCoordinates: widget.selectedPickUpLocation, pickupLocationFormattedAddress: widget.pickupLocationFormattedAddress, destinationFormattedAddress: destinationLocationFormattedAddress));
                  },
                  child: const Text("Select Destination")),
            ),
          ),
        ],
      ),
    );
  }
}
