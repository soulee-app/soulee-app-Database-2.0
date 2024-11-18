import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navbar/NotificationService.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final String postOwnerId; // Owner of the post

  const CommentScreen(
      {super.key, required this.postId, required this.postOwnerId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();

  Future<void> _addComment(String commentText) async {
    if (commentText.isEmpty) return;

    try {
      // Add comment to Firestore
      await _firestore
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'text': commentText,
        'userId': _auth.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _commentController.clear();

      // Fetch post owner's FCM token
      final postOwnerDoc =
          await _firestore.collection('users').doc(widget.postOwnerId).get();
      final postOwnerToken = postOwnerDoc['fcmToken'];

      if (postOwnerToken != null) {
        // Send notification to the post owner
        await _notificationService.sendNotification(
          recipientToken: postOwnerToken,
          title: "New Comment!",
          body: "Someone commented on your post.",
          notificationType: "comment",
        );
      }
    } catch (e) {
      debugPrint("Error adding comment: $e");
    }
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              _addComment(_commentController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No comments yet"));
        }

        final comments = snapshot.data!.docs;
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person), // Replace with user profile image
              ),
              title: Text(comment['text'] ?? ''),
              subtitle: Text(
                comment['timestamp'] != null
                    ? (comment['timestamp'] as Timestamp).toDate().toString()
                    : 'Just now',
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: Column(
        children: [
          Expanded(child: _buildCommentsList()),
          _buildCommentInput(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
