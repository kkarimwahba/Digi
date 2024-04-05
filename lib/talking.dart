import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> sendChatRequest(String query) async {
  final response = await http.post(
    Uri.parse('http://localhost:5000/api/chat'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'query': query}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to send chat request');
  }
}
