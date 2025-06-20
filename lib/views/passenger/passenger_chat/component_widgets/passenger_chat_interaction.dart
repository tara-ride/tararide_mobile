import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/chat_interaction_data.dart';

class PassengerChatInteraction extends StatefulWidget {
  final ChatInteractionData chatInteraction;
  const PassengerChatInteraction({super.key, required this.chatInteraction});
  @override
  State<StatefulWidget> createState() => _PassengerChatInteraction();
}

Future<Map<String, dynamic>> getPersonalData(String uuid) async {
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

class _PassengerChatInteraction extends State<PassengerChatInteraction> {
  TextEditingController typeChat = TextEditingController();
  var userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    print("MY USER ID: $userId");
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 249, 242, 255),
                ),
                child: ListView.builder(
                    itemCount: widget.chatInteraction.chatInteraction.length,
                    itemBuilder: (itemContext, index) {
                      return SizedBox(
                          width: 120,
                          child: userId == widget.chatInteraction.chatInteraction[index].messagedBy
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            color: Colors.white,
                                            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 0.5, spreadRadius: 0.5)]),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                              child: FutureBuilder(
                                                  future: getPersonalData(widget.chatInteraction.chatInteraction[index].messagedBy),
                                                  builder: (buildContext, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        "${snapshot.data!["first_name"]} ${snapshot.data!["last_name"]}",
                                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                      );
                                                    } else {
                                                      return const Text(
                                                        "...",
                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                      );
                                                    }
                                                  }),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                                              child: Text(
                                                widget.chatInteraction.chatInteraction[index].messageText,
                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/profile_icon_empty.png"))),
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/profile_icon_empty.png"))),
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            color: Colors.white,
                                            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 0.5, spreadRadius: 0.5)]),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                              child: FutureBuilder(
                                                  future: getPersonalData(widget.chatInteraction.chatInteraction[index].messagedBy),
                                                  builder: (buildContext, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        "${snapshot.data!["first_name"]} ${snapshot.data!["last_name"]}",
                                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                      );
                                                    } else {
                                                      return const Text(
                                                        "...",
                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                      );
                                                    }
                                                  }),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                                              child: Text(
                                                "${widget.chatInteraction.chatInteraction[index].messageText}",
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                    }),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: typeChat,
                      decoration: const InputDecoration(
                        labelText: 'Please type your message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      if (typeChat.text.isNotEmpty) {
                        try {
                          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                          var documentReference = firebaseFirestore.collection("chat_information").doc(widget.chatInteraction.chatId);
                          await documentReference.update({
                            "chat_interaction": FieldValue.arrayUnion([
                              {
                                "message_text": typeChat.text,
                                "messaged_by": userId,
                                "messaged_on": DateTime.now(),
                              }
                            ]),
                          });
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Something went wrong, please try again later."),
                          ));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Your message is sent!"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please enter a message before sending.."),
                        ));
                      }
                    },
                    icon: const Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }
}
