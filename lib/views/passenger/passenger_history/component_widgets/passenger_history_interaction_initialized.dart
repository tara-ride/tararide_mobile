import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/passenger_history_interaction/passenger_history_interaction_bloc.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';

class PassengerHistoryInteractionInitializedWidget extends StatefulWidget {
  const PassengerHistoryInteractionInitializedWidget({super.key});

  @override
  State<StatefulWidget> createState() => PassengerHistoryInteractionInitializedWidgetState();
}

class PassengerHistoryInteractionInitializedWidgetState extends State<PassengerHistoryInteractionInitializedWidget> {
  String historyId = '';
  String passengerId = '';
  String paymentId = '';
  DateTime rideCompletedAt = DateTime.now();
  String rideDescription = '';
  RideCoordinates rideDestination = RideCoordinates(latitude: 0.0, longitude: 0.0);
  String rideId = '';
  RideCoordinates rideSourceLocation = RideCoordinates(latitude: 0.0, longitude: 0.0);
  String rideTitle = '';

  @override
  Widget build(BuildContext context) {
    PassengerHistoryInteractionInitialized passengerHistoryInteractionInitialized = context.watch<PassengerHistoryInteractionBloc>().state as PassengerHistoryInteractionInitialized;
    final history = passengerHistoryInteractionInitialized.historyInteraction;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                history.rideTitle ?? 'No Title',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                history.rideDescription ?? 'No Description',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Source: (${history.rideSourceLocation?.latitude?.toStringAsFixed(4) ?? '0.0'}, '
                      '${history.rideSourceLocation?.longitude?.toStringAsFixed(4) ?? '0.0'})',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.flag, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Destination: (${history.rideDestination?.latitude?.toStringAsFixed(4) ?? '0.0'}, '
                      '${history.rideDestination?.longitude?.toStringAsFixed(4) ?? '0.0'})',
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _infoRow('History ID', history.historyId),
              _infoRow('Passenger ID', history.passengerId),
              _infoRow('Payment ID', history.paymentId),
              _infoRow('Ride ID', history.rideId),
              _infoRow(
                'Completed At',
                history.rideCompletedAt != null ? (history.rideCompletedAt as DateTime).toLocal().toString() : 'N/A',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }
}
