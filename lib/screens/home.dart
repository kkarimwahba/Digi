import 'package:digi2/screens/audiorecord.dart';
import 'package:digi2/screens/avatar.dart';
import 'package:digi2/screens/gender.dart';
import 'package:digi2/screens/login.dart';
import 'package:digi2/screens/myAvatars.dart';
import 'package:digi2/screens/profile.dart';
import 'package:digi2/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/homebk.jpg'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 100.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 250.0),
                        child: Text(
                          'Digital Twin Of Human',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        'Create your own AI-generated avatar',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) {
                        return const Gender();
                      },
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'Create your Own Avatar',
                    style: TextStyle(
                        fontSize: 24, color: Color.fromARGB(255, 52, 38, 170)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) {
                            return const AudioRecord();
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent[700],
                      ),
                      child: const Text('Explore'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) {
                            return MyAvatarsPage();
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent[700],
                      ),
                      child: const Text('My Avatars'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 50.0,
            right: 20.0,
            child: IconButton(
              onPressed: () async {
                // Get current user
                User? user = _auth.getCurrentUser();

                if (user != null) {
                  // Navigate to user profile page with user's UID as parameter
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserProfile(user: user),
                  ));
                } else {
                  // Handle case where user is not logged in
                  // You can show a message or redirect to login page
                }
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
