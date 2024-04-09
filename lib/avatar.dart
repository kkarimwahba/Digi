import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class Avatar extends StatefulWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final Record _recorder = Record();
  bool _isRecording = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var microphoneStatus = await Permission.microphone.request();
    var storageStatus = await Permission.storage.request();

    if (microphoneStatus != PermissionStatus.granted ||
        storageStatus != PermissionStatus.granted) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Permissions Error"),
                content: const Text(
                    "This app needs microphone and storage permissions to function properly."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ));
    }
  }

  Future<void> _toggleRecording() async {
    final isRecording = await _recorder.isRecording();
    if (isRecording) {
      await _stopRecordingAndSend();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

    final isRecording = await _recorder.start(path: _filePath);
    setState(() {
      _isRecording = isRecording;
    });
  }

  Future<void> _stopRecordingAndSend() async {
    await _recorder.stop();
    setState(() {
      _isRecording = false;
    });
    if (_filePath != null) {
      await _sendAudioFile(_filePath!);
    }
  }

  Future<void> _sendAudioFile(String filePath) async {
    var uri = Uri.parse('http://10.0.2.2:5000/process_audio');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('audio', filePath));
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Audio sent successfully');
    } else {
      print('Failed to send audio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/3Env1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Transform(
                transform: Matrix4.translationValues(1.0, 0.0, 14.0),
                child: const ModelViewer(
                  src: 'assets/avatars/model.glb',
                  cameraControls: true,
                  autoPlay: true,
                  animationName: 'Running',
                  cameraOrbit: '0deg 80deg 0m',
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: FloatingActionButton(
                    onPressed: _toggleRecording,
                    backgroundColor: const Color.fromARGB(255, 203, 169, 36),
                    child: Icon(
                      _isRecording ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
