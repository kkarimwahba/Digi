import 'dart:io';
import 'package:digi2/screens/gender.dart';
import 'package:digi2/screens/recordVoice.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi2/services/firebase_auth.dart';

class uploadImage extends StatefulWidget {
  final String selectedGender;

  const uploadImage({Key? key, required this.selectedGender}) : super(key: key);

  @override
  State<uploadImage> createState() => _uploadImageState();
}

class _uploadImageState extends State<uploadImage> {
  List<String> uploadedImages = [];
  final ImagePicker _picker = ImagePicker();
  final _auth = AuthService();

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        uploadedImages.add(pickedFile.path);
      });
    }
  }

  Future<void> _chooseFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        uploadedImages.add(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 30, 62),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 30, 62),
        foregroundColor: Colors.white,
        title: const Text('Choose Photo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload Images',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Upload 2-6 photos of yourself',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    'Take Photo',
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150.0, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _chooseFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose from Gallery'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150.0, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            const Text(
              'The better your Images \nthe better your results.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            if (uploadedImages.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: uploadedImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      File(uploadedImages[index]),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            const SizedBox(height: 60.0),
            const Text(
              'Thanks for letting us help you!',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60.0),
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
                      return RecordVoicePage(
                        selectedGender: widget.selectedGender,
                        uploadedImages: uploadedImages,
                      );
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
