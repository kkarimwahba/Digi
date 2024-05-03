import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          _buildConversationStartTime(),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  onPressed: _toggleListening,
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _sendMessage(_messageController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationStartTime() {
    if (_conversationStartTime != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Conversation started at ${_conversationStartTime!.hour}:${_conversationStartTime!.minute}',
          style: const TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> messageData) {
    final String message = messageData['message'];
    final bool isMe = messageData['isMe'];
    final DateTime timeSent = messageData['timeSent'];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
  }

  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        if (_conversationStartTime == null) {
          _conversationStartTime = DateTime.now();
        }
        _messages.add({
          'message': message,
          'isMe': true,
          'timeSent': DateTime.now(),
        });
        _messageController.clear();
      });

      // Send message to backend and get response
      String response = await sendMessageToBackend(message);

      setState(() {
        _messages.add({
          'message': response,
          'isMe': false,
          'timeSent': DateTime.now(),
        });
      });
    }
  }

  Future<String> sendMessageToBackend(String message) async {
    final Uri uri = Uri.parse('http://10.220.236.110:5000/api');
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
        return aiResponse;
      } else {
        return 'Failed to get response from server';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  void _toggleListening() async {
    if (_isListening) {
      _speechToText.stop();
    } else {
      bool available = await _speechToText.initialize();
      if (available) {
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          },
        );
      }
    }
    setState(() {
      _isListening = !_isListening;
    });
  }
}
