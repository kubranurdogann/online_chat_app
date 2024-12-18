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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAui3eeTr5INGJXBdPbG4ESGZDKe7N1NXY',
    appId: '1:916190214616:web:02ff366c877d05a5305aad',
    messagingSenderId: '916190214616',
    projectId: 'chat-app-a8713',
    authDomain: 'chat-app-a8713.firebaseapp.com',
    storageBucket: 'chat-app-a8713.appspot.com',
    measurementId: 'G-QJGGW6FQ28',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmx_jqUDAwiQihNsNU1RBx8in-5ptSeIY',
    appId: '1:916190214616:android:1ee1484703c9af08305aad',
    messagingSenderId: '916190214616',
    projectId: 'chat-app-a8713',
    storageBucket: 'chat-app-a8713.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3tUPf6Z5igRGpJaM3t5XBJFMmh3gQ8lM',
    appId: '1:916190214616:ios:57ef6d81c308b05c305aad',
    messagingSenderId: '916190214616',
    projectId: 'chat-app-a8713',
    storageBucket: 'chat-app-a8713.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAui3eeTr5INGJXBdPbG4ESGZDKe7N1NXY',
    appId: '1:916190214616:web:7292f1026a7abcde305aad',
    messagingSenderId: '916190214616',
    projectId: 'chat-app-a8713',
    authDomain: 'chat-app-a8713.firebaseapp.com',
    storageBucket: 'chat-app-a8713.appspot.com',
    measurementId: 'G-44BRN8S1VJ',
  );
}
