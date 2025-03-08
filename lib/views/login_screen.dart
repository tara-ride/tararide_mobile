import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/authenticate_firebase_user/authenticate_firebase_user_bloc.dart';
import 'package:tararide_mobile/bloc/determine_user_category/determine_user_category_bloc.dart';
import 'package:tararide_mobile/bloc/user_auth_availability/user_auth_availability_bloc.dart';
import 'package:tararide_mobile/cubit/password_visibility/password_visibility_cubit.dart';

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
            BlocProvider<PasswordVisibilityCubit>(
              create: (passwordVisibilityContext) => PasswordVisibilityCubit()..toggleVisibility(false),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Welcome to Tararide, ${state.user.displayName}!"),
                              ),
                            );
                            Navigator.pop(context);
                          } else if (state is AuthenticateFirebaseUserFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                              ),
                            );
                          } else if (state is AuthenticateFirebaseUserError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                              ),
                            );
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
                            return SizedBox(
                              height: 300,
                              child: Lottie.asset('assets/loading_animation.json'),
                            );
                          } else if (state is AuthenticateFirebaseUserFailure) {
                            return SizedBox(
                              height: 300,
                              child: Lottie.asset('assets/error_animation.json'),
                            );
                          } else if (state is AuthenticateFirebaseUserError) {
                            return SizedBox(
                              height: 300,
                              child: Lottie.asset('assets/error_animation.json'),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
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
                      BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityCubitState>(
                        builder: (context, state) {
                          if (state is PasswordVisibilityActivate) {
                            return TextFormField(
                              controller: _passwordController,
                              obscureText: false,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    context.read<PasswordVisibilityCubit>().toggleVisibility(false);
                                  },
                                  child: const Icon(Icons.visibility_off),
                                ),
                                labelText: 'Please enter your password',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            );
                          } else {
                            return TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    context.read<PasswordVisibilityCubit>().toggleVisibility(true);
                                  },
                                  child: const Icon(Icons.visibility),
                                ),
                                labelText: 'Please enter your password',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            );
                          }
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
                                    content: Form(
                                        child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                      controller: _resetEmailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter your email',
                                        border: OutlineInputBorder(),
                                      ),
                                    )),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          // Perform reset password action
                                          if (_resetEmailController.text.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please enter your email'),
                                              ),
                                            );
                                            return;
                                          } else if (!_resetEmailController.text.contains('@')) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please enter a valid email'),
                                              ),
                                            );
                                            return;
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Sending password reset email...'),
                                              ),
                                            );
                                            try {
                                              await FirebaseAuth.instance.sendPasswordResetEmail(email: _resetEmailController.text);
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("An error occurred. Please contact support."),
                                                ),
                                              );
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Password reset email sent!'),
                                              ),
                                            );
                                            print('Reset email: ${_resetEmailController.text}');
                                            Navigator.of(context).pop();
                                          }
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Logging in...'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                              ),
                            );
                          } else {
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
                          }
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
