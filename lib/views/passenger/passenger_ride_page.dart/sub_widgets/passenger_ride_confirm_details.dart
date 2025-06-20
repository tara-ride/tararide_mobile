import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

class PassengerRideConfirmDetailsWidget extends StatefulWidget {
  final String pickupLocationFormattedAddress;
  final String destinationFormattedAddress;
  const PassengerRideConfirmDetailsWidget({
    super.key,
    required this.pickupLocationFormattedAddress,
    required this.destinationFormattedAddress,
  });

  @override
  State<PassengerRideConfirmDetailsWidget> createState() => _PassengerRideConfirmDetailsWidgetState();
}

class _PassengerRideConfirmDetailsWidgetState extends State<PassengerRideConfirmDetailsWidget> {
  String selectedSeatsToOccupy = '1';

  @override
  Widget build(BuildContext context) {
    final passengerRideStatusState = context.watch<PassengerRideStatusBloc>().state as PassengerRideConfirmDetails;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              height: 20,
              child: Text(
                "Ride Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pickup Location"),
                  Container(
                    width: double.infinity,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
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
                      children: [
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.location_on)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              widget.pickupLocationFormattedAddress,
                              style: const TextStyle(fontSize: 11, color: Colors.black),
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text("Destination"),
                  Container(
                    width: double.infinity,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
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
                      children: [
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.location_on)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              widget.destinationFormattedAddress,
                              style: const TextStyle(fontSize: 11, color: Colors.black),
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Ride Distance: ${passengerRideStatusState.distanceMatrix}"),
                  Text("Estimated Time of Arrival (ETA): ${passengerRideStatusState.durationMatrix}"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Seats to Occupy:"),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedSeatsToOccupy,
                        items: <String>['1', '2', '3', '4'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSeatsToOccupy = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<PassengerRideStatusBloc>().add(PassengerRideStatusInitialize());
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        print("HELLO SEATS OCCUPIED: $selectedSeatsToOccupy");
                        context.read<PassengerRideStatusBloc>().add(PassengerConfirmRide(
                              pickupLocation: passengerRideStatusState.pickupCoordinates,
                              estimatedTime: passengerRideStatusState.durationMatrix,
                              rideDistance: passengerRideStatusState.distance.value.toDouble(),
                              slotsToOccupy: int.parse(selectedSeatsToOccupy),
                              destinationLocation: passengerRideStatusState.destinationCoordinates,
                              destinationFormattedAddress: widget.destinationFormattedAddress,
                              pickupLocationFormattedAddress: widget.pickupLocationFormattedAddress,
                            ));
                      },
                      child: const Text("Confirm"),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
