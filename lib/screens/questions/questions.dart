import 'dart:async';
import 'dart:io';

import 'package:digi2/components/bar.dart';
import 'package:digi2/components/button.dart';
import 'package:digi2/screens/congrats.dart';
import 'package:digi2/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  FlutterSoundRecorder? _recorder;
  final _auth = AuthService();
  bool _isRecording = false;
  bool _isRecorderInitialized = false;
  String? _filePath;
  List<String> audioFiles = [];
  int currentQuestionIndex = 0;
  List<String> questions = [
    "What is your name?",
    "Where are you from?",
    "What is your favorite color?",
    "What do you like to do for fun?",
    "Tell me about your favorite book."
  ];

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission not granted')));
      return;
    }
    await _recorder!.openRecorder();
    setState(() {
      _isRecorderInitialized = true;
    });
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recorder not initialized')));
      return;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final folderPath = '${dir.path}/audios';
      final directory = Directory(folderPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      _filePath = '$folderPath/${DateTime.now().millisecondsSinceEpoch}.wav';
      await _recorder!.startRecorder(toFile: _filePath);
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (_filePath != null) {
      final recordedFile = File(_filePath!);
      if (recordedFile.existsSync()) {
        audioFiles.add(_filePath!); // Add the file path to the list
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording saved: $_filePath')));
        if (currentQuestionIndex == questions.length - 1) {
          // If this is the last question, upload the audio files to Firebase
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recording failed to save')));
      }
    }
  }

  void moveToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _auth.updateUserVoiceAudios(audioFiles);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (c) {
          return CongratulationsPage();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Recorder")),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          buildSegmentedProgressBar(
              questions: questions, currentQuestionIndex: currentQuestionIndex),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              questions[currentQuestionIndex],
              style: const TextStyle(fontSize: 35),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: _isRecording || !_isRecorderInitialized
                  ? null
                  : _startRecording,
              child: const Icon(
                Icons.mic,
                color: Colors.black,
                size: 30,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                    50.0, 50.0), // Set a fixed size for the circular button
                backgroundColor: Colors.amberAccent[700],
                shape:
                    const CircleBorder(), // Set the button's shape to CircleBorder
                padding: const EdgeInsets.all(15), // Adjust padding as needed
                shadowColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: !_isRecording ? null : _stopRecording,
              child: const Icon(
                Icons.stop,
                color: Colors.white,
                size: 30,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                    50.0, 50.0), // Set a fixed size for the circular button
                backgroundColor: Colors.red,
                shape:
                    const CircleBorder(), // Set the button's shape to CircleBorder
                padding: const EdgeInsets.all(15), // Adjust padding as needed
                shadowColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          //if (_filePath != null) Text('Last file: $_filePath'),
          CustomButton(
            text: 'Next',
            onPressed: () {
              moveToNextQuestion();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    super.dispose();
  }
}
