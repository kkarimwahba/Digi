import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  // Future<User?> createUserWithEmalAndPassword(
  //     String email, String password) async {
  //   try {
  //     final cred = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return cred.user;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return null;
  // }

  Future<User?> signinwithemailandpassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(credential.user?.uid);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    String phone,
  ) async {
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      String uid = user?.uid ?? '';

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': username,
        'email': email,
        'password': password,
        'phone': phone,
        'role': 'user',
      });

      return user;
    } catch (error) {
      print('Error registering user: $error');
      return null;
    }
  }
}
