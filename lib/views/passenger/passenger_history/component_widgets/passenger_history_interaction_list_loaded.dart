import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/passenger_history_interaction/passenger_history_interaction_bloc.dart';

class PassengerHistoryInteractionListLoadedWidget extends StatefulWidget {
  const PassengerHistoryInteractionListLoadedWidget({super.key});

  @override
  State<StatefulWidget> createState() => PassengerHistoryInteractionListLoadedState();
}

class PassengerHistoryInteractionListLoadedState extends State<PassengerHistoryInteractionListLoadedWidget> {
  @override
  Widget build(BuildContext context) {
    PassengerHistoryInteractionListLoaded passengerHistoryInteractionListLoaded = context.watch<PassengerHistoryInteractionBloc>().state as PassengerHistoryInteractionListLoaded;
    return Expanded(
      child: ListView.builder(
        itemCount: passengerHistoryInteractionListLoaded.historyInformationList.length,
        itemBuilder: (itemContext, index) {
          final ride = passengerHistoryInteractionListLoaded.historyInformationList[index];
          return GestureDetector(
            onTap: () {
              
              context.read<PassengerHistoryInteractionBloc>().add(InitializePassengerHistoryInteraction(historyInteractionData: passengerHistoryInteractionListLoaded.historyInformationList[index]));
              ScaffoldMessenger.of(context).showSnackBar(
                  snackBarAnimationStyle: AnimationStyle(
                      curve: Curves.easeInOut,
                      duration: const Duration(
                        milliseconds: 500,
                      )),
                  const SnackBar(
                    content: Text(
                      "Loading ride history..",
                    ),
                    duration: Duration(milliseconds: 100),
                  ));
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.rideTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ride.rideDescription,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${MaterialLocalizations.of(context).formatFullDate(ride.rideCompletedAt)}, ${MaterialLocalizations.of(context).formatTimeOfDay(
                        TimeOfDay.fromDateTime(ride.rideCompletedAt),
                        alwaysUse24HourFormat: false,
                      )}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
