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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 48, 0, 158)),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserAuthAvailabilityBloc>(create: (BuildContext user_auth_availability_context) => UserAuthAvailabilityBloc()),
          BlocProvider<DetermineUserCategoryBloc>(create: (BuildContext determine_user_category_bloc) => DetermineUserCategoryBloc())
        ],
        child: const Center(),
      ),
    );
  }
}
