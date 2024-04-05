// // // import 'package:flutter/material.dart';
// // // import 'package:speech_to_text/speech_to_text.dart' as stt;

// // // class Voice extends StatefulWidget {
// // //   @override
// // //   _VoiceState createState() => _VoiceState();
// // // }

// // // class _VoiceState extends State<Voice> {
// // //   late stt.SpeechToText _speech;
// // //   bool _isListening = false;
// // //   String _recognizedText = '';

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initSpeechRecognizer();
// // //   }

// // //   Future<void> _initSpeechRecognizer() async {
// // //     _speech = stt.SpeechToText();
// // //     await _speech.initialize();
// // //   }

// // //   void startListening() {
// // //     if (_speech != null && _speech.isAvailable && !_isListening) {
// // //       _speech.listen(
// // //         onResult: (result) {
// // //           setState(() {
// // //             _recognizedText = result.recognizedWords;
// // //           });
// // //         },
// // //       );
// // //       setState(() {
// // //         _isListening = true;
// // //       });
// // //     }
// // //   }

// // //   void stopListening() {
// // //     if (_isListening) {
// // //       _speech.stop();
// // //       setState(() {
// // //         _isListening = false;
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Voice Recognition Test'),
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: <Widget>[
// // //             ElevatedButton(
// // //               onPressed: startListening,
// // //               child: Text(_isListening ? 'Listening...' : 'Start Listening'),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: stopListening,
// // //               child: Text('Stop Listening'),
// // //             ),
// // //             SizedBox(height: 20),
// // //             Text(
// // //               'Recognized Text:',
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             SizedBox(height: 10),
// // //             Text(
// // //               _recognizedText,
// // //               style: TextStyle(fontSize: 16),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // // import 'package:speech_to_text/speech_to_text.dart';

// // class Voice extends StatefulWidget {
// //   @override
// //   _VoiceState createState() => _VoiceState();
// // }

// // class _VoiceState extends State<Voice> {
// //   // SpeechToText _speech = SpeechToText();
// //   // bool _isListening = false;
// //   // String _text = '';

// //   // @override
// //   // void initState() {
// //   //   super.initState();
// //   //   _speech.listen(
// //   //       onResult: (event) => setState(() => _text = event.recognizedWords));
// //   // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         // appBar: AppBar(
// //         //   title: Text('Speech to Text'),
// //         // ),
// //         // body: Center(
// //         //   child: Column(
// //         //     mainAxisAlignment: MainAxisAlignment.center,
// //         //     children: [
// //         //       Text(
// //         //         _text,
// //         //         style: TextStyle(fontSize: 24),
// //         //       ),
// //         //       SizedBox(height: 20),
// //         //       FloatingActionButton(
// //         //         onPressed: _listen,
// //         //         child: Icon(_isListening ? Icons.stop : Icons.mic),
// //         //       ),
// //         //     ],
// //         //   ),
// //         // ),
// //         );
// //   }

// //   // void _listen() async {
// //   //   if (!_isListening) {
// //   //     bool available = await _speech.initialize();
// //   //     if (available) {
// //   //       setState(() => _isListening = true);
// //   //       _speech.listen();
// //   //     }
// //   //   } else {
// //   //     _speech.stop();
// //   //     setState(() => _isListening = false);
// //   //   }
// //   // }
// // }
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_speech/flutter_speech.dart';

// const languages = [
//   Language('Francais', 'fr_FR'),
//   Language('English', 'en_US'),
//   Language('Pусский', 'ru_RU'),
//   Language('Italiano', 'it_IT'),
//   Language('Español', 'es_ES'),
// ];

// class Language {
//   final String name;
//   final String code;

//   const Language(this.name, this.code);
// }

// class Voice extends StatefulWidget {
//   const Voice({super.key});

//   @override
//   _VoiceState createState() => _VoiceState();
// }

// class _VoiceState extends State<Voice> {
//   late SpeechRecognition _speech;

//   bool _speechRecognitionAvailable = false;
//   bool _isListening = false;

//   String transcription = '';

//   //String _currentLocale = 'en_US';
//   Language selectedLang = languages.first;

//   @override
//   initState() {
//     super.initState();
//     activateSpeechRecognizer();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   void activateSpeechRecognizer() {
//     print('_MyAppState.activateSpeechRecognizer... ');
//     _speech = SpeechRecognition();
//     _speech.setAvailabilityHandler(onSpeechAvailability);
//     _speech.setRecognitionStartedHandler(onRecognitionStarted);
//     _speech.setRecognitionResultHandler(onRecognitionResult);
//     _speech.setRecognitionCompleteHandler(onRecognitionComplete);
//     _speech.setErrorHandler(errorHandler);
//     _speech.activate('fr_FR').then((res) {
//       setState(() => _speechRecognitionAvailable = res);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('SpeechRecognition'),
//           actions: [
//             PopupMenuButton<Language>(
//               onSelected: _selectLangHandler,
//               itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
//             )
//           ],
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Expanded(
//                       child: Container(
//                           padding: const EdgeInsets.all(8.0),
//                           color: Colors.grey.shade200,
//                           child: Text(transcription))),
//                   _buildButton(
//                     onPressed: _speechRecognitionAvailable && !_isListening
//                         ? () => start()
//                         : null,
//                     label: _isListening
//                         ? 'Listening...'
//                         : 'Listen (${selectedLang.code})',
//                   ),
//                   _buildButton(
//                     onPressed: _isListening ? () => cancel() : null,
//                     label: 'Cancel',
//                   ),
//                   _buildButton(
//                     onPressed: _isListening ? () => stop() : null,
//                     label: 'Stop',
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }

//   List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
//       .map((l) => CheckedPopupMenuItem<Language>(
//             value: l,
//             checked: selectedLang == l,
//             child: Text(l.name),
//           ))
//       .toList();

//   void _selectLangHandler(Language lang) {
//     setState(() => selectedLang = lang);
//   }

//   Widget _buildButton({required String label, VoidCallback? onPressed}) =>
//       Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: ElevatedButton(
//             onPressed: onPressed,
//             child: Text(
//               label,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ));

//   void start() => _speech.activate(selectedLang.code).then((_) {
//         return _speech.listen().then((result) {
//           print('_MyAppState.start => result $result');
//           setState(() {
//             _isListening = result;
//           });
//         });
//       });

//   void cancel() =>
//       _speech.cancel().then((_) => setState(() => _isListening = false));

//   void stop() => _speech.stop().then((_) {
//         setState(() => _isListening = false);
//       });

//   void onSpeechAvailability(bool result) =>
//       setState(() => _speechRecognitionAvailable = result);

//   void onCurrentLocale(String locale) {
//     print('_MyAppState.onCurrentLocale... $locale');
//     setState(
//         () => selectedLang = languages.firstWhere((l) => l.code == locale));
//   }

//   void onRecognitionStarted() {
//     setState(() => _isListening = true);
//   }

//   void onRecognitionResult(String text) {
//     print('_MyAppState.onRecognitionResult... $text');
//     setState(() => transcription = text);
//   }

//   void onRecognitionComplete(String text) {
//     print('_MyAppState.onRecognitionComplete... $text');
//     setState(() => _isListening = false);
//   }

//   void errorHandler() => activateSpeechRecognizer();
// }
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TextToSpeechApp extends StatefulWidget {
//   const TextToSpeechApp({super.key});

//   @override
//   State<TextToSpeechApp> createState() => TextToSpeechAppState();
// }

// class TextToSpeechAppState extends State<TextToSpeechApp> {
//   TextEditingController textcontroller =
//       TextEditingController(text: 'Write some text for speech');

//   FlutterTts flutterTts = FlutterTts();
//   double volumerange = 0.5;
//   double pitchrange = 1;
//   double speechrange = 0.5;
//   bool isSpeaking = false;

//   play() async {
//     final languages = await flutterTts.getLanguages;
//     print(languages);
//     await flutterTts.setLanguage(languages[23]);
//     final voices = await flutterTts.getVoices;
//     print(voices);
//     await flutterTts.setVoice({"name": "hi-in-x-hia-local", "locale": "hi-IN"});
//     await flutterTts.speak(textcontroller.text);
//     isSpeaking = true;
//     setState(() {});
//   }

//   stop() async {
//     await flutterTts.stop();
//     isSpeaking = false;
//     setState(() {});
//   }

//   pause() async {
//     await flutterTts.pause();
//     isSpeaking = false;
//     setState(() {});
//   }

//   volume(val) async {
//     volumerange = val;
//     await flutterTts.setVolume(volumerange);
//     setState(() {});
//   }

//   pitch(val) async {
//     pitchrange = val;
//     await flutterTts.setPitch(pitchrange);
//     setState(() {});
//   }

//   speech(val) async {
//     speechrange = val;
//     await flutterTts.setSpeechRate(speechrange);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     flutterTts.setCompletionHandler(() {
//       isSpeaking = false;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.indigo,
//         title: const Text(
//           'Text To Speech App',
//           style: TextStyle(
//               fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 30,
//             ),
//             Container(
//               width: 250,
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   color: Colors.indigo,
//                   borderRadius: BorderRadius.circular(10)),
//               child: TextFormField(
//                 controller: textcontroller,
//                 maxLines: null,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                     hintText: 'Write some text',
//                     hintStyle: TextStyle(color: Colors.white),
//                     enabledBorder: InputBorder.none,
//                     border: InputBorder.none),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             AvatarGlow(
//               animate: isSpeaking,
//               glowColor: Color.fromARGB(255, 177, 33, 243),
//               child: Material(
//                 elevation: 10,
//                 shape: CircleBorder(),
//                 child: CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Color.fromARGB(255, 118, 80, 255),
//                   child: Icon(
//                     Icons.mic_none_outlined,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                     splashRadius: 40,
//                     onPressed: play,
//                     color: Colors.teal,
//                     iconSize: 60,
//                     icon: const Icon(Icons.play_circle)),
//                 IconButton(
//                     onPressed: stop,
//                     color: Colors.red,
//                     splashRadius: 40,
//                     iconSize: 60,
//                     icon: const Icon(Icons.stop_circle)),
//                 IconButton(
//                     onPressed: pause,
//                     color: Colors.amber.shade700,
//                     splashRadius: 40,
//                     iconSize: 60,
//                     icon: const Icon(Icons.pause_circle)),
//               ],
//             ),
//             Slider(
//               max: 1,
//               value: volumerange,
//               onChanged: (value) {
//                 volume(value);
//               },
//               divisions: 10,
//               label: "Volume: $volumerange",
//               activeColor: Colors.red,
//             ),
//             const Text('Set Volume'),
//             Slider(
//               max: 2,
//               value: pitchrange,
//               onChanged: (value) {
//                 pitch(value);
//               },
//               divisions: 10,
//               label: "Pitch Rate: $pitchrange",
//               activeColor: Colors.teal,
//             ),
//             const Text('Set Pitch'),
//             Slider(
//               max: 1,
//               value: speechrange,
//               onChanged: (value) {
//                 speech(value);
//               },
//               divisions: 10,
//               label: "Speech rate: $speechrange",
//               activeColor: Colors.amber.shade700,
//             ),
//             const Text('Set Speech Rate'),
//             const SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
