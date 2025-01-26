import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/user_tile.dart';
import 'chat_messge.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserID;

  @override
  void initState() {
    super.initState();
    currentUserID = _auth.currentUser?.uid; // Get current user's UID
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search Chats',
                    prefixIcon: Icon(Icons.search, color: Color(0XFFADB5BD)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Contacts List from Firestore (Excluding Current User)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error fetching users"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var users = snapshot.data!.docs;

                  // 🔥 Filter out current user
                  users =
                      users.where((doc) => doc.id != currentUserID).toList();

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index].data() as Map<String, dynamic>?;

                      if (user == null) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserTile(
                            text: user['username'] ?? "Unknown User",
                            email: user['email'] ?? "unknown@email.com",
                            profilePic: user['profilePic'] ?? "",
                            timestamp: null,
                            onTap: () {
                              // Navigate to chat page and pass necessary details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatMessge(
                                    receiverEmail:
                                        user['email'] ?? "unknown@email.com",
                                    receiverID: user['uid'],
                                    profilePic: user['profilePic'] ?? "",
                                  ),
                                ),
                              );
                            },
                            username: user['username'] ?? "Unknown User",
                            lastMessageTime: null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                      
                          //
                          const Divider(
                            color: Color.fromARGB(255, 236, 229, 229),
                            height: 1,
                            thickness: 0.5,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
