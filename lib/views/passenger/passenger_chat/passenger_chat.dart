import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/chat_interaction/chat_interaction_bloc.dart';
import 'package:tararide_mobile/views/passenger/passenger_chat/component_widgets/passenger_chat_interaction.dart';
import 'package:tararide_mobile/views/passenger/passenger_chat/component_widgets/passenger_chat_interaction_list_loaded.dart';

class PassengerChat extends StatefulWidget {
  const PassengerChat({super.key});

  @override
  State<StatefulWidget> createState() => _PassengerChatState();
}

class _PassengerChatState extends State<PassengerChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ChatInteractionBloc>(
        create: (BuildContext chatInteractionContext) => ChatInteractionBloc()
          ..add(
            LoadChatInteraction(),
          ),
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
                            child: BlocBuilder<ChatInteractionBloc, ChatInteractionState>(builder: (chatInteractionContext, chatInteractionState) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      chatInteractionContext.read<ChatInteractionBloc>().add(LoadChatInteraction());
                                    },
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text(
                                    "My Messages",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            })),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<ChatInteractionBloc, ChatInteractionState>(
                      listener: (chatInteractionContext, chatInteractionState) async {
                        if (chatInteractionState is ChatInteractionDefaultState) {
                          FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                          print("KIMOCHINIZED");
                          if (firebaseAuth.currentUser != null) {
                            print("KIMOCHINIZATIONISM");
                            chatInteractionContext.read<ChatInteractionBloc>().add(InitializeChatInteractionList(uuid: firebaseAuth.currentUser!.uid));
                          }
                        }
                        if (chatInteractionState is ChatInteractionListLoaded) {
                          //print("HAYYS ${chatInteractionState.chatInformationList.first.chatId}");
                        }
                      },
                      builder: (chatInteractionContext, chatInteractionState) {
                        if (chatInteractionState is ChatInteractionDefaultState) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 250,
                                  width: double.infinity,
                                  child: Lottie.asset('assets/loading_animation.json'),
                                ),
                                const Text("We are loading the messages. Please wait."),
                              ],
                            ),
                          );
                        }
                        if (chatInteractionState is ChatInteractionListLoaded) {
                          return PassengerChatInteractionListLoadedWidget();
                        }
                        if (chatInteractionState is ChatInteractionInitialized) {
                          return Expanded(
                              child: PassengerChatInteraction(
                            chatInteraction: chatInteractionState.chatInteraction,
                          ));
                        }
                        return const Center(
                          child: Text("How are youn't"),
                        );
                      },
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
