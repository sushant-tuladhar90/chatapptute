import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String email;
  final String profilePic;
  final String? lastMessage; // Optional, can be null
  final Timestamp? timestamp; // Optional, can be null
  final VoidCallback onTap;
  final String username;

  const UserTile({
    Key? key,
    required this.text,
    required this.email,
    required this.profilePic,
    this.lastMessage,
    this.timestamp,
    required this.onTap,
    required this.username, required lastMessageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
          child: profilePic.isEmpty
              ? Icon(Icons.person, color: Theme.of(context).colorScheme.tertiary, size: 30)
              : null,
        ),
        title: Text(username, style: const TextStyle(fontSize: 16)),
        subtitle: lastMessage != null && lastMessage!.isNotEmpty
            ? Text(
                lastMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: lastMessage == "No recent messages"
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.tertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null, // Don't display subtitle if lastMessage is null or empty
        trailing: timestamp != null
            ? Text(
                _formatTimestamp(timestamp!), // Show formatted time if available
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )
            : null, // Don't show timestamp if it's null
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String period = dateTime.hour >= 12 ? "P.M" : "A.M"; // Determine AM/PM
  int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  hour = hour == 0 ? 12 : hour; // Convert 0 to 12 for 12 AM
  String minute = dateTime.minute.toString().padLeft(2, '0'); // Ensure two-digit minutes

  return "$hour:$minute $period"; // Example: 10:05 A.M
}

}
