import 'package:digi2/screens/audiorecord.dart';
import 'package:digi2/screens/avatar.dart';
import 'package:digi2/screens/gender.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset('assets/images/homebk.jpg').image,
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
                    'Create your own Al-generated avatar',
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
                        return audioRecord();
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
                        return Avatar();
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
    );
  }
}
