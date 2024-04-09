import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

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
    String gender,
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
        'gender': gender,
        'role': 'user',
      });

      return user;
    } catch (error) {
      print('Error registering user: $error');
      return null;
    }
  }

  Future<void> updateUserGender(String gender) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'gender': gender,
        });
      }
    } catch (error) {
      print('Error updating user gender: $error');
      throw Exception('An error occurred while updating user gender');
    }
  }

  Future<void> updateUserImages(List<String> imageUrls) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'images': imageUrls,
        });
      }
    } catch (error) {
      print('Error updating user images: $error');
      throw Exception('An error occurred while updating user images');
    }
  }
}
