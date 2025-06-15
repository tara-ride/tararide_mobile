import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart' as google_maps_marker;
import 'package:tararide_mobile/models/geocoding_data.dart' as GeocodingDataModel;
import '../../../../bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

class PassengerSelectingPickupLocationWidget extends StatefulWidget {
  final ValueChanged<GeocodingDataModel.Result> onSelectPickupLocation;
  final ValueChanged<LatLng> onSelectPickupCoordinates;
  final ValueChanged<google_maps_marker.Marker> onSelectPickupMarker;
  const PassengerSelectingPickupLocationWidget({super.key, required this.onSelectPickupLocation, required this.onSelectPickupCoordinates, required this.onSelectPickupMarker});

  @override
  State<PassengerSelectingPickupLocationWidget> createState() => _PassengerSelectingPickupLocationWidgetState();
}

class _PassengerSelectingPickupLocationWidgetState extends State<PassengerSelectingPickupLocationWidget> {
  final PassengerSelectingPickupLocation passengerSelectingPickupLocationState = PassengerSelectingPickupLocation(possiblePickupLocations: []);
  final TextEditingController _pickupSearchBarController = TextEditingController();
  LatLng? _selectedPickupLocation;

  String pickupLocationFormattedAddress = "";
  int _pickupItemSelectedIndex = -1;
  final Set<google_maps_marker.Marker> _currentMarkers = {};

  @override
  Widget build(BuildContext context) {
    final passengerSelectingPickupLocationState = context.watch<PassengerRideStatusBloc>().state as PassengerSelectingPickupLocation;

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
                        context.read<PassengerRideStatusBloc>().add(PassengerSelectPickupLocation(pickupLocation: _pickupSearchBarController.text));
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
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: passengerSelectingPickupLocationState.possiblePickupLocations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _pickupItemSelectedIndex = index;
                      });

                      _currentMarkers.clear();
                      _selectedPickupLocation = LatLng(
                        passengerSelectingPickupLocationState.possiblePickupLocations[index].geometry.location.lat,
                        passengerSelectingPickupLocationState.possiblePickupLocations[index].geometry.location.lng,
                      );
                      pickupLocationFormattedAddress = passengerSelectingPickupLocationState.possiblePickupLocations[index].formattedAddress;
                      widget.onSelectPickupLocation(passengerSelectingPickupLocationState.possiblePickupLocations[index]);
                      widget.onSelectPickupCoordinates(_selectedPickupLocation!);
                      widget.onSelectPickupMarker(
                        google_maps_marker.Marker(
                          markerId: const google_maps_marker.MarkerId("pickup_location"),
                          position: LatLng(
                            passengerSelectingPickupLocationState.possiblePickupLocations[index].geometry.location.lat,
                            passengerSelectingPickupLocationState.possiblePickupLocations[index].geometry.location.lng,
                          ),
                          draggable: false,
                          icon: await BitmapDescriptor.asset(
                              const ImageConfiguration(
                                size: Size(90, 90),
                              ),
                              "assets/passenger_start_icon.png"),
                          infoWindow: google_maps_marker.InfoWindow(
                            title: passengerSelectingPickupLocationState.possiblePickupLocations[index].formattedAddress,
                          ),
                        ),
                      );
                      print("Selected Location: ${passengerSelectingPickupLocationState.possiblePickupLocations[index].formattedAddress}");
                    },
                    child: AnimatedContainer(
                      width: double.infinity,
                      height: _pickupItemSelectedIndex == index ? 90 : 50,
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
                                  passengerSelectingPickupLocationState.possiblePickupLocations[index].addressComponents.first.longName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${passengerSelectingPickupLocationState.possiblePickupLocations[index].geometry.location.lat}, ${passengerSelectingPickupLocationState.possiblePickupLocations[index].geometry.location.lng}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                _pickupItemSelectedIndex == index
                                    ? Text(
                                        passengerSelectingPickupLocationState.possiblePickupLocations[index].formattedAddress,
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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    if (_pickupItemSelectedIndex < 0 || _pickupItemSelectedIndex >= passengerSelectingPickupLocationState.possiblePickupLocations.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a valid location"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }

                    context.read<PassengerRideStatusBloc>().add(const PassengerSelectDestination());
                  },
                  child: const Text("Select Pickup Location")),
            ),
          ),
        ],
      ),
    );
  }
}
