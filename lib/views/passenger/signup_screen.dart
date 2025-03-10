import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:tararide_mobile/bloc/bloc/check_account_information/check_account_information_bloc.dart';
import 'package:tararide_mobile/bloc/bloc/check_contact_information/check_contact_information_bloc.dart';
import 'package:tararide_mobile/bloc/bloc/check_personal_information/check_personal_information_bloc.dart';
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
          title: Text('Sign Up'),
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
                              width: double.infinity,
                              height: 90,
                              decoration: ShapeDecoration(
                                color: Colors.grey[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } else if (state is CheckPersonalInformationSuccess) {
                            return const SizedBox.shrink();
                          } else if (state is CheckPersonalInformationFailure) {
                            return Text(state.error, style: TextStyle(color: Colors.red));
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                        const SizedBox(height: 30),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contact Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Account Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  )),
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
                            }
                          },
                        ),
                      ],
                      child: BlocBuilder<UserSignUpBloc, UserSignUpState>(
                        builder: (userSignUpContext, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () {
                                    try {
                                      userSignUpContext.read<UserSignUpBloc>().add(SignUpUser(_emailController.text, _passwordController.text));
                                    } catch (e) {
                                      print(e);
                                    }

                                    // if (_formKey.current.State!.validate()) {
                                    //   // Perform sign up action
                                    //   print('First Name: ${_firstNameController.text}');
                                    //   print('Middle Name: ${_middleNameController.text}');
                                    //   print('Last Name: ${_lastNameController.text}');

                                    //   print('Email: ${_emailController.text}');
                                    //   print('Contact Number: ${_contactNumberController.text}');
                                    //   print('Home Address: ${_homeAddressController.text}');
                                    //   print('Password: ${_passwordController.text}');
                                    //   print('Retype Password: ${_retypePasswordController.text}');
                                    // }
                                  },
                                  child: const Text('Sign Up'),
                                ),
                              ),
                            ],
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
