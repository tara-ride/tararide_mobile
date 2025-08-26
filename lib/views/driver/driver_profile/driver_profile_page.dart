import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/user_profile/user_profile_bloc.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<StatefulWidget> createState() => DriverProfileState();
}

class DriverProfileState extends State<DriverProfile> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                  } else {}
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
                                            "Business Role: ${state.accountInformation.businessRole}",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Account Created: ${state.accountInformation.createdOn.toString()}",
                                            style: const TextStyle(fontSize: 14),
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
                                              const Text(
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
                                              const Text(
                                                "Name: ",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${state.personalInformation.firstName} ${state.personalInformation.middleName} ${state.personalInformation.lastName}",
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
                                                "${state.personalInformation.birthDate.toLocal()}".split(' ')[0],
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
                                                  state.contactInformation.emailAddress,
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
                                                  state.contactInformation.mobileNumber,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.directions_car, color: Colors.deepPurple),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Vehicle Model: ",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  state.contactInformation.vehicleModel ?? 'N/A',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.confirmation_number, color: Colors.deepPurple),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Plate Number: ",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  state.contactInformation.plateNumber ?? 'N/A',
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
                                          const SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(Icons.image, color: Colors.deepPurple),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Vehicle Image: ",
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                              state.contactInformation.vehicleImageUrl != null
                                                  ? Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: SizedBox(
                                                        width: 200,
                                                        height: 200,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: Image.network(
                                                            state.contactInformation.vehicleImageUrl!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const Text(
                                                      'N/A',
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(Icons.image, color: Colors.deepPurple),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Plate Image: ",
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                              state.contactInformation.plateImageUrl != null
                                                  ? Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 100,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: Image.network(
                                                            state.contactInformation.plateImageUrl!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const Text(
                                                      'N/A',
                                                      style: TextStyle(fontSize: 14),
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
                          ),
                        ),
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
                    return const SizedBox(
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
      ),
    );
  }
}
