import 'package:chatapptute/services/auth/auth_service.dart';
import 'package:chatapptute/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    "Login here",
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
                  "Welcome back, you've\nbeen missed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 64,
                  width: 357,
                  child: MyTextfield(
                    controller: _emailController,
                    hintText: "Email",
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 64,
                  width: 357,
                  child: MyTextfield(
                    controller: _passwordController,
                    hintText: "Password",
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F41BB),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
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

            //auth service
            final authService = AuthService();

            // try login
            try {
              await authService.signInWithEmailAndPassword(
                _emailController.text,
                _passwordController.text,
              );

              // Navigate to the home screen or another page after successful login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(), // replace with actual home page
                ),
              );
            } catch (e) {
              // Show Snackbar with error message if login fails
              _showSnackbar("Login failed: ${e.toString()}");
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          }, // Placeholder action
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0XFF002DE3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: _isLoading
        ? const CircularProgressIndicator(color: Colors.white)
        : const Text(
            "Sign in",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
  ),
),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Create new account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F41BB),
                        ),
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

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}
