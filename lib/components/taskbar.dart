import 'package:digi2/models/user.dart';
import 'package:digi2/screens/avatar.dart';
import 'package:digi2/screens/chat.dart';
import 'package:digi2/screens/home.dart';
import 'package:digi2/screens/profile.dart';
import 'package:digi2/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskBar extends StatefulWidget {
  const TaskBar({Key? key}) : super(key: key);

  @override
  State<TaskBar> createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  final _auth = AuthService();
  int _currentIndex = 0;
  late User? _currentUser; // Declare a variable to hold the current user

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser(); // Call a method to fetch the current user
  }

  void _fetchCurrentUser() async {
    _currentUser = _auth.getCurrentUser(); // Get the current user
    setState(() {}); // Trigger a rebuild to update the UI with the current user
  }

  final List<Widget> _pages = [
    const Home(),
    const ChatPage(),
    const Avatar(),
    UserProfile(
      user: user,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: Colors.black,
            ),

            label: 'Chat',
            // Add the ChatPage to the bottom navigation bar
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_pin,
              color: Colors.black,
            ),

            label: 'Avatar',
            // Add the ChatPage to the bottom navigation bar
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color.fromARGB(255, 17, 2, 100),
        selectedLabelStyle: TextStyle(color: Color.fromARGB(255, 17, 2, 100)),
      ),
    );
  }
}
