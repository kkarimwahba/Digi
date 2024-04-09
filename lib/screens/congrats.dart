import 'package:digi2/screens/avatar.dart';
import 'package:digi2/screens/speech.dart';
import 'package:digi2/screens/test.dart';
import 'package:digi2/screens/voice.dart';
import 'package:flutter/material.dart';

class CongratulationsPage extends StatelessWidget {
  const CongratulationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 30, 62),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 30, 62),
        foregroundColor: Colors.white,
        title: const Text('Congratulations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/check.png', // Replace with your image asset
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
            ),
            const SizedBox(height: 20), // Add some space
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Add some space
            const Text(
              'You have successfully completed the task.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40), // Add some space
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) {
                    return const Avatar();
                  },
                ));
              },
              child: Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/btnbk.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Avatar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ), // Spacer to push Ok button to the bottom
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) {
                    return const Avatar();
                  },
                ));
              },
              child: Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/btnbk.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}