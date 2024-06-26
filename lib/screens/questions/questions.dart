import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
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
  TextEditingController _textFieldController = TextEditingController();
  List<Map<String, String>> userResponses = [];
  int currentQuestionIndex = 0;
  List<String> questions = [
    "What is your name?",
    "Where are you from?",
    "What is your favorite color?",
    "What do you like to do for fun?",
    "Tell me about your favorite book."
  ];

  void moveToNextQuestion() {
    if (_textFieldController.text.isNotEmpty) {
      // Build the response object
      Map<String, String> response = {
        'role': 'system',
        'content': _textFieldController.text,
      };
      // Add the response to the list
      userResponses.add(response);

      // Clear the text field for the next question
      _textFieldController.clear();

      // Check if all questions are answered
      if (currentQuestionIndex < questions.length - 1) {
        // Move to the next question
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        // All questions are answered, send responses to server
        sendUserResponsesToServer(userResponses);
      }
    } else {
      // Show an error message or prompt the user to enter a response
    }
  }

  void sendUserResponsesToServer(
      List<Map<String, String>> userResponses) async {
    if (userResponses.isNotEmpty) {
      final url = 'http://10.0.2.2:5000/save_responses';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'responses': userResponses});
      Navigator.of(context).push(MaterialPageRoute(
        builder: (c) {
          return const CongratulationsPage();
        },
      ));
      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: body);
        if (response.statusCode == 200) {
          print('User responses sent to server successfully.');
        } else {
          print(
              'Failed to send user responses. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error sending user responses: $e');
      }
    } else {
      // Show a Snackbar if the list is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No responses to send.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Answer Questions")),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          buildSegmentedProgressBar(
              questions: questions, currentQuestionIndex: currentQuestionIndex),
          const SizedBox(height: 25),
          Text(
            questions[currentQuestionIndex],
            style: const TextStyle(fontSize: 35),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Type your response here',
              ),
            ),
          ),
          const SizedBox(height: 25),
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
}
