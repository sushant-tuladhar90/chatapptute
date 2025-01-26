import 'package:chatapptute/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../screen/account_info.dart';
import '../screen/apperance.dart';
import '../screen/login_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? _username;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUsername(); // Fetch username on drawer open
  }

  // Fetch username using AuthService
  void _fetchUsername() async {
    String? username = await AuthService().getUsername();
    setState(() {
      _username = username ?? "No Username"; // Default if null
    });
  }

  // Function to sign out the user
  void _signOut() async {
    await _auth.signOut();
    // After signing out, redirect the user to the login screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Profile Section
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                children: [
                  // Profile Picture (If available, else show default icon)
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: _profileImageUrl != null
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(_profileImageUrl!),
                          )
                        : const Icon(
                            Icons.account_circle,
                            size: 60,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(width: 08.0),
                  // Username
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _username ??
                              "No Username", // Show fetched username or loading
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 0.5,
          ),
          // Menu Items
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  icon: SvgPicture.asset(
                    'assets/images/profile.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .tertiary, 
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  title: "Account",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountInfo()));
                  },
                ),
                _buildMenuItem(
                  icon: SvgPicture.asset(
                    'assets/images/chat.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .tertiary, 
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  title: "Chat",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 0.5,
                ),
                _buildMenuItem(
                  icon: SvgPicture.asset(
                    'assets/images/apperance.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .tertiary, 
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  title: "Apperance",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Apperance()));
                  },
                ),
                 _buildMenuItem(
                  icon: SvgPicture.asset(
                    'assets/images/notification.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .tertiary, 
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ), 
                  title: 'Notification',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: SvgPicture.asset(
                    'assets/images/privacy.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .tertiary, 
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ), title: 'Privacy',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: SvgPicture.asset(
                    'assets/images/help.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .tertiary, 
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  title: "Help",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: SvgPicture.asset(
                    'assets/images/invite.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .tertiary, 
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  title: "Invite your friends",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                const Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 0.5,
                ),
                // Sign-out item
                GestureDetector(
                  onTap: _signOut,
                  child: ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 24,
                      color: Theme.of(context)
                            .colorScheme
                            .tertiary,
                    ),
                    title: const Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMenuItem({
  required Widget icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: icon,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    onTap: onTap,
  );
}
