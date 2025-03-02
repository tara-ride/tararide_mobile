import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/authenticate_firebase_user/authenticate_firebase_user_bloc.dart';
import 'package:tararide_mobile/bloc/determine_user_category/determine_user_category_bloc.dart';
import 'package:tararide_mobile/bloc/user_auth_availability/user_auth_availability_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TaraRide Login'),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticateFirebaseUserBloc>(
              create: (context) => AuthenticateFirebaseUserBloc()..add(AuthenticateFirebaseUserInitialize()),
            ),
            BlocProvider<UserAuthAvailabilityBloc>(
              create: (userAuthAvailabilityContext) => UserAuthAvailabilityBloc()..add(UserAuthAvailabilityCheck()),
            ),
            BlocProvider<DetermineUserCategoryBloc>(
              create: (determineUserCategoryContext) => DetermineUserCategoryBloc()..add(DetermineUserCategoryCheck()),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BlocConsumer<AuthenticateFirebaseUserBloc, AuthenticateFirebaseUserState>(
                        listener: (context, state) {
                          if (state is AuthenticateFirebaseUserSuccess) {
                            Navigator.pushNamed(context, '/driver_home');
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthenticateFirebaseUserInitial) {
                            return SizedBox(
                              height: 300,
                              child: Lottie.asset('assets/login_hero_animation.json'),
                            );
                          } else if (state is AuthenticateFirebaseUserSuccess) {
                            return Column(
                              children: [
                                Lottie.asset('assets/lottie/success.json'),
                                const Text('Login successful'),
                              ],
                            );
                          } else if (state is AuthenticateFirebaseUserLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is AuthenticateFirebaseUserFailure) {
                            return Text(state.message);
                          } else if (state is AuthenticateFirebaseUserError) {
                            return Text(state.message);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Please enter your email, e.g. jose.rizal@gmail.com',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Please enter your password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      //forgot password
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final TextEditingController _resetEmailController = TextEditingController();
                                  return AlertDialog(
                                    title: const Text('Reset Password'),
                                    content: TextField(
                                      controller: _resetEmailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter your email',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // Perform reset password action
                                          print('Reset email: ${_resetEmailController.text}');
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Reset'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AuthenticateFirebaseUserBloc, AuthenticateFirebaseUserState>(
                        builder: (context, state) {
                          if (state is AuthenticateFirebaseUserInitial) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthenticateFirebaseUserBloc>(context).add(
                                        AuthenticateFirebaseUserLoad(
                                          _emailController.text,
                                          _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                              ),
                            );
                          } else if (state is AuthenticateFirebaseUserSuccess) {
                            return const SizedBox.shrink();
                          } else if (state is AuthenticateFirebaseUserLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is AuthenticateFirebaseUserFailure) {
                            return Text(state.message);
                          } else if (state is AuthenticateFirebaseUserError) {
                            return Text(state.message);
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthenticateFirebaseUserBloc>().add(
                                          AuthenticateFirebaseUserLoad(
                                            _emailController.text,
                                            _passwordController.text,
                                          ),
                                        );
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}
