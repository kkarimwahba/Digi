import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
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
      handleLoginSuccess(credential);

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

  // Future<void> updateUserGender(String gender) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       String uid = user.uid;
  //       await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //         'gender': gender,
  //       });
  //     }
  //   } catch (error) {
  //     print('Error updating user gender: $error');
  //     throw Exception('An error occurred while updating user gender');
  //   }
  // }

  // Future<void> updateUserImages(List<String> imageUrls) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       String uid = user.uid;
  //       await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //         'images': imageUrls,
  //       });
  //     }
  //   } catch (error) {
  //     print('Error updating user images: $error');
  //     throw Exception('An error occurred while updating user images');
  //   }
  // }

  // Future<void> updateUserGender(String gender) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       String uid = user.uid;
  //       final CollectionReference avatarsCollection = FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(uid)
  //           .collection('avatars');
  //       int nextAvatarNumber = await _getNextAvatarNumber(avatarsCollection);

  //       // Update the document with gender information
  //       await avatarsCollection.doc('avatarData$nextAvatarNumber').set({
  //         'gender': gender,
  //       });
  //     }
  //   } catch (error) {
  //     print('Error updating user gender: $error');
  //     throw Exception('An error occurred while updating user gender');
  //   }
  // }

  // Future<void> uploadImagesToFirestore(List<String> uploadedImages) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     String uid = user.uid;

  //     for (String imagePath in uploadedImages) {
  //       File imageFile = File(imagePath);
  //       String imageName = DateTime.now().millisecondsSinceEpoch.toString();
  //       Reference storageReference = FirebaseStorage.instance
  //           .ref()
  //           .child('user_images')
  //           .child(uid)
  //           .child('$imageName.jpg');

  //       UploadTask uploadTask = storageReference.putFile(imageFile);
  //       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

  //       String imageURL = await taskSnapshot.ref.getDownloadURL();

  //       final CollectionReference avatarsCollection = await FirebaseFirestore
  //           .instance
  //           .collection('users')
  //           .doc(uid)
  //           .collection('avatars');
  //       int nextAvatarNumber = await _getNextAvatarNumber(avatarsCollection);

  //       // Update the same document with images information
  //       await avatarsCollection.doc('avatarData$nextAvatarNumber').set({
  //         'images': FieldValue.arrayUnion([imageURL]),
  //       }, SetOptions(merge: true));
  //       // 'images': FieldValue.arrayUnion([imageURL]),
  //     }
  //   }
  // }

  Future<int> _getNextAvatarNumber(
      CollectionReference avatarsCollection) async {
    QuerySnapshot snapshot = await avatarsCollection.get();
    return snapshot.docs.length + 1;
  }

  // Future<void> updateUserGenderAndImages(
  //     String gender, List<String> uploadedImages) async {
  //   try {
  //     // Get the current user
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       // Get the user's unique ID
  //       String uid = user.uid;
  //       // Reference to the 'avatars' subcollection for the current user
  //       final CollectionReference avatarsCollection = FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(uid)
  //           .collection('avatars');

  //       // Get the next available avatar number
  //       int nextAvatarNumber = await _getNextAvatarNumber(avatarsCollection);

  //       // Document reference for the new avatar data document
  //       DocumentReference avatarDocRef =
  //           avatarsCollection.doc('avatarData$nextAvatarNumber');

  //       // Update the document with gender information
  //       await avatarDocRef.set({
  //         'gender': gender,
  //         'images': FieldValue.arrayUnion(uploadedImages),
  //       });

  //       // Add image URLs to the existing document
  //       // await avatarDocRef.set({
  //       //   'images': FieldValue.arrayUnion(uploadedImages),
  //       // }, SetOptions(merge: true));
  //     }
  //   } catch (error) {
  //     // Handle any errors that occur during the process
  //     print('Error updating user gender and images: $error');
  //     throw Exception(
  //         'An error occurred while updating user gender and images');
  //   }
  // }

  Future<void> updateUserGenderAndImages(
      String gender, List<String> uploadedImages, File file) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the user's unique ID
        String uid = user.uid;

        // Reference to the 'avatars' subcollection for the current user
        final CollectionReference avatarsCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('avatars');

        // Upload file to Firebase Storage
        String fileName = 'avatar_$uid';
        Reference storageReference =
            FirebaseStorage.instance.ref().child('avatars/$fileName');
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});

        // Get download URL of the uploaded file
        String fileURL = await storageTaskSnapshot.ref.getDownloadURL();

        // Get the next available avatar number
        int nextAvatarNumber = await _getNextAvatarNumber(avatarsCollection);

        // Document reference for the new avatar data document
        DocumentReference avatarDocRef =
            avatarsCollection.doc('avatarData$nextAvatarNumber');

        // Update the document with gender information and file URL
        await avatarDocRef.set({
          'gender': gender,
          'images': FieldValue.arrayUnion(uploadedImages),
          'fileURL': fileURL,
        });
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error updating user gender and images: $error');
      throw Exception(
          'An error occurred while updating user gender and images');
    }
  }

  Future<String?> getUserId(String userEmail) async {
    String? userId;

    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query Firestore to find the document ID associated with the user's email
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      // If the query returns any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the first document (assuming there's only one document per user)
        userId = querySnapshot.docs.first.id;
      } else {
        // Handle the case where the user document doesn't exist
        print('User document not found for email: $userEmail');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error retrieving user ID: $error');
    }

    return userId;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> handleLoginSuccess(UserCredential userCredential) async {
    String userEmail = userCredential.user!.email!;

    // Call getUserId function to retrieve the user's document ID
    String? userId = await getUserId(userEmail);

    if (userId != null) {
      // Use the userId for further operations, such as fetching additional user data
      // For example:
      // fetchUserData(userId);
      // navigateToHomePage();
    } else {
      // Handle the case where the user's document ID couldn't be retrieved
      // For example:
      // showErrorMessage('Failed to retrieve user data');
    }
  }
}
