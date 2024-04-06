import 'package:digi2/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;

class UserBase {
  String uid;
  String username;
  String email;
  String password;
  String phone;
  String? role;

  UserBase({
    required this.uid,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    this.role = 'user',
  });

  tojson() {
    return {
      'uid': user?.uid,
      "name": username,
      "email": email,
      "password": password,
      "phone": phone,
      "role": role,
    };
  }
}
