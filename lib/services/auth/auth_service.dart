import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  //instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser; // Returns the current user or null
  }

  // Fetch the username from Firestore
Future<String?> getUsername() async {
  try {
    User? user = _auth.currentUser; // Get the current user

    if (user != null) {
      DocumentSnapshot userDoc = 
          await _firestore.collection("users").doc(user.uid).get();

      if (userDoc.exists) {
        return userDoc["username"]; // Return username from Firestore
      }
    }
    return null; // Return null if user is not found
  } catch (e) {
    print("Error fetching username: $e");
    return null;
  }
}

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(
    String email, String password, String username, File? image) async {
  try {
    // Register the user
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // Upload image if provided
    String imageUrl = "";
    if (image != null) {
      imageUrl = await _uploadImageToStorage(userCredential.user!.uid, image);
    }

    // Save user data in Firestore (even if no image is provided)
    await _saveUserToFirestore(userCredential.user!, imageUrl, username,);

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message ?? 'An unknown error occurred');
  }
}

Future<String> _uploadImageToStorage(String uid, File image) async {
  try {
    Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    throw Exception('Error uploading image: ${e.toString()}');
  }
}

Future<void> _saveUserToFirestore(User user, String imageUrl, String username) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'email': user.email,
      'uid': user.uid,
      'profileImageUrl': imageUrl,
    });
  } catch (e) {
    throw Exception('Error saving user info to Firestore: ${e.toString()}');
  }
}

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //errors
}
