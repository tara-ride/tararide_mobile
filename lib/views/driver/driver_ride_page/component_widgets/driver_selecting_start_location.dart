import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart' as google_maps_marker;
import 'package:tararide_mobile/models/geocoding_data.dart' as GeocodingDataModel;
import '../../../../bloc/driver_ride_status/driver_ride_status_bloc.dart';

class DriverSelectingStartLocationWidget extends StatefulWidget {
  final ValueChanged<GeocodingDataModel.Result> onSelectStartLocation;
  final ValueChanged<LatLng> onSelectStartCoordinates;
  final ValueChanged<google_maps_marker.Marker> onSelectStartMarker;
  const DriverSelectingStartLocationWidget({super.key, required this.onSelectStartLocation, required this.onSelectStartCoordinates, required this.onSelectStartMarker});

  @override
  State<DriverSelectingStartLocationWidget> createState() => _DriverSelectingStartLocationWidgetState();
}

class _DriverSelectingStartLocationWidgetState extends State<DriverSelectingStartLocationWidget> {
  final DriverSelectingStartLocation driverSelectingStartLocationState = DriverSelectingStartLocation(possibleStartLocations: []);
  final TextEditingController _startSearchBarController = TextEditingController();
  LatLng? _selectedStartLocation;

  String startLocationFormattedAddress = "";
  int _startItemSelectedIndex = -1;
  final Set<google_maps_marker.Marker> _currentMarkers = {};

  @override
  Widget build(BuildContext context) {
    final driverSelectingStartLocationState = context.watch<DriverRideStatusBloc>().state as DriverSelectingStartLocation;

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
                    controller: _startSearchBarController,
                    decoration: InputDecoration(
                      hintText: "Where to pick you up?",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _startSearchBarController.clear();
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
                    if (_startSearchBarController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid location"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    } else {
                      try {
                        context.read<DriverRideStatusBloc>().add(DriverSelectStartLocation(startLocation: _startSearchBarController.text));
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
              itemCount: driverSelectingStartLocationState.possibleStartLocations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _startItemSelectedIndex = index;
                      });
                      _currentMarkers.clear();
                      _selectedStartLocation = LatLng(
                        driverSelectingStartLocationState.possibleStartLocations[index].geometry.location.lat,
                        driverSelectingStartLocationState.possibleStartLocations[index].geometry.location.lng,
                      );
                      BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(
                          const ImageConfiguration(
                            size: Size(90, 90),
                          ),
                          "assets/driver_start_icon.png");
                      startLocationFormattedAddress = driverSelectingStartLocationState.possibleStartLocations[index].formattedAddress;
                      widget.onSelectStartLocation(driverSelectingStartLocationState.possibleStartLocations[index]);
                      widget.onSelectStartCoordinates(_selectedStartLocation!);
                      widget.onSelectStartMarker(
                        google_maps_marker.Marker(
                          markerId: const google_maps_marker.MarkerId("start_location"),
                          position: LatLng(
                            driverSelectingStartLocationState.possibleStartLocations[index].geometry.location.lat,
                            driverSelectingStartLocationState.possibleStartLocations[index].geometry.location.lng,
                          ),
                          draggable: false,
                          icon: bitmapIcon,
                          infoWindow: google_maps_marker.InfoWindow(
                            title: driverSelectingStartLocationState.possibleStartLocations[index].formattedAddress,
                          ),
                        ),
                      );
                      print("Selected Location: ${driverSelectingStartLocationState.possibleStartLocations[index].formattedAddress}");
                    },
                    child: AnimatedContainer(
                      width: double.infinity,
                      height: _startItemSelectedIndex == index ? 90 : 50,
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
                                  driverSelectingStartLocationState.possibleStartLocations[index].addressComponents.first.longName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${driverSelectingStartLocationState.possibleStartLocations[index].geometry.location.lat}, ${driverSelectingStartLocationState.possibleStartLocations[index].geometry.location.lng}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                _startItemSelectedIndex == index
                                    ? Text(
                                        driverSelectingStartLocationState.possibleStartLocations[index].formattedAddress,
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
                    if (_startItemSelectedIndex < 0 || _startItemSelectedIndex >= driverSelectingStartLocationState.possibleStartLocations.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a valid location"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }

                    context.read<DriverRideStatusBloc>().add(const DriverSelectDestination());
                  },
                  child: const Text("Select Start Location")),
            ),
          ),
        ],
      ),
    );
  }
}
