import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:tararide_mobile/bloc/check_account_information/check_account_information_bloc.dart';
import 'package:tararide_mobile/bloc/check_contact_information/check_contact_information_bloc.dart';
import 'package:tararide_mobile/bloc/check_personal_information/check_personal_information_bloc.dart';
import 'package:tararide_mobile/bloc/user_sign_up/user_sign_up_bloc.dart';
import 'package:tararide_mobile/cubit/sign_up_accessibility/sign_up_accessibility_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

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
  final _formKey = GlobalKey<FormState>();

  List<bool> validationList = [false, false, false, false, false, false, false, false];
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
              listener: (context, state) {
                if (state is UserSignUpError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
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
                                      Text("Account Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                                      labelText: 'E-mail Address (Login Credential)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    validator: (value) {
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Password (8 - 50 characters, with special characters, numbers, and symbol)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _retypePasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Re-type Password',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Personal Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
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
                                  const SizedBox(height: 20),
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
                                    decoration: const InputDecoration(
                                      labelText: 'E-mail Address (Contact)',
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
                          onPressed: () {
                            try {
                              if (_formKey.currentState!.validate()) {
                                userSignUpContext.read<UserSignUpBloc>().add(SignUpUser(_emailController.text, _passwordController.text));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please fill up the fields correctly. "),
                                  ),
                                );
                              }
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
