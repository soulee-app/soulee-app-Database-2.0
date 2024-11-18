import 'package:flutter/material.dart';
import 'package:navbar/feed_page/comment_screen/CommentScreen.dart';
import 'package:navbar/feed_page/component/feed_image_view.dart';
import '../../all_profile_screen/profile_screen/widgets/custom_mask_widget.dart';
import '../../all_profile_screen/profile_screen/widgets/custome_text.dart';
import '../../all_profile_screen/profile_screen/widgets/heading_text.dart';
import 'comment_button.dart';

class FeedCard extends StatelessWidget {
  final String imagePath; // Path to the image or video
  final String title; // Title text
  final String source; // Source of the feed (e.g., channel, user)
  final String time; // Time or duration
  final String comments; // Comment count as text
  final String likes; // Like count as text
  final String pending; // Pending actions or indicators (customize as needed)
  final double aspectRatio; // Aspect ratio of the media
  final bool isVideo; // Whether the card is a video
  final String videoUrl; // URL for the video
  final String postId; // ID of the post for comments
  final String postOwnerId; // ID of the post owner for notifications

  const FeedCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.source,
    required this.time,
    required this.comments,
    required this.likes,
    required this.pending,
    required this.aspectRatio,
    this.isVideo = false,
    this.videoUrl = '', // Default to an empty string if not a video
    required this.postId, // Pass the postId
    required this.postOwnerId, // Post owner ID for notifications
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomMaskWidget(image: 'assets/Souls(1).png'),
                  Expanded(
                    child: HeadingText(
                      text: title,
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomText(text: source, fontSize: 13),
                  const SizedBox(width: 5),
                  CustomText(text: time, fontSize: 13),
                  const SizedBox(width: 5),
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Placeholder for a connection feature or action
                      },
                      icon: const Icon(
                        Icons.people_outlined,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedImageView(
                  postId: postId,
                  postOwnerId: postOwnerId,
                ),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Material(
              color: Colors.blue,
              child: isVideo
                  ? const Text(
                      'Video Player Placeholder') // Placeholder for custom video player
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: Row(
            children: [
              CommentButton(
                commentText: comments,
                assetImagePath: 'assets/flowers/Rui.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        postId: postId,
                        postOwnerId: postOwnerId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
              CommentButton(
                commentText: likes,
                assetImagePath: 'assets/Icons/Comment.png',
                onTap: () {
                  // Placeholder for like functionality
                },
              ),
              const SizedBox(width: 5),
              const CommentButton(
                commentText: 'Coming Soon',
                iconData: Icons.currency_exchange_sharp,
              ),
              const Spacer(),
              CommentButton(
                commentText: '8',
                assetImagePath: 'assets/Share.png',
                onTap: () {
                  // Placeholder for share functionality
                },
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
      ],
    );
  }
}
