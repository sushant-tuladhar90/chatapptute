import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  String username = "";
  String email = "";
  String profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

//   Future<String?> getProfileImageUrl() async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     DocumentSnapshot userDoc = 
//         await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

//     if (userDoc.exists) {
//       return userDoc["profileImageUrl"]; // Fetch stored image URL
//     }
//   }
//   return null;
// }


  Future<void> _loadUserData() async {
  User? user = _auth.currentUser;
  if (user != null) {
    DocumentSnapshot userData =
        await _firestore.collection("users").doc(user.uid).get();
    if (userData.exists) {
      setState(() {
        username = userData["username"] ?? "Unknown";
        email = user.email ?? "";
        // profilePicUrl = userData["profilePic"] ?? "";
      });
    } else {
      print("User document not found in Firestore.");
    }
  }
}


  // Future<void> _updateProfilePicture() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     File imageFile = File(pickedFile.path);
  //     String userId = _auth.currentUser!.uid;
  //     Reference ref = _storage.ref().child("profile_pics/$userId.jpg");

  //     await ref.putFile(imageFile);
  //     String downloadUrl = await ref.getDownloadURL();

  //     await _firestore.collection("users").doc(userId).update({
  //       "profilePic": downloadUrl,
  //     });

  //     setState(() {
  //       profilePicUrl = downloadUrl;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Info"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: const CircleAvatar(
                radius: 80,
                backgroundImage:
                    AssetImage("assets/images/Sushant.jpg") as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.primary, // Background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Soft shadow
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Username: $username",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.primary, // Background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Soft shadow
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email: $email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
             Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Reset Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
