import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Avatar extends StatefulWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  DateTime? _conversationStartTime;
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: (result) {
      setState(() {
        _messageController.text = result.recognizedWords;
      });
    });
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    _sendMessage(_messageController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAvatar(),
          _buildChatWidget(),
          _buildMicButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/3Env1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Transform(
        transform: Matrix4.translationValues(1.0, 0.0, 14.0),
        child: const ModelViewer(
          src: 'assets/avatars/model.glb',
          cameraControls: true,
          autoPlay: true,
          animationName: 'Running',
          cameraOrbit: '0deg 80deg 0m',
        ),
      ),
    );
  }

  Widget _buildChatWidget() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 65,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _messages.asMap().entries.map((entry) {
            final index = entry.key;
            final messageData = entry.value;
            final String message = messageData['message'];
            final bool isMe = messageData['isMe'];
            final DateTime timeSent = messageData['timeSent'];

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: isMe ? Colors.black : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: isMe
                          ? TextStyle(fontSize: 16.0, color: Colors.white)
                          : TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${timeSent.hour}:${timeSent.minute}',
                      style: isMe
                          ? TextStyle(fontSize: 12.0, color: Colors.white)
                          : TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: AvatarGlow(
          glowColor: Colors.greenAccent,
          repeat: true,
          duration: Duration(milliseconds: 2000),
          animate: _isListening,
          child: GestureDetector(
            onTapDown: (details) async {
              if (!_isListening) {
                var available = await _speechToText.initialize();
                if (available) {
                  setState(() {
                    _isListening = true;
                  });
                  _startListening();
                }
              }
            },
            onTapUp: (details) => _stopListening(),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 35,
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _sendMessage(String message) async {
  //   if (message.isNotEmpty) {
  //     final DateTime currentTime = DateTime.now();
  //     setState(() {
  //       if (_conversationStartTime == null) {
  //         _conversationStartTime = currentTime;
  //       }
  //       _messages.add({
  //         'message': message,
  //         'isMe': true,
  //         'timeSent': currentTime,
  //       });
  //       // Add typing indicator
  //       _messages.add({
  //         'message': '...',
  //         'isMe': false,
  //         'timeSent': currentTime,
  //         'typing': true, // A new property to identify typing indicators
  //       });
  //       _messageController.clear();
  //     });

  //     // Simulate network delay or wait for response
  //     String response = await sendMessageToBackend(message);

  //     // Remove typing indicator before adding the response
  //     setState(() {
  //       // Remove the last message which is the typing indicator
  //       if (_messages.isNotEmpty && _messages.last['typing'] == true) {
  //         _messages.removeLast();
  //       }
  //       _messages.add({
  //         'message': response,
  //         'isMe': false,
  //         'timeSent': DateTime.now(),
  //       });
  //     });
  //   }
  // }
  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      final DateTime currentTime = DateTime.now();
      setState(() {
        if (_conversationStartTime == null) {
          _conversationStartTime = currentTime;
        }
        _messages.add({
          'message': message,
          'isMe': true,
          'timeSent': currentTime,
        });
        // Add typing indicator
        _messages.add({
          'message': '...',
          'isMe': false,
          'timeSent': currentTime,
          'typing': true, // A new property to identify typing indicators
        });
        _messageController.clear();
      });

      String response = '';

      // Handle static responses based on input message
      if (message.toLowerCase() == 'hello') {
        response = 'Hello! How can I assist you today?';
      } else {
        // Simulate network delay or wait for response
        response = await sendMessageToBackend(message);
      }

      // Remove typing indicator before adding the response
      setState(() {
        // Remove the last message which is the typing indicator
        if (_messages.isNotEmpty && _messages.last['typing'] == true) {
          _messages.removeLast();
        }
        _messages.add({
          'message': response,
          'isMe': false,
          'timeSent': DateTime.now(),
        });
      });
    }
  }

  Future<String> sendMessageToBackend(String message) async {
    final Uri uri = Uri.parse('http://10.0.2.2:5000/jarvis');
    final Map<String, dynamic> requestData = {'input_text': message};

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String aiResponse = responseData['response'];
        final String audioUrl = responseData[
            'audio_url']; // Ensure this key matches what's sent by the server

        // Play the audio using AudioSource.uri
        if (audioUrl != null && audioUrl.isNotEmpty) {
          await audioPlayer.setSource(UrlSource(audioUrl));
          await audioPlayer
              .resume(); // This assumes that play is desired immediately after setting the source
        }

        return aiResponse;
      } else {
        return 'Failed to get response from server';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
