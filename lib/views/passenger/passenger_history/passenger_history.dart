import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_history_interaction/passenger_history_interaction_bloc.dart';
import 'package:tararide_mobile/views/passenger/passenger_history/component_widgets/passenger_history_interaction_list_loaded.dart';

import 'component_widgets/passenger_history_interaction_initialized.dart';

class PassengerHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PassengerHistoryState();
}

class PassengerHistoryState extends State<PassengerHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<PassengerHistoryInteractionBloc>(
      create: (context) => PassengerHistoryInteractionBloc()..add(LoadPassengerHistoryInteraction()),
      child: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color.fromARGB(255, 249, 242, 255)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: BlocBuilder<PassengerHistoryInteractionBloc, PassengerHistoryInteractionState>(
                        builder: (historyInteractionContext, historyInteractionState) {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  historyInteractionContext.read<PassengerHistoryInteractionBloc>().add(LoadPassengerHistoryInteraction());
                                },
                                child: const Icon(Icons.arrow_back),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                "My Rides",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<PassengerHistoryInteractionBloc, PassengerHistoryInteractionState>(
                  listener: (passengerHistoryContext, passengerHistoryState) {
                    if (passengerHistoryState is PassengerHistoryInteractionDefaultState) {
                      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                      
                      if (firebaseAuth.currentUser != null) {
                        
                        passengerHistoryContext.read<PassengerHistoryInteractionBloc>().add(InitializePassengerHistoryInteractionList(uuid: firebaseAuth.currentUser!.uid));
                      }
                    }
                  },
                  builder: (passengerHistoryContext, passengerHistoryState) {
                    if (passengerHistoryState is PassengerHistoryInteractionListLoaded) {
                      return const PassengerHistoryInteractionListLoadedWidget();
                    } else if (passengerHistoryState is PassengerHistoryInteractionDefaultState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: Lottie.asset('assets/loading_animation.json'),
                            ),
                            const Text("We are loading your ride histories. Please wait."),
                          ],
                        ),
                      );
                    } else if (passengerHistoryState is PassengerHistoryInteractionInitialized) {
                      return PassengerHistoryInteractionInitializedWidget();
                    } else if (passengerHistoryState is PassengerHistoryInteractionError) {
                      return Container();
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
