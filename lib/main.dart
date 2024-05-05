import 'package:digi2/screens/onboarding/onboarding_screen.dart';
import 'package:digi2/screens/signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PermissionHandlerWidget(),
    );
  }
}

class PermissionHandlerWidget extends StatefulWidget {
  @override
  _PermissionHandlerWidgetState createState() =>
      _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      // Microphone permission is granted. Proceed with your app logic.
    } else if (status.isDenied) {
      // Microphone permission is denied.
      // You can show a dialog explaining why your app needs this permission
      // and provide the user with an option to grant the permission again.
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(); // or any other widget as your home screen
  }
}
