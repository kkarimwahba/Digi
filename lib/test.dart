import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YourFlutterPage extends StatefulWidget {
  @override
  _YourFlutterPageState createState() => _YourFlutterPageState();
}

class _YourFlutterPageState extends State<YourFlutterPage> {
  TextEditingController _queryController = TextEditingController();
  String _response = '';

  Future<void> _sendQuery() async {
    String query = _queryController.text;
    if (query.isNotEmpty) {
      final response = await http.post(
        Uri.parse(
            'http://127.0.0.1:5000/api'), // Change the URL to your Flask server endpoint
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'query': query,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _response = data['response'];
        });
      } else {
        // Handle error
        print('Error: ${response.reasonPhrase}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Flutter Page'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(labelText: 'Enter your query'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendQuery,
              child: const Text('Send Query'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
