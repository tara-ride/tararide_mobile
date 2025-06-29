import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/user_profile/user_profile_bloc.dart';
import 'package:tararide_mobile/models/passenger.dart';

class PassengerProfile extends StatefulWidget {
  const PassengerProfile({super.key});

  @override
  State<StatefulWidget> createState() => PassengerProfileState();
}

class PassengerProfileState extends State<PassengerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UserProfileBloc()..add(UserProfileInitialize()),
        child: SafeArea(
          top: true,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: BlocConsumer<UserProfileBloc, UserProfileState>(
              listener: (userProfileContext, userProfileState) {
                if (userProfileState is UserProfileInitial) {
                  
                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                  
                  if (firebaseAuth.currentUser != null) {
                    
                    userProfileContext.read<UserProfileBloc>().add(LoadUserProfile(userId: firebaseAuth.currentUser!.uid));
                  } else {
                    userProfileContext.read<UserProfileBloc>().add(const DisplayUserProfileError(error: "Cannot fetch user id."));
                  }
                } else {
                  
                }
              },
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "User Profile",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                child: Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(blurRadius: 8, blurStyle: BlurStyle.outer, color: Colors.black, offset: Offset(0, 0), spreadRadius: 0),
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/New-York-City-Backgrounds-HD.jpg"),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        width: double.infinity,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [
                                            0.0,
                                            1.0
                                          ], colors: [
                                            Color.fromARGB(255, 0, 0, 0),
                                            Color.fromARGB(0, 0, 0, 0),
                                          ]),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                child: Container(
                                                  height: 90,
                                                  width: 90,
                                                  decoration: state.personalInformation.profilePicImage != null
                                                      ? BoxDecoration(
                                                          image: DecorationImage(
                                                            image: Image.network(state.personalInformation.profilePicImage!).image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          color: Colors.white,
                                                          borderRadius: const BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                        )
                                                      : const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                child: Container(
                                                  height: 70,
                                                  width: 200,
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${state.personalInformation.firstName} ${state.personalInformation.lastName}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        state.accountInformation.emailAddress,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              //   child: SizedBox(
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Expanded(
                              //           flex: 1,
                              //           child: AnimatedContainer(
                              //             height: 120,
                              //             width: 120,
                              //             duration: const Duration(seconds: 1),
                              //             decoration: const BoxDecoration(
                              //               color: Color.fromARGB(255, 234, 222, 255),
                              //               boxShadow: [
                              //                 BoxShadow(blurRadius: 2, blurStyle: BlurStyle.outer, color: Colors.black, offset: Offset(0, 0), spreadRadius: 0),
                              //               ],
                              //               borderRadius: BorderRadius.all(
                              //                 Radius.circular(10),
                              //               ),
                              //             ),
                              //             curve: Curves.easeInOut,
                              //             child: const Column(
                              //               mainAxisAlignment: MainAxisAlignment.end,
                              //               crossAxisAlignment: CrossAxisAlignment.center,
                              //               children: [
                              //                 Expanded(
                              //                     child: Center(
                              //                   child: Text(
                              //                     "100",
                              //                     textAlign: TextAlign.center,
                              //                     style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontWeight: FontWeight.bold,
                              //                       fontSize: 50,
                              //                     ),
                              //                   ),
                              //                 )),
                              //                 Padding(
                              //                   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              //                   child: Text(
                              //                     "Rides Completed",
                              //                     style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontWeight: FontWeight.bold,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         const SizedBox(
                              //           width: 10,
                              //         ),
                              //         Expanded(
                              //           flex: 1,
                              //           child: AnimatedContainer(
                              //             height: 120,
                              //             width: 120,
                              //             duration: const Duration(seconds: 1),
                              //             decoration: const BoxDecoration(
                              //               color: Color.fromARGB(255, 222, 255, 242),
                              //               boxShadow: [
                              //                 BoxShadow(blurRadius: 2, blurStyle: BlurStyle.outer, color: Colors.black, offset: Offset(0, 0), spreadRadius: 0),
                              //               ],
                              //               borderRadius: BorderRadius.all(
                              //                 Radius.circular(10),
                              //               ),
                              //             ),
                              //             curve: Curves.easeInOut,
                              //             child: const Column(
                              //               mainAxisAlignment: MainAxisAlignment.end,
                              //               crossAxisAlignment: CrossAxisAlignment.center,
                              //               children: [
                              //                 Expanded(
                              //                     child: Center(
                              //                   child: Text(
                              //                     "0.3",
                              //                     textAlign: TextAlign.center,
                              //                     style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontWeight: FontWeight.bold,
                              //                       fontSize: 50,
                              //                     ),
                              //                   ),
                              //                 )),
                              //                 Padding(
                              //                   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              //                   child: Text(
                              //                     "Distance Travelled (km)",
                              //                     style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontWeight: FontWeight.bold,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "Settings",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "My Account",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email: ${state.accountInformation.emailAddress}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Business Role: ${state.accountInformation.businessRole ?? 'N/A'}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Account Created: ${state.accountInformation.createdOn != null ? state.accountInformation.createdOn.toString() : 'N/A'}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      // Add more fields as needed
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "My Personal Data",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Card(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.badge, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          Text(
                                            "User ID: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              state.personalInformation.userId,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Name: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${state.personalInformation.firstName} ${state.personalInformation.middleName ?? ''} ${state.personalInformation.lastName}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.cake, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Birth Date: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Text(
                                            state.personalInformation.birthDate != null ? "${state.personalInformation.birthDate.toLocal()}".split(' ')[0] : 'N/A',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.wc, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Sex at Birth: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Text(
                                            state.personalInformation.sexAtBirth,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "My Contacts and Addresses",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                              Card(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.contact_mail, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Contact Name: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${state.personalInformation.firstName} ${state.personalInformation.lastName}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.email, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Email: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              state.contactInformation.emailAddress ?? 'N/A',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Mobile: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              state.contactInformation.mobileNumber ?? 'N/A',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.fingerprint, color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "UUID: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              state.contactInformation.uuid,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              try {
                                FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                firebaseAuth.signOut();
                                Navigator.pushNamed(
                                  context,
                                  '/login',
                                );
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(error.toString()),
                                  duration: const Duration(milliseconds: 500),
                                ));
                              }
                            },
                            child: const Text("Sign Out"),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  
                  return Container(
                    child: Center(
                      child: Text("Loading.. "),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
