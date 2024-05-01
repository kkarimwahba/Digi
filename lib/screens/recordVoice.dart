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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Record Voice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Record voice to make your Avatar \nhas the same voice',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
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
                  icon: const Icon(
                    Icons.mic,
                    color: Colors.white,
                  ), // Add mic icon
                  label: const Text(
                    'Record',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150.0, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickFile();
                  },
                  icon: const Icon(
                    Icons.upload_file,
                    color: Colors.white,
                  ), // Add upload file icon
                  label: const Text(
                    'Upload File',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150.0, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.black,
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
                  color: Colors.black),
            ),
            // Rest of the code remains the same
            if (_filePath != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'Uploaded Audio File:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.audiotrack, // Audio icon
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          _filePath!,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/btnbk.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  //  _auth.updateUserGenderAndImages(
                  //     widget.selectedGender, uploadedImages);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) {
                      return const CongratulationsPage();
                    },
                  ));
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50.0),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
