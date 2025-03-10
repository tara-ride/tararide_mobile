import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/determine_user_category/determine_user_category_bloc.dart';
import 'package:tararide_mobile/bloc/user_auth_availability/user_auth_availability_bloc.dart';
import 'package:tararide_mobile/config/firebase_options.dart';
import 'package:tararide_mobile/views/driver/driver_home_page.dart';
import 'package:tararide_mobile/views/login_screen.dart';
import 'package:tararide_mobile/views/passenger/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

final GoRouter router = GoRouter(
  routes: [
    // Add routes here
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var firebaseAuthInstance = FirebaseAuth.instance;
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/driver_home': (context) => const DriverHomePage(title: 'Driver Home Page'),
      },
      onGenerateRoute: (settings) {
        print("settings.name: ${settings.name}");
        if (settings.name == '/driver_home') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const DriverHomePage(title: 'Driver Home Page'),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        } else if (settings.name == '/login') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        } else if (settings.name == '/signup') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        }
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 48, 0, 158)),
        primaryColor: const Color.fromARGB(255, 67, 0, 223),
        primaryColorLight: const Color.fromARGB(255, 112, 53, 251),
        primaryColorDark: const Color.fromARGB(255, 20, 0, 65),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 93, 47, 123),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 93, 47, 123),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            foregroundColor: const Color.fromARGB(255, 93, 47, 123),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 93, 47, 123),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
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
            BlocProvider<DetermineUserCategoryBloc>(create: (BuildContext determineUserCategoryBloc) => DetermineUserCategoryBloc()..add(DetermineUserCategoryAwait())),
          ],
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    BlocConsumer<UserAuthAvailabilityBloc, UserAuthAvailabilityState>(
                      listener: (context, state) {
                        if (state is UserAvailable) {
                          print("User is available! ${state.user.email}");
                          //context.read<DetermineUserCategoryBloc>().add(DetermineUserCategoryLoad(user: state.user));
                        }
                      },
                      builder: (context, state) {
                        if (state is UserAuthAvailabilityInitial) {
                          return FutureBuilder<void>(
                            future: Future.delayed(const Duration(seconds: 2)),
                            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                context.read<UserAuthAvailabilityBloc>().add(UserAuthAvailabilityCheck());
                                return const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Authenticating user, please wait..."),
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Authenticating user, please wait..."),
                                    SizedBox(
                                      height: 80,
                                      child: Lottie.asset('assets/loading_animation_2.json'),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        } else if (state is UserAvailable) {
                          return Column(
                            children: [
                              Text("Welcome to Tararide ${state.user.email}"),
                              ElevatedButton(
                                  onPressed: () async {
                                    await firebaseAuthInstance.signOut();
                                    // ignore: use_build_context_synchronously
                                    context.read<UserAuthAvailabilityBloc>().add(UserAuthInitilize());
                                  },
                                  child: const Text("Sign Out")),
                            ],
                          );
                        } else if (state is UserNotAvailable) {
                          return FutureBuilder<void>(
                            future: Future.delayed(const Duration(seconds: 1)),
                            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 250,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/login',
                                          );
                                        },
                                        child: const Text("Login"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 250,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/signup');
                                        },
                                        child: const Text("Sign Up"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Redirecting to login page..."),
                                    SizedBox(
                                      height: 80,
                                      child: Lottie.asset('assets/loading_animation_2.json'),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        } else if (state is UserAuthAvailabilityError) {
                          return const CircularProgressIndicator();
                        } else {
                          return const CircularProgressIndicator();
                        }
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
