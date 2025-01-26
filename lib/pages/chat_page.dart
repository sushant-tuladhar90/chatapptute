import 'package:chatapptute/components/my_drawer.dart';
import 'package:flutter/material.dart';
import '../components/user_tile.dart';
import '../services/chat/chat_service.dart';
import 'chat_messge.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
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
                child: const TextField(
                  decoration: InputDecoration(
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

            // Chat List
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
    );
  }

  // Build the list of users
  Widget _buildUserList() {
  return StreamBuilder(
    stream: _chatService.getUsersStream(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        print("Error: ${snapshot.error}");  // Log error
        return const Center(child: Text("Error loading chats"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        print("No users found");
        return const Center(child: Text("No chats available"));
      }

      var users = snapshot.data!;
      print("Fetched Users: $users");  // Debugging output

      return ListView.separated(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserTile(
            text: user['username'] ?? "Unknown User",
            email: user['email'] ?? "No Email",
            profilePic: user['profilePic'] ?? "",
            lastMessage: user['lastMessage'] ?? "No recent messages",
            timestamp: user['lastMessageTime'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatMessge(
                    receiverEmail: user["email"] ?? "unknown@email.com",
                    receiverID: user["uid"],
                    profilePic: user["profilePic"] ?? "",
                  ),
                ),
              );
            },
            username: user['username'] ?? "Unknown User",
            lastMessageTime: user['lastMessageTime'],
          );
        },
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Color.fromARGB(255, 236, 229, 229),
          thickness: 0.5,
        ),
      );
    },
  );
}

}
