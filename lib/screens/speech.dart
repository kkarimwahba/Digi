// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// // class speech extends StatefulWidget {
// //   @override
// //   _speechState createState() => _speechState();
// // }

// // class _speechState extends State<speech> {
// //   SpeechToText speechToText = SpeechToText();
// //   var isListening = false;
// //   String text = "Speak Now";
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// //       floatingActionButton: AvatarGlow(
// //         animate: isListening,
// //         duration: const Duration(milliseconds: 2000),
// //         glowColor: Colors.green,
// //         repeat: true,
// //         child: GestureDetector(
// //           onTapDown: (details) async {
// //             if (isListening) {
// //               var available = await speechToText.initialize();
// //               if (available) {
// //                 setState(() {
// //                   isListening = true;
// //                   speechToText.listen(onResult: (result) {
// //                     setState(() {
// //                       text = result.recognizedWords;
// //                     });
// //                   });
// //                 });
// //               }
// //             }
// //           },
// //           onTapUp: (details) {
// //             setState(() {
// //               isListening = false;
// //             });
// //             speechToText.stop();
// //           },
// //           child: CircleAvatar(
// //             backgroundColor: Colors.amber,
// //             radius: 35,
// //             child: Icon(
// //               isListening ? Icons.mic : Icons.mic_none,
// //               color: Colors.white,
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: Container(
// //         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
// //         child: Column(
// //           children: [
// //             Text(
// //               text,
// //               style: TextStyle(
// //                   color: isListening ? Colors.black87 : Colors.black54,
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 28),
// //             ),
// //             Expanded(
// //                 child: Container(
// //               color: Colors.red,
// //             )),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // enum ChatMessagesType { user, bot }

// // class ChatMessages {
// //   String? text;
// //   ChatMessagesType? type;
// //   ChatMessages({required this.text, required this.type});
// // }

// class speech extends StatefulWidget {
//   @override
//   _speechState createState() => _speechState();
// }

// class _speechState extends State<speech> {
//   final SpeechToText _speech = SpeechToText();
//   String _text = 'Press the button and start speaking...';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Speech to Text'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               _text,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20.0),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: _listen,
//               child: Text('Start Listening'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _listen() async {
//     if (!_speech.isListening) {
//       bool available = await _speech.initialize();
//       if (available) {
//         _speech.listen(onResult: (result) {
//           setState(() {
//             _text = result.recognizedWords;
//           });
//         });
//       }
//     } else {
//       _speech.stop();
//     }
//   }
// }
