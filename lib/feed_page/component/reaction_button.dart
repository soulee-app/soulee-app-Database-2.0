import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navbar/NotificationService.dart';

class ReactionButtonDemo extends StatefulWidget {
  final String postId;
  final String postOwnerId; // Owner of the post

  const ReactionButtonDemo(
      {super.key, required this.postId, required this.postOwnerId});

  @override
  _ReactionButtonDemoState createState() => _ReactionButtonDemoState();
}

class _ReactionButtonDemoState extends State<ReactionButtonDemo> {
  Reaction<String>? _selectedReaction;
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _selectedReaction = Reaction<String>(
      value: 'Daisy',
      icon: _buildReactionIcon('assets/flowers/Orchid.png', 'Daisy'),
    );
  }

  Future<void> _updateReactionCount(String reaction) async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(widget.postId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) {
          throw Exception("Post does not exist!");
        }

        // Get current reaction counts
        Map<String, dynamic> reactions = snapshot.data()?['reactions'] ?? {};

        // Increment the selected reaction count
        reactions[reaction] = (reactions[reaction] ?? 0) + 1;

        // Update Firestore with the new reaction counts
        transaction.update(postRef, {'reactions': reactions});
      });

      // Fetch the post owner's FCM token
      final postOwnerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.postOwnerId)
          .get();
      final postOwnerToken = postOwnerDoc['fcmToken'];

      if (postOwnerToken != null) {
        // Send notification to the post owner about the new reaction
        await _notificationService.sendNotification(
          recipientToken: postOwnerToken,
          title: "New Reaction!",
          body:
              "${_auth.currentUser?.displayName ?? 'Someone'} reacted to your post.",
          notificationType: "reaction",
        );
      }

      debugPrint("Reaction '$reaction' count updated successfully.");
    } catch (e) {
      debugPrint("Failed to update reaction count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xEDE1C9C7),
      borderRadius: BorderRadius.circular(12),
      child: ReactionButton<String>(
        onReactionChanged: (Reaction<String>? reaction) {
          setState(() {
            _selectedReaction = reaction;
          });
          if (reaction?.value != null) {
            _updateReactionCount(reaction!
                .value!); // Update Firestore with the selected reaction
            debugPrint('Selected value: ${reaction.value}');
          }
        },
        reactions: <Reaction<String>>[
          Reaction<String>(
            value: 'Daisy',
            icon: _buildReactionIcon('assets/flowers/Orchid.png', 'Daisy'),
          ),
          Reaction<String>(
            value: 'Ful',
            icon: _buildReactionIcon('assets/flowers/Ful.png', 'Ful'),
          ),
          Reaction<String>(
            value: 'Gada',
            icon: _buildReactionIcon('assets/flowers/Gada.png', 'Gada'),
          ),
          Reaction<String>(
            value: 'Golap',
            icon: _buildReactionIcon('assets/flowers/Golap 1.png', 'Golap'),
          ),
        ],
        selectedReaction: _selectedReaction,
        itemSize: const Size(88, 40),
        animateBox: true,
        boxPadding: const EdgeInsets.symmetric(vertical: 2),
      ),
    );
  }

  Widget _buildReactionIcon(String asset, String label) {
    return SizedBox(
      height: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          children: [
            Image.asset(
              asset,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
