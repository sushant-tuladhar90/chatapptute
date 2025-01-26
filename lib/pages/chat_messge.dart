import 'package:chatapptute/services/auth/auth_service.dart';
import 'package:chatapptute/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessge extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String profilePic; // Added profile picture

  const ChatMessge({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.profilePic, // Added profile picture
  });

  @override
  _ChatMessgeState createState() => _ChatMessgeState();
}

class _ChatMessgeState extends State<ChatMessge> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Receiver's username
  String receiverUsername = "";

  @override
  void initState() {
    super.initState();
    _fetchReceiverUsername();
  }

  // Fetch receiver's username from Firestore
  void _fetchReceiverUsername() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiverID) // Use receiverID to fetch the username
          .get();

      if (userDoc.exists) {
        setState(() {
          receiverUsername = userDoc['username'] ?? "Unknown User";
        });
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  // Send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.profilePic.isNotEmpty
                  ? NetworkImage(widget.profilePic)
                  : null,
              child: widget.profilePic.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 24,
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  : null,
            ),
            const SizedBox(width: 10),

            // Receiver's Name (Username instead of Email)
            Text(
              receiverUsername.isNotEmpty
                  ? receiverUsername
                  : widget.receiverEmail,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Display all messages
          Expanded(child: _buildMessageList()),

          // User input field
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    void markMessagesAsSeen() async {
  String senderID = _authService.getCurrentUser()!.uid;

  List<String> ids = [senderID, widget.receiverID];
  ids.sort();
  String chatRoomId = ids.join('_');

  QuerySnapshot messages = await _chatService.getMesages(widget.receiverID, senderID).first;

  for (var doc in messages.docs) {
    if (doc['receiverID'] == senderID && doc['status'] != 'seen') {
      await doc.reference.update({'status': 'seen'});
    }
  }
}

    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMesages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildMessageListItem(doc))
              .toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageListItem(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

  Icon statusIcon;
  if (data['status'] == "sent") {
    statusIcon = const Icon(Icons.check, color: Colors.grey, size: 16); // Single tick
  } else if (data['status'] == "delivered") {
    statusIcon = const Icon(Icons.done_all, color: Colors.red, size: 16); // Double tick
  } else {
    statusIcon = const Icon(Icons.done_all, color: Colors.black, size: 16); // Seen (Blue)
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blueAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  isCurrentUser ? const Radius.circular(12) : Radius.zero,
              bottomRight:
                  isCurrentUser ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Message text
              Text(
                data["message"],
                style: TextStyle(
                  fontSize: 16,
                  color: isCurrentUser ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 5),

              // Timestamp & Status
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTimestamp(data['timestamp']),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 8,
                      color: isCurrentUser ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (isCurrentUser) statusIcon, // Show status icon only for sender
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  // Build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          // Image on the left side
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Image.asset(
              'assets/images/add.png',
              color: Theme.of(context).colorScheme.tertiary,
              scale: 0.8,
              width: 40, // Adjust the width as needed
              height: 50, // Adjust the height as needed
            ),
          ),

          // Text field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: .0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextfield(
                      controller: _messageController,
                      hintText: "Type a message",
                      isPassword: false,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Send button
          GestureDetector(
            onTap: sendMessage,
            child: Image.asset(
              'assets/images/send.png',
              width: 50,
              height: 50,
              scale: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

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
      style: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
      ),
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primary,
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

String _formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}"; // Example: 10:05
}
