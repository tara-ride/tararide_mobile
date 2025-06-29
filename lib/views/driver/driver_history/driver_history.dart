import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/driver_history/driver_history_bloc.dart';

import 'component_widgets/driver_history_details.dart';

class DriverHistory extends StatefulWidget {
  const DriverHistory({super.key});

  @override
  State<StatefulWidget> createState() => _DriverHistoryState();
}

class _DriverHistoryState extends State<DriverHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<DriverHistoryBloc>(
          create: (context) => DriverHistoryBloc()..add(DriverHistoryLoadList()),
          child: BlocConsumer<DriverHistoryBloc, DriverHistoryState>(
              builder: (driverHistoryContext, driverHistoryState) {
                if (driverHistoryState is DriverHistoryInitial) {
                  return Container();
                } else if (driverHistoryState is DriverHistoryListLoaded) {
                  if (driverHistoryState.rideInformationList.isNotEmpty) {
                    return Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.arrow_back),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "My Ride Histories",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              height: double.infinity,
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: driverHistoryState.rideInformationList.length,
                                itemBuilder: (itemContext, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      driverHistoryContext.read<DriverHistoryBloc>().add(DisplayDriverHistoryDetails(rideInformation: driverHistoryState.rideInformationList[index]));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 28,
                                                backgroundColor: Colors.blue.shade100,
                                                child: Icon(Icons.directions_car, color: Colors.blue.shade700, size: 32),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      driverHistoryState.rideInformationList[index].rideTitle,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      driverHistoryState.rideInformationList[index].rideDescription,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 120,
                              child: Lottie.asset('assets/loading_animation_2.json'),
                            ),
                            Text("Loading ride histories"),
                          ],
                        ),
                      ),
                    );
                  }
                } else if (driverHistoryState is DriverHistoryDetailsLoaded) {
                  return const DriverHistoryDetails();
                } else {
                  return const SizedBox(
                    child: Column(
                      children: [
                        Text(
                          "My Ride Histories",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  );
                }
              },
              listener: (driverHistoryContext, driverHistoryState) {}),
        ),
      ),
    );
  }
}
