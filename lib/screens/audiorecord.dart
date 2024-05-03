// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AudioRecord extends StatefulWidget {
//   const AudioRecord({Key? key}) : super(key: key);

//   @override
//   _AudioRecordState createState() => _AudioRecordState();
// }

// class _AudioRecordState extends State<AudioRecord> {
//   final recorder = FlutterSoundRecorder();
//   bool isRecorderReady = false;

//   @override
//   void initState() {
//     super.initState();
//     initRecorder();
//   }

//   @override
//   void dispose() {
//     recorder.closeRecorder();
//     super.dispose();
//   }

//   Future record() async {
//     await recorder.startRecorder(toFile: 'audio');
//   }

//   Future stop() async {
//     if (!isRecorderReady) return;
//     final path = await recorder.stopRecorder();
//     final audioFile = File(path!);

//     print('Recorder audio: $audioFile');
//   }

//   Future initRecorder() async {
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Microphone permission not granted';
//     }
//     await recorder.openRecorder();
//     isRecorderReady = true;
//     recorder.setSubscriptionDuration(
//       const Duration(milliseconds: 500),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade900,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding:
//                   const EdgeInsets.only(top: 50.0), // Padding for top space
//               child: const Text(
//                 ' Do you try to find a compromise and maintain peace,\n or do you stand firm on your beliefs and principles?',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             StreamBuilder<RecordingDisposition>(
//               stream: recorder.onProgress,
//               builder: (context, snapshot) {
//                 final duration =
//                     snapshot.hasData ? snapshot.data!.duration : Duration.zero;
//                 String twoDigits(int n) => n.toString().padLeft(2, '0');
//                 final twoDigitMinutes =
//                     twoDigits(duration.inMinutes.remainder(60));
//                 final twoDigitSeconds =
//                     twoDigits(duration.inSeconds.remainder(60));
//                 return Text(
//                   '$twoDigitMinutes:$twoDigitSeconds',
//                   style: const TextStyle(
//                     fontSize: 60,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: Icon(
//                 recorder.isRecording ? Icons.stop : Icons.mic,
//                 size: 60,
//               ),
//               onPressed: () async {
//                 if (recorder.isRecording) {
//                   await stop();
//                 } else {
//                   await record();
//                 }
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class VoiceRecorderScreen extends StatefulWidget {
  @override
  _VoiceRecorderScreenState createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  bool _isRecorderInitialized = false;
  String? _filePath;

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
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Recording failed to save')));
      }
    }
  }

// Add this function inside your _VoiceRecorderScreenState class
  Future<void> _sendAudioToServer(String filePath) async {
    var uri = Uri.parse('http://<your-server-ip>:5000/upload');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice Recorder")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isRecording || !_isRecorderInitialized
                  ? null
                  : _startRecording,
              child: Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: !_isRecording ? null : _stopRecording,
              child: Text('Stop Recording'),
            ),
            if (_filePath != null) Text('Last file: $_filePath'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    super.dispose();
  }
}
