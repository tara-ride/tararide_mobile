import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/driver_history/driver_history_bloc.dart';

class DriverHistory extends StatefulWidget {
  const DriverHistory({super.key});

  @override
  State<StatefulWidget> createState() => _DriverHistoryState();
}

class _DriverHistoryState extends State<DriverHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        const Row(
                          children: [
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
                                    print("TAPPP");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        color: Colors.white,
                                        boxShadow: [BoxShadow(color: Colors.black, spreadRadius: 1, blurRadius: 1)],
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            child: Text(driverHistoryState.rideInformationList[index].rideTitle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            child: Text(driverHistoryState.rideInformationList[index].rideTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal), maxLines: 3, overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
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
              } else {
                return Container(
                  child: Column(
                    children: [
                      Text(
                        "My Ride Histories",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                );
              }
            },
            listener: (driverHistoryContext, driverHistoryState) {}),
      ),
    );
  }
}
