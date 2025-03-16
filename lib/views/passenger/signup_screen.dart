import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:tararide_mobile/bloc/check_account_information/check_account_information_bloc.dart';
import 'package:tararide_mobile/bloc/check_contact_information/check_contact_information_bloc.dart';
import 'package:tararide_mobile/bloc/check_personal_information/check_personal_information_bloc.dart';
import 'package:tararide_mobile/bloc/user_sign_up/user_sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  // XFile? _imageFile;

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
          ],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: [
                          // Hero Animations
                          BlocBuilder<UserSignUpBloc, UserSignUpState>(builder: (userSignUpContext, state) {
                            if (state is UserSignUpInitial) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: Lottie.asset('assets/signup_hero_animation.json'),
                                  ),
                                  const Text("Sign up now and let's get on to your journey!", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              );
                            } else if (state is UserSignUpLoading) {
                              return Lottie.asset('assets/loading_animation.json', height: 200);
                            } else if (state is UserSignUpSuccess) {
                              return Lottie.asset('assets/success.json', height: 200);
                            } else if (state is UserSignUpError) {
                              return Lottie.asset('assets/error_animation.json', height: 200);
                            } else {
                              return const SizedBox(height: 200);
                            }
                          }),
                          // GestureDetector(
                          //   onTap: () async {
                          //     final ImagePicker _picker = ImagePicker();
                          //     final XFile? image = await showDialog<XFile>(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           title: Text('Choose an option'),
                          //           content: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               ListTile(
                          //                 leading: Icon(Icons.camera_alt),
                          //                 title: Text('Take a selfie'),
                          //                 onTap: () async {
                          //                   final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                          //                   Navigator.pop(context, photo);
                          //                 },
                          //               ),
                          //               ListTile(
                          //                 leading: Icon(Icons.photo_library),
                          //                 title: Text('Open gallery'),
                          //                 onTap: () async {
                          //                   final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                          //                   Navigator.pop(context, photo);
                          //                 },
                          //               ),
                          //             ],
                          //           ),
                          //         );
                          //       },
                          //     );

                          //     if (image != null) {
                          //       setState(() {
                          //         _imageFile = image;
                          //       });
                          //     }
                          //   },
                          //   child: CircleAvatar(
                          //     radius: 50,
                          //     backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                          //     child: _imageFile == null ? Icon(Icons.person, size: 50) : null,
                          //   ),
                          // ),
                          const SizedBox(height: 20),
                          BlocConsumer<CheckAccountInformationBloc, CheckAccountInformationState>(
                            listener: (context, state) {},
                            builder: (checkAccountInformationBuildContext, checkAccountInformationState) {
                              if (checkAccountInformationState is CheckAccountInformationInitial) {
                                return Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Account Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'E-mail Address (Login Credential)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                                          return 'Password must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number';
                                        } else if (value.length > 50) {
                                          return 'Password must be at most 50 characters long';
                                        } else if (value.length < 8) {
                                          return 'Password must be at least 8 characters long';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _retypePasswordController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please re-type your password';
                                        } else if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Re-type Password',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (checkAccountInformationState is CheckAccountInformationLoading) {
                                return Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Checking account information..",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                );
                              } else if (checkAccountInformationState is CheckAccountInformationSuccess) {
                                return Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: Colors.green[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Account Information is valid",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 29, 83, 30),
                                    ),
                                  ),
                                );
                              } else if (checkAccountInformationState is CheckAccountInformationFailure) {
                                return Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: const Color.fromARGB(255, 255, 173, 173),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Personal Information is invalid",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 83, 29, 29),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),

                          const SizedBox(height: 20),
                          BlocConsumer<CheckPersonalInformationBloc, CheckPersonalInformationState>(listener: (checkPersonalInformationListenerContext, checkPersonalInformationState) {
                            if (checkPersonalInformationState is CheckPersonalInformationSuccess) {
                              print("Personal Information Success");
                            }
                          }, builder: (checkPersonalInformationBuildContext, checkPersonalInformationState) {
                            if (checkPersonalInformationState is CheckPersonalInformationFailure) {
                              return Text(checkPersonalInformationState.error, style: const TextStyle(color: Colors.red));
                            }
                            return const SizedBox.shrink();
                          }),
                          BlocBuilder<CheckPersonalInformationBloc, CheckPersonalInformationState>(builder: (checkPersonalInformationContext, state) {
                            if (state is CheckPersonalInformationInitial) {
                              return Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Personal Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _firstNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      } else if (value.length < 2) {
                                        return 'First name must be at least 2 characters long';
                                      } else if (value.length > 50) {
                                        return 'First name must be at most 50 characters long';
                                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                                        return 'First name must contain only letters';
                                      }
                                      return null;
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
                                        });
                                      }
                                    },
                                    controller: _birthDateController,
                                  ),
                                ],
                              );
                            } else if (state is CheckPersonalInformationLoading) {
                              return Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 60,
                                decoration: ShapeDecoration(
                                  color: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Checking personal information..",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              );
                            } else if (state is CheckPersonalInformationSuccess) {
                              return Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 60,
                                decoration: ShapeDecoration(
                                  color: Colors.green[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Personal Information is valid",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 29, 83, 30),
                                  ),
                                ),
                              );
                            } else if (state is CheckPersonalInformationFailure) {
                              return Text(state.error, style: const TextStyle(color: Colors.red));
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          const SizedBox(height: 20),
                          BlocConsumer<CheckContactInformationBloc, CheckContactInformationState>(
                            listener: (context, state) {
                              if (state is CheckContactInformationSuccess) {
                                print("Contact Information Success");
                              }
                            },
                            builder: (checkContactInformationBuildContext, checkContactInformationState) {
                              // if (state is CheckContactInformationFailure) {
                              //   return Text(state.error, style: const TextStyle(color: Colors.red));
                              // }
                              if (checkContactInformationState is CheckContactInformationInitial) {
                                return Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Contact Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      readOnly: true,
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'E-mail Address',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _contactNumberController,
                                      decoration: const InputDecoration(
                                        labelText: 'Contact Number',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _homeAddressController,
                                      decoration: const InputDecoration(
                                        labelText: 'Home Address',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (checkContactInformationState is CheckContactInformationLoading) {
                                return Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Checking contact information..",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                );
                              } else if (checkContactInformationState is CheckContactInformationSuccess) {
                                return Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: Colors.green[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Contact Information is valid",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 29, 83, 30),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  //Sign Up Activity
                  MultiBlocListener(
                      listeners: [
                        BlocListener<CheckPersonalInformationBloc, CheckPersonalInformationState>(listener: (checkPersonalInformationContext, state) {}),
                        BlocListener<CheckContactInformationBloc, CheckContactInformationState>(listener: (checkContactInformationContext, state) {}),
                        BlocListener<CheckAccountInformationBloc, CheckAccountInformationState>(listener: (checkAccountInformationContext, state) {}),
                        BlocListener<UserSignUpBloc, UserSignUpState>(
                          listener: (userSignUpContext, state) {
                            if (state is UserSignUpLoading) {
                              BlocProvider.of<CheckPersonalInformationBloc>(userSignUpContext).add(CheckPersonalInformationSubmit(
                                _firstNameController.text,
                                _middleNameController.text,
                                _lastNameController.text,
                                _emailController.text,
                              ));

                              BlocProvider.of<CheckContactInformationBloc>(userSignUpContext).add(CheckContactInformation());
                              BlocProvider.of<CheckAccountInformationBloc>(userSignUpContext).add(CheckAccountInformation(_emailController.text, _passwordController.text));
                            }
                          },
                        ),
                      ],
                      child: BlocBuilder<UserSignUpBloc, UserSignUpState>(
                        builder: (userSignUpContext, userSignUpState) {
                          if (userSignUpState is UserSignUpInitial) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 250,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      try {
                                        print("work here");
                                        
                                        //userSignUpContext.read<UserSignUpBloc>().add(SignUpUser(_emailController.text, _passwordController.text));
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: const Text('Sign Up'),
                                  ),
                                ),
                              ],
                            );
                          } else if (userSignUpState is UserSignUpLoading) {
                            return const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Signing up.."),
                                CircularProgressIndicator(),
                              ],
                            );
                          } else if (userSignUpState is UserSignUpSuccess) {
                            return Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Go back to login'),
                                ),
                              ],
                            );
                          } else if (userSignUpState is UserSignUpError) {
                            return Column(
                              children: [
                                // Text("Sign up failed: ${state}"),
                                ElevatedButton(
                                  onPressed: () {
                                    userSignUpContext.read<UserSignUpBloc>().add(SignUpAwaiting());
                                  },
                                  child: const Text('Try again'),
                                ),
                              ],
                            );
                          } else {
                            return const Text("Cannot perform sign up for now, please contact your administrators.");
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
