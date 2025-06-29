import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/driver_history/driver_history_bloc.dart';
import 'package:tararide_mobile/models/personal_information.dart';

import '../../../../models/feedback_information.dart';

class DriverHistoryDetails extends StatefulWidget {
  const DriverHistoryDetails({super.key});

  @override
  State<StatefulWidget> createState() => _DriverHistoryDetailsState();
}

class _DriverHistoryDetailsState extends State<DriverHistoryDetails> {
  // get details
  //get feedbacks

  Future<PersonalInformationModel> getPersonalInformation(String passengerId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> personalInfo = await firebaseFirestore.collection("personal_information").doc(passengerId).get();
    if (personalInfo.exists && personalInfo.data() != null) {
      return PersonalInformationModel.fromJson(personalInfo.data()!);
    } else {
      throw Exception('Personal information not found for passengerId: $passengerId');
    }
  }

  Future<List<FeedbackInformation>> getFeedbackList(String rideId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List<FeedbackInformation> feedbackList = [];
    QuerySnapshot<Map<String, dynamic>> feedbackData = await firebaseFirestore.collection("feedback_information").where("ride_id", isEqualTo: rideId).get();
    if (feedbackData.docs.isNotEmpty) {
      print("sagot ka naman jannn ${feedbackData.docs.length}");
    }

    // feedbackData to feedbackList mapping
    for (var doc in feedbackData.docs) {
      final data = doc.data();
      print(data);
      feedbackList.add(
        FeedbackInformation(
          feedbackId: data['feedback_id'] ?? 'N/A',
          rideId: data['ride_id'] ?? '',
          passengerId: data['passenger_id'] ?? '',
            feedbackRating: data["feedback_rating"] is int
              ? data["feedback_rating"]
              : int.tryParse(data["feedback_rating"]?.toString() ?? "0") ?? 0,
          feedbackComment: data['feedback_comment'] ?? '',
          feedbackSubmittedOn: DateTime.now(),
          // Add any other fields present in FeedbackInformation and in Firestore
        ),
      );
    }
    print("feedbackData.docs.length: ${feedbackData.docs.length}");
    print("feedbackList.length: ${feedbackList.length}");
    // for (var doc in feedbackData.docs) {
    //   print("doc data: ${doc.data()}");
    // }
    return feedbackList;
  }

  @override
  Widget build(BuildContext context) {
    DriverHistoryDetailsLoaded driverHistoryDetailsLoaded = context.watch<DriverHistoryBloc>().state as DriverHistoryDetailsLoaded;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Ride Information Details
              Card(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Driver Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Name: ${driverHistoryDetailsLoaded.rideInformationList.driverName}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.badge, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'ID: ${driverHistoryDetailsLoaded.rideInformationList.driverId}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.email, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Email: ${driverHistoryDetailsLoaded.rideInformationList.driverEmail}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Ride Information Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ride Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.confirmation_number, color: Colors.purple),
                          const SizedBox(width: 8),
                          Text(
                            'Ride ID: ${driverHistoryDetailsLoaded.rideInformationList.rideId}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.title, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(
                            'Title: ${driverHistoryDetailsLoaded.rideInformationList.rideTitle}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.description, color: Colors.teal),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Description: ${driverHistoryDetailsLoaded.rideInformationList.rideDescription}',
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            'Cost: ₱${driverHistoryDetailsLoaded.rideInformationList.rideCost.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Earnings: ₱${driverHistoryDetailsLoaded.rideInformationList.rideEarnings.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.event_seat, color: Colors.deepPurple),
                      //     const SizedBox(width: 8),
                      //     Text(
                      //       'Seats Allocated: ${driverHistoryDetailsLoaded.rideInformationList.seatsAllocated}',
                      //       style: const TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      // ),
                      //const SizedBox(height: 8),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.people, color: Colors.blue),
                      //     const SizedBox(width: 8),
                      //     Text(
                      //       'Passengers Served: ${driverHistoryDetailsLoaded.rideInformationList.passengersServed}',
                      //       style: const TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Status: ${driverHistoryDetailsLoaded.rideInformationList.status}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, color: Colors.indigo),
                          const SizedBox(width: 8),
                          Text(
                            'Car Type: ${driverHistoryDetailsLoaded.rideInformationList.carType}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.category, color: Colors.brown),
                          const SizedBox(width: 8),
                          Text(
                            'Ride Type: ${driverHistoryDetailsLoaded.rideInformationList.rideType}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //Feedbacks

              Container(
                height: 600,
                child: FutureBuilder(
                    future: getFeedbackList(driverHistoryDetailsLoaded.rideInformationList.rideId),
                    builder: (buildContext, snapshot) {
                      // HEY HEY
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (itemContext, index) {
                            final feedback = snapshot.data![index];
                            return FutureBuilder<PersonalInformationModel>(
                              future: getPersonalInformation(feedback.passengerId),
                              builder: (context, passengerSnapshot) {
                                if (passengerSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                if (passengerSnapshot.hasError || !passengerSnapshot.hasData) {
                                  print(passengerSnapshot.error.toString());
                                  return SizedBox.shrink();
                                }
                                final passenger = passengerSnapshot.data!;
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.blue.shade100,
                                              child: Icon(Icons.person, color: Colors.blue.shade700),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                '${passenger.firstName} ${passenger.lastName}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(
                                                5,
                                                (star) => Icon(
                                                  star < feedback.feedbackRating ? Icons.star : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          feedback.feedbackComment,
                                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${feedback.feedbackSubmittedOn}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                      return Container(
                        child: Text("No way"),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
