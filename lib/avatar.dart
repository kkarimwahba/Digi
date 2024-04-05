import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
// import 'package:o3d/o3d.dart';

class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/3Env1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Transform(
            transform: Matrix4.translationValues(1.0, 0.0, 14.0),
            child: const ModelViewer(
                src: 'assets/avatars/model.glb',
                cameraControls: true,
                autoPlay: true,
                animationName: 'Running',
                cameraOrbit: '0deg 80deg 0m'),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 203, 169, 36),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  shape: const CircleBorder(),
                  color: const Color.fromARGB(255, 203, 169, 36),
                  child: InkWell(
                    onTap: () {
                      // Handle microphone button press
                    },
                    borderRadius: BorderRadius.circular(28),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
