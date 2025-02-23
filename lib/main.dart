import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/determine_user_category/determine_user_category_bloc.dart';
import 'package:tararide_mobile/bloc/user_auth_availability/user_auth_availability_bloc.dart';
import 'package:tararide_mobile/config/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 48, 0, 158)),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
          providers: [
            BlocProvider<UserAuthAvailabilityBloc>(
              create: (BuildContext userAuthAvailabilityContext) => UserAuthAvailabilityBloc()
                ..add(
                  UserAuthInitilize(),
                ),
            ),
            BlocProvider<DetermineUserCategoryBloc>(create: (BuildContext determineUserCategoryBloc) => DetermineUserCategoryBloc()),
          ],
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.easeInOutCirc,
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: SizedBox(
                              height: 350,
                              width: 350,
                              child: Image.asset('assets/gemini_logo.jpeg'),
                            ),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<UserAuthAvailabilityBloc, UserAuthAvailabilityState>(
                      builder: (userAuthAvailabilityContext, state) {
                        // Add your widget building logic here based on the state
                        if (state is UserAuthAvailabilityInitial) {
                          Future.delayed(const Duration(seconds: 2), () {
                            userAuthAvailabilityContext.read<UserAuthAvailabilityBloc>().add(UserAuthAvailabilityCheck());
                          });
                          return const Text("Authentication checks running, please wait."); // Replace with your actual widget
                        } else if (state is UserAvailable) {
                          return const Text("User is Available!");
                        } else if (state is UserNotAvailable) {
                          return FutureBuilder<void>(
                            future: Future<void>.delayed(const Duration(seconds: 2)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 10.0),
                                          const TextField(
                                            decoration: InputDecoration(
                                              labelText: 'E-mail Address',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          const TextField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.primary,
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              print("Hello");
                                            },
                                            child: const Text('Login'),
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextButton(
                                            onPressed: () {
                                              // Handle create account action
                                            },
                                            child: const Text('Create an account'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const Text("Redirecting to login page..");
                              }
                            },
                          );
                        } else {
                          return Container();
                        }
                        // Replace with your actual widget
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
