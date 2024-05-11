import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  bool _isRecorderInitialized = false;
  String? _filePath;
  String? audioFilePath;

  @override
  void initState() {
    super.initState();
    _speechToText.initialize();
    _recorder = FlutterSoundRecorder();
    fetchAudioFilePath();

    _initRecorder();
  }

  void _startListeningAndRecording() async {
    _startListening();
    _startRecording();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: (result) {
      setState(() {
        _messageController.text =
            result.recognizedWords; // Update text field with recognized words
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
    _sendMessage(_messageController
        .text); // Send the message after stopping the speech recognition
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
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed:
                      _isListening || _isRecording || !_isRecorderInitialized
                          ? null
                          : _startListeningAndRecording,
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

  // Future<void> _sendMessage(String message) async {
  //   if (message.isNotEmpty) {
  //     setState(() {
  //       if (_conversationStartTime == null) {
  //         _conversationStartTime = DateTime.now();
  //       }
  //       _messages.add({
  //         'message': message,
  //         'isMe': true,
  //         'timeSent': DateTime.now(),
  //       });
  //       _messageController.clear();
  //     });

  //     // Send message to backend and get response
  //     String response = await sendMessageToBackend(message);

  //     setState(() {
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

      // Simulate network delay or wait for response
      String response = await sendMessageToBackend(message);

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

  Future<void> fetchAudioFilePath() async {
    try {
      var response =
          await http.get(Uri.parse('http://10.0.2.2:5000/get_audio'));

      if (response.statusCode == 200) {
        // Extract audio file path from response
        setState(() {
          audioFilePath = jsonDecode(response.body)['audio_file_path'];
        });
      } else {
        print('Failed to fetch audio file path: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching audio file path: $e');
    }
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Microphone permission not granted')));
      return;
    }
    await _recorder!.openRecorder();
    setState(() {
      _isRecorderInitialized = true;
    });
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Recorder not initialized')));
      return;
    }
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

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (_filePath != null) {
      final recordedFile = File(_filePath!);
      if (recordedFile.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording saved: $_filePath')));
        _sendAudioToServer(_filePath!); // Call to send the audio to server
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Recording failed to save')));
      }
    }
  }

  Future<void> _sendAudioToServer(String filePath) async {
    var uri = Uri.parse('http://10.0.2.2:5000/clone');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('audio', filePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio sent to server successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send audio to server')),
      );
    }
  }

  Future<void> _playAudio(String audioFilePath) async {
    try {
      FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();
      await flutterSoundPlayer.startPlayer(fromURI: audioFilePath);
      flutterSoundPlayer.setSubscriptionDuration(Duration(milliseconds: 100));
    } catch (e) {
      print('Error playing audio: $e');
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
        if (audioFilePath != null) {
          await _playAudio(audioFilePath!);
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
