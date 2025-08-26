import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/chat_interaction/chat_interaction_bloc.dart';

class DriverChatInteractionListLoadedWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DriverChatInteractionListLoadedState();
}

class _DriverChatInteractionListLoadedState extends State<DriverChatInteractionListLoadedWidget> {
  Future<Map<String, dynamic>> getPersonalData(String uuid) async {
    var firebaseAuthCurrentUser = FirebaseAuth.instance.currentUser;
    //personal information
    String firstName = "N/A";
    String lastName = "N/A";
    String profilePicImage = "N/A";

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference personalInfoDocument = firebaseFirestore.collection("personal_information").doc(uuid);

    var personalInfoData = await personalInfoDocument.get();
    if (personalInfoData.exists) {
      final data = personalInfoData.data() as Map<String, dynamic>;
      firstName = data["first_name"];
      lastName = data["last_name"];
      profilePicImage = data["profilePicImage"];
    }
    return {
      "profile_image_url": profilePicImage,
      "first_name": firstName,
      "last_name": lastName,
    };
  }

  @override
  Widget build(BuildContext context) {
    ChatInteractionListLoaded chatInteractionState = context.watch<ChatInteractionBloc>().state as ChatInteractionListLoaded;

    return Expanded(
      child: ListView.builder(
          itemCount: chatInteractionState.chatInformationList.length,
          itemBuilder: (buildContext, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  context.read<ChatInteractionBloc>().add(InitializeChatInteraction(chatId: chatInteractionState.chatInformationList[index].chatId));
                  ScaffoldMessenger.of(context).showSnackBar(
                      snackBarAnimationStyle: AnimationStyle(
                          curve: Curves.easeInOut,
                          duration: const Duration(
                            milliseconds: 400,
                          )),
                      const SnackBar(
                        content: Text(
                          "Loading chat messages..",
                        ),
                        duration: Duration(milliseconds: 50),
                      ));
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color.fromARGB(94, 0, 0, 0), blurRadius: 1, spreadRadius: 2),
                    ],
                  ),
                  child: FutureBuilder(
                      future: getPersonalData(chatInteractionState.chatInformationList[index].passengerId),
                      builder: (buildContext, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              FutureBuilder(
                                  future: getPersonalData(chatInteractionState.chatInformationList[index].passengerId),
                                  builder: (buildContext, snapshot) {
                                    if (snapshot.hasData && snapshot.data!["profile_image_url"] != "N/A") {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(snapshot.data!["profile_image_url"]),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          width: 80,
                                          height: 80,
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/profile_icon_empty.png"))),
                                          width: 80,
                                          height: 80,
                                        ),
                                      );
                                    }
                                  }),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 10),
                              //   child: Container(
                              //     decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/profile_icon_empty.png"))),
                              //     width: 80,
                              //     height: 80,
                              //   ),
                              // ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5, top: 5),
                                      child: Text(
                                        "${snapshot.data!["first_name"]} ${snapshot.data!["last_name"]}",
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5, top: 5),
                                      child: Text(
                                        chatInteractionState.chatInformationList[index].chatInteraction.last.messageText,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5, top: 5),
                                      child: Text(
                                        "Messaged On: ${chatInteractionState.chatInformationList[index].chatInteraction.last.messagedOn}",
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
            );
          }),
    );
  }
}
