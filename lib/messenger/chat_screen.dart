import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'messenger_home.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  late Stream<List<Message>> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = _firestore
        .collection('messages')
        .where('participants', arrayContains: widget.user.name)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromDocument(doc)).toList());
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    await _firestore.collection('messages').add({
      'text': _messageController.text,
      'sender': 'current_user_name', // Replace with the current user's name
      'receiver': widget.user.name,
      'timestamp': FieldValue.serverTimestamp(),
      'participants': [
        widget.user.name,
        'current_user_name'
      ], // List of participants
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message.sender ==
                        'current_user_name'; // Replace with current user's name
                    return ListTile(
                      title: Text(
                        message.text,
                        textAlign: isSender ? TextAlign.end : TextAlign.start,
                      ),
                      subtitle: Text(
                        message.timestamp?.toDate().toString() ?? '',
                        textAlign: isSender ? TextAlign.end : TextAlign.start,
                      ),
                      tileColor: isSender ? Colors.blue[100] : Colors.grey[200],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String sender;
  final Timestamp? timestamp;

  Message({required this.text, required this.sender, this.timestamp});

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      text: doc['text'],
      sender: doc['sender'],
      timestamp: doc['timestamp'],
    );
  }
}
