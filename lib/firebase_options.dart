// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyBWv5odKjNxquhd2brnhSjln_440IkPBp4',
    appId: '1:462115073196:web:47a5f0ed5bb54fa6df0309',
    messagingSenderId: '462115073196',
    projectId: 'digihuman-dce99',
    authDomain: 'digihuman-dce99.firebaseapp.com',
    storageBucket: 'digihuman-dce99.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfVQqBz9Y3_dvDocVoeQwWhdZIG909Kqs',
    appId: '1:462115073196:android:2c9e5033e6690bd4df0309',
    messagingSenderId: '462115073196',
    projectId: 'digihuman-dce99',
    storageBucket: 'digihuman-dce99.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyJdJvdmE06OVrshySvgJq1TbAOEyf5kw',
    appId: '1:462115073196:ios:cfc5f357bfb77a80df0309',
    messagingSenderId: '462115073196',
    projectId: 'digihuman-dce99',
    storageBucket: 'digihuman-dce99.appspot.com',
    iosBundleId: 'com.example.digi2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyJdJvdmE06OVrshySvgJq1TbAOEyf5kw',
    appId: '1:462115073196:ios:2499c0bfcc8fc32bdf0309',
    messagingSenderId: '462115073196',
    projectId: 'digihuman-dce99',
    storageBucket: 'digihuman-dce99.appspot.com',
    iosBundleId: 'com.example.digi2.RunnerTests',
  );
}
