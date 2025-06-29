import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:tararide_mobile/bloc/check_account_information/check_account_information_bloc.dart';
import 'package:tararide_mobile/bloc/check_contact_information/check_contact_information_bloc.dart';
import 'package:tararide_mobile/bloc/check_personal_information/check_personal_information_bloc.dart';
import 'package:tararide_mobile/bloc/profile_picture_upload/profile_picture_upload_bloc.dart';
import 'package:tararide_mobile/bloc/user_sign_up/user_sign_up_bloc.dart';
import 'package:tararide_mobile/cubit/sign_up_accessibility/sign_up_accessibility_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

const List<String> genderList = ["Male", "Female"];

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  DateTime birthDate = DateTime.now();
  String sexAtBirth = genderList.first;
  Uint8List? rawFileData;
  XFile? imageCrossFile;
  File? imageFile;

  bool profilePictureUploaded = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _homeAddressController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<UserSignUpBloc>(
              create: (userSignUpBlocContext) => UserSignUpBloc()..add(SignUpAwaiting()),
            ),
            BlocProvider<CheckPersonalInformationBloc>(
              create: (checkPersonalInformationBlocContext) => CheckPersonalInformationBloc()..add(CheckPersonalInformationAwaiting()),
            ),
            BlocProvider<CheckAccountInformationBloc>(
              create: (checkAccountInformationContext) => CheckAccountInformationBloc()..add(CheckAccountInformationAwaiting()),
            ),
            BlocProvider<CheckContactInformationBloc>(
              create: (checkContactInformationContext) => CheckContactInformationBloc()..add(CheckContactInformationAwaiting()),
            ),
            BlocProvider<ProfilePictureUploadBloc>(create: (profilePictureUploadContext) => ProfilePictureUploadBloc()..add(ProfilePictureUploadInitialize())),
            BlocProvider<SignUpAccessibilityCubit>(
              create: (context) => SignUpAccessibilityCubit(),
            )
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: BlocConsumer<UserSignUpBloc, UserSignUpState>(
              listener: (userSignUpContext, userSignUpState) {
                if (userSignUpState is UserSignUpSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sign up successful!"),
                    ),
                  );
                }
                if (userSignUpState is UserSignUpError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(userSignUpState.message),
                    ),
                  );
                }
              },
              builder: (userSignUpContext, userSignUpState) {
                if (userSignUpState is UserSignUpInitial) {
                  return Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          // decoration: BoxDecoration(
                          //   color: Colors.green[100],
                          // ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: Lottie.asset('assets/signup_hero_animation.json'),
                                  ),
                                  const Text("Sign up now and let's get on to your journey!", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Personal Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  BlocConsumer<ProfilePictureUploadBloc, ProfilePictureUploadState>(listener: (profilePictureUploadContext, profilePictureUploadState) async {
                                    if (profilePictureUploadState is ProfilePictureUploadSuccess) {
                                      profilePictureUploaded = true;
                                      imageCrossFile = profilePictureUploadState.validatedImage;
                                      rawFileData = await profilePictureUploadState.validatedImage!.readAsBytes();
                                      if (rawFileData != null) {}
                                      imageFile = File.fromRawPath(await profilePictureUploadState.validatedImage!.readAsBytes());
                                    }

                                    if (profilePictureUploadState is ProfilePictureUploadFailure) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(profilePictureUploadState.errorList[0])));
                                      await Future.delayed(const Duration(seconds: 2));
                                      profilePictureUploadContext.read<ProfilePictureUploadBloc>().add(ProfilePictureUploadInitialize());
                                    }
                                  }, builder: (profilePictureUploadContext, profilePictureUploadState) {
                                    if (profilePictureUploadState is ProfilePictureUploadAwaiting) {
                                      return SizedBox(
                                        height: 180,
                                        width: double.infinity,
                                        child: Card(
                                          elevation: 10,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text("Upload a photo of you."),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              OutlinedButton(
                                                onPressed: () async {
                                                  try {
                                                    XFile? profilePicRawData = await _imagePicker.pickImage(source: ImageSource.camera);
                                                    profilePictureUploadContext.read<ProfilePictureUploadBloc>().add(ProfilePictureUploadValidate(file: profilePicRawData));
                                                  } catch (error) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                                    profilePictureUploadContext.read<ProfilePictureUploadBloc>().add(ProfilePictureUploadInitialize());
                                                  }
                                                },
                                                child: const Text("Capture from Camera"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else if (profilePictureUploadState is ProfilePictureUploadSuccess) {
                                      return SizedBox(
                                        height: 180,
                                        width: double.infinity,
                                        child: Card(
                                          elevation: 10,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: SizedBox(
                                                  height: 150,
                                                  width: 150,
                                                  child: FutureBuilder<Uint8List>(
                                                      future: profilePictureUploadState.validatedImage!.readAsBytes(),
                                                      builder: ((validatedImageContext, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return ClipRRect(
                                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                            child: Image.memory(
                                                              snapshot.data!,
                                                              alignment: Alignment.center,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          );
                                                        } else {
                                                          return SizedBox.shrink();
                                                        }
                                                      })),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("File size: ${(profilePictureUploadState.imageFileSize / (1048 * 1048)).toStringAsFixed(2)} MB"),
                                                        Text("Date created: ${DateFormat.yMd().add_jm().format(profilePictureUploadState.imageLastModifiedDate)}"),
                                                      ],
                                                    )),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: OutlinedButton(
                                                        onPressed: () async {
                                                          try {
                                                            XFile? profilePicRawData = await _imagePicker.pickImage(source: ImageSource.camera);

                                                            profilePictureUploadContext.read<ProfilePictureUploadBloc>().add(ProfilePictureUploadValidate(file: profilePicRawData));
                                                          } catch (error) {
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                                            profilePictureUploadContext.read<ProfilePictureUploadBloc>().add(ProfilePictureUploadInitialize());
                                                          }
                                                        },
                                                        child: const Text("Reupload Photo"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else if (profilePictureUploadState is ProfilePictureUploadFailure) {
                                      return const SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Card(
                                          elevation: 10,
                                          child: Center(
                                            child: Text(
                                              "Upload failed. Retry in a few seconds.",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Card(
                                          elevation: 10,
                                          child: Center(
                                            child: Text(
                                              "Something went wrong. Please contact Tararide Service Desk.",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _firstNameController,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      } else if (value.length < 2) {
                                        return 'First name must be at least 2 characters long';
                                      } else if (value.length > 50) {
                                        return 'First name must be at most 50 characters long';
                                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                                        return 'First name must contain only letters';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _middleNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Middle Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _lastNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name';
                                      } else if (value.length < 2) {
                                        return 'Last name must be at least 2 characters long';
                                      } else if (value.length > 50) {
                                        return 'Last name must be at most 50 characters long';
                                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                                        return 'Last name must contain only letters';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Last Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: const Color.fromARGB(255, 112, 80, 117)),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(color: Colors.black45, blurRadius: 2),
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Text("Sex at birth: "),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          DropdownButton<String>(
                                              value: sexAtBirth,
                                              icon: const Icon(Icons.arrow_downward),
                                              elevation: 16,
                                              items: genderList.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(value: value, child: Text(value));
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  sexAtBirth = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Birth Date',
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          _birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                          birthDate = pickedDate;
                                        });
                                      }
                                    },
                                    controller: _birthDateController,
                                  ),
                                  const SizedBox(height: 20),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Contact Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _emailController,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'E-mail Address (Contact)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _contactNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Contact Number',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your home address';
                                      } else {
                                        return null;
                                      }
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _homeAddressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Home Address',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Account Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: true,
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'E-mail Address (Login Credential)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _passwordController,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password cannot be empty.";
                                      } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                                        return "";
                                      } else if (value.length > 50) {
                                        return "Password must be at most 50 characters long";
                                      } else if (value.length < 8) {
                                        return "Password must be at least 8 characters long";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Password (8 - 50 characters, with special characters, numbers, and symbol)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _retypePasswordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password cannot be empty.";
                                      } else if (value.length != _retypePasswordController.text.length && value != _retypePasswordController.text) {
                                        return "Passwords do not match. Please retry.";
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Re-type Password',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              if (_formKey.currentState!.validate() && profilePictureUploaded) {
                                String downloadUrl = "";
                                if (imageFile != null) {
                                  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

                                  String fileName = "passenger_profile_pic_${DateTime.now().millisecondsSinceEpoch}";
                                  Reference storageRef = firebaseStorage.ref().child("profilePictures/$fileName");

                                  UploadTask uploadTask = storageRef.putData(rawFileData!);
                                  TaskSnapshot snapshot = await uploadTask;
                                  downloadUrl = await snapshot.ref.getDownloadURL();
                                }
                                userSignUpContext.read<UserSignUpBloc>().add(SignUpUser(
                                    profilePictureImageUrl: downloadUrl,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    firstName: _firstNameController.text,
                                    middleName: _middleNameController.text.isEmpty ? "N/A" : _middleNameController.text,
                                    lastName: _lastNameController.text,
                                    sexAtBirth: sexAtBirth,
                                    birthDate: birthDate,
                                    contactNo: _contactNumberController.text,
                                    homeAddress: _homeAddressController.text));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please fill up the fields correctly. "),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              userSignUpContext.read<UserSignUpBloc>().add(SignUpAwaiting());
                            }
                          },
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  );
                } else if (userSignUpState is UserSignUpLoading) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 350,
                          width: double.infinity,
                          child: Lottie.asset('assets/loading_animation.json', height: 200),
                        ),
                        const Text("We are working on your profile, please wait.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                } else if (userSignUpState is UserSignUpError) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 350,
                          width: double.infinity,
                          child: Lottie.asset('assets/error_animation.json', height: 200),
                        ),
                        const Text("An error occurred during the process.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            userSignUpContext.read<UserSignUpBloc>().add(SignUpAwaiting());
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                } else if (userSignUpState is UserSignUpSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 350,
                          width: double.infinity,
                          child: Lottie.asset('assets/success.json', height: 200),
                        ),
                        const Text("You have successfully signed up!", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Go back to login"),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
  }
}
