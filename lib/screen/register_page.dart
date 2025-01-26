import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapptute/services/auth/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final _auth = AuthService();

  bool _isLoading = false; // Change from final to allow updates

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  // Function to show Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Save user info (username) to Firestore after registration
  Future<void> _saveUserToFirestore(User user, File image) async {
    try {
      // Upload the profile image to Firebase Storage and get the URL
      String? imageUrl = await _uploadImageToStorage(user.uid, image);

      // Save the user's information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': _usernameController.text,
        'email': user.email,
        'uid': user.uid,
        'profileImageUrl': imageUrl, // Store the image URL
      });
    } catch (e) {
      _showSnackbar("Error saving user info to Firestore: ${e.toString()}");
    }
  }

//Upload image to firestore
  // Function to upload profile image to Firebase Storage
  Future<String> _uploadImageToStorage(String uid, File image) async {
    try {
      // Create a reference to Firebase Storage where the image will be uploaded
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');

      // Upload the image file
      UploadTask uploadTask = storageRef.putFile(image);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL after successful upload
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Return the download URL of the uploaded image
      return downloadUrl;
    } catch (e) {
      // Throw an error if image upload fails
      throw Exception('Error uploading image: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xff1F41BB),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create an account to chat\n with friends and family.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Profile Picture Picker (optional)
                GestureDetector(
                  onTap: _pickImage, // Call the function to pick an image
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) // Display selected image
                        : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 40) // Show icon if no image is selected
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                // Text fields for username, email, and password
                MyTextfield(
                  controller: _usernameController,
                  hintText: "Username",
                  isPassword: false,
                ),
                const SizedBox(height: 8),
                MyTextfield(
                  controller: _emailController,
                  hintText: "Email",
                  isPassword: false,
                ),
                const SizedBox(height: 8),
                MyTextfield(
                  controller: _passwordController,
                  hintText: "Password",
                  isPassword: true,
                ),
                const SizedBox(height: 8),
                MyTextfield(
                  controller: _confirmpasswordController,
                  hintText: "Confirm Password",
                  isPassword: true,
                ),
                const SizedBox(height: 40),

                // Sign Up Button
                SizedBox(
                    height: 60,
                    width: 357,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_passwordController.text ==
                                  _confirmpasswordController.text) {
                                try {
                                  UserCredential userCredential =
                                      await _auth.signUpWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                    _usernameController.text,
                                    _selectedImage, // Pass the selected image
                                  );
                                  // After successful sign-up, save user info to Firestore
                                  await _saveUserToFirestore(
                                      userCredential.user!, _selectedImage!);

                                  // After successful sign-up, navigate to the login page
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                } catch (e) {
                                  _showSnackbar("Error: ${e.toString()}");
                                }
                              } else {
                                _showSnackbar("Passwords do not match");
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF002DE3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    )),
                const SizedBox(height: 30),

                // Already have an account? Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "Sign in now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1F41BB)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable TextField Widget
class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const MyTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 357,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 241, 241, 246),
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
