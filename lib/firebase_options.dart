// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBWGL12-i5IirCfN2pSQT1Smg65Ps0i7cE',
    appId: '1:992326135365:web:b4f580ecd7e7f3f9483d2c',
    messagingSenderId: '992326135365',
    projectId: 'tararide-booking-app',
    authDomain: 'tararide-booking-app.firebaseapp.com',
    storageBucket: 'tararide-booking-app.firebasestorage.app',
    measurementId: 'G-ZQ4E9F17KF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCc-9P7RwnXjKF8vfXMHy0VjrWVHT7Dj9M',
    appId: '1:992326135365:android:4c36be81a23fbfba483d2c',
    messagingSenderId: '992326135365',
    projectId: 'tararide-booking-app',
    storageBucket: 'tararide-booking-app.firebasestorage.app',
  );
}
