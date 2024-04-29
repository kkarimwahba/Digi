import 'dart:io';

import 'package:digi2/screens/audiorecord.dart';
import 'package:digi2/screens/congrats.dart';
import 'package:digi2/services/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RecordVoicePage extends StatefulWidget {
  late String selectedGender;
  late List<String> uploadedImages;

  RecordVoicePage({
    super.key,
    required this.selectedGender,
    required this.uploadedImages,
  });

  @override
  State<RecordVoicePage> createState() => _RecordVoicePageState();
}

class _RecordVoicePageState extends State<RecordVoicePage> {
  String? _filePath;
  final _auth = AuthService();

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowCompression: true,
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Upload file to Firebase storage
        TaskSnapshot taskSnapshot = await FirebaseStorage.instance
            .ref()
            .child('uploads/${DateTime.now().millisecondsSinceEpoch}')
            .putFile(file);

        // Get download URL of the uploaded file
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Update user gender and images
        await _auth.updateUserGenderAndImages(
            widget.selectedGender, widget.uploadedImages, file);

        setState(() {
          _filePath = result.files.single.path!;
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 30, 62),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 30, 62),
        foregroundColor: Colors.white,
        title: const Text('Record Voice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Record voice to make your Avatar \nhas the same voice',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) {
                        return const AudioRecord();
                      },
                    ));
                  },
                  icon: const Icon(Icons.mic), // Add mic icon
                  label: const Text('Record'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150.0, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickFile();
                  },
                  icon: const Icon(Icons.upload_file), // Add upload file icon
                  label: const Text('Upload File'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150.0, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Tips for recording:',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            // Rest of the code remains the same
            if (_filePath != null)
              Column(
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'Uploaded File:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    _filePath!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (c) {
                //     return const uploadImage();
                //   },
                // ));
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
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) {
                        return CongratulationsPage();
                      },
                    ));
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ), // Set shadow color to transparent
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
