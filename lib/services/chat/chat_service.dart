import 'package:chatapptute/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // Firestore & auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//   void markMessagesAsDelivered(String userID) async {
//   QuerySnapshot messages = await _firestore
//     .collectionGroup("messages")
//     .where("receiverID", isEqualTo: userID) // Keep only one condition for now
//     // .where("status", isEqualTo: "sent") // Comment this out for testing
//     .get();


//   for (var doc in messages.docs) {
//     await doc.reference.update({'status': 'delivered'});
//   }
// }


  // Get users stream for chat_page
  Stream<List<Map<String, dynamic>>> getUsersStream() {
  String? currentUserId = _auth.currentUser?.uid;
  if (currentUserId == null) return const Stream.empty();

  return _firestore.collection("users").snapshots().asyncMap((snapshot) async {
    List<Map<String, dynamic>> usersWithChats = [];

    for (var doc in snapshot.docs) {
      final user = doc.data();
      user['uid'] = doc.id; // Ensure UID is included

      // Skip current user
      if (user['uid'] == currentUserId) continue;

      // Sort user IDs lexicographically to create consistent chat room IDs
      List<String> userIds = [currentUserId, user['uid']];
      userIds.sort();

      // Fetch last message
      var lastMessageSnapshot = await _firestore
          .collection("chat_rooms")
          .doc(userIds.join('_'))
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      // Only add users who have messages
      if (lastMessageSnapshot.docs.isNotEmpty) {
        user['lastMessage'] = lastMessageSnapshot.docs.first['message'];
        user['lastMessageTime'] = lastMessageSnapshot.docs.first['timestamp'];
        usersWithChats.add(user);
      }
    }

    return usersWithChats;
  });
}




  // Stream<List<Map<String, dynamic>>> getUsersStream() {
  //   String? currentUserId = _auth.currentUser?.uid; // Get logged-in user ID

  //   return _firestore.collection("users").snapshots().map((snapshot) {
  //     return snapshot.docs
  //         .map((doc) {
  //           final user = doc.data();
  //           user['uid'] = doc.id; // Ensure UID is included
  //           return user;
  //         })
  //         .where((user) => user['uid'] != currentUserId) // Exclude current user
  //         .toList();
  //   });
  // }

  //send a messages
  Future<void> sendMessage(String receiverID, String message) async {
  final String currentUserID = _auth.currentUser!.uid;
  final String currentUserEmail = _auth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();

  // Construct chat room ID
  List<String> ids = [currentUserID, receiverID];
  ids.sort();
  String chatRoomId = ids.join('_');

  // Create a new message
  Message newMessage = Message(
    senderID: currentUserID,
    senderEmail: currentUserEmail,
    receiverID: receiverID,
    timestamp: timestamp,
    message: message,
    status: "sent", // Mark as sent
  );

  // Save to Firestore
  await _firestore
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("messages")
      .add(newMessage.toMap());
}




  //get a messages
  Stream<QuerySnapshot> getMesages(String userID, String otherUserID) {
  List<String> ids = [userID, otherUserID];
  ids.sort();
  String chatroomID = ids.join('_');

  // Fetch messages
  return _firestore
      .collection("chat_rooms")
      .doc(chatroomID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots()
      .map((snapshot) {
        for (var doc in snapshot.docs) {
          var message = doc.data() as Map<String, dynamic>;

          if (message["receiverID"] == userID && message["status"] == "sent") {
            // Update status to "delivered"
            doc.reference.update({"status": "delivered"});
          }
        }
        return snapshot;
      });
}

void markMessagesAsSeen(String chatRoomId, String currentUserId) async {
  QuerySnapshot messages = await _firestore
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("messages")
      .where("receiverID", isEqualTo: currentUserId)
      .where("status", isNotEqualTo: "seen") // Check only unseen messages
      .get();

  for (var doc in messages.docs) {
    await doc.reference.update({"status": "seen"});
  }
}


}
