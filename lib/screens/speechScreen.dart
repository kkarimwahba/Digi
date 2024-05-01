import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var text = "Hold the button and start speaking....";
  var isListening = false;
  List<String> speechTextList = [];
  String? lastSentenceHeard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.only(bottom: 150),
        child: Center(
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              if (lastSentenceHeard != null)
                Text(
                  'Last sentence heard: $lastSentenceHeard',
                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        glowColor: Colors.greenAccent,
        repeat: true,
        animate: isListening,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                        lastSentenceHeard = result.recognizedWords;
                      });
                    },
                  );
                  text = 'Listening...';
                });
              }
            }
          },
          onTapUp: (details) => setState(() {
            isListening = false;
            text = "Finished!!?";
            speechToText.stop();
          }),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// class SpeechScreen extends StatefulWidget {
//   const SpeechScreen({Key? key}) : super(key: key);

//   @override
//   State<SpeechScreen> createState() => _SpeechScreenState();
// }

// class _SpeechScreenState extends State<SpeechScreen> {
//   SpeechToText speechToText = SpeechToText();
//   var text = "Hold the button and start speaking....";
//   var isListening = false;
//   String? lastSentenceHeard;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Speech to Text"),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               text,
//               style: const TextStyle(fontSize: 24, color: Colors.black),
//             ),
//             const SizedBox(height: 20),
//             if (lastSentenceHeard != null)
//               Text(
//                 'Last sentence heard: $lastSentenceHeard',
//                 style: const TextStyle(fontSize: 18, color: Colors.blue),
//               ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (!isListening) {
//             var available = await speechToText.initialize();
//             if (available) {
//               setState(() {
//                 isListening = true;
//                 speechToText.listen(
//                   onResult: (result) {
//                     setState(() {
//                       text = result.recognizedWords;
//                       lastSentenceHeard = result.recognizedWords;
//                     });
//                   },
//                 );
//                 text = 'Listening...';
//               });
//             }
//           } else {
//             setState(() {
//               isListening = false;
//               text = "Finished!!?";
//               speechToText.stop();
//             });
//           }
//         },
//         child: Icon(
//           isListening ? Icons.stop : Icons.mic,
//         ),
//       ),
//     );
//   }
// }
