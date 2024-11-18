import 'package:flutter/material.dart';
import '../../all_profile_screen/profile_screen/widgets/custom_mask_widget.dart';
import '../../all_profile_screen/profile_screen/widgets/custome_text.dart';
import '../../all_profile_screen/profile_screen/widgets/heading_text.dart';
import '../comment_screen/CommentScreen.dart';
import 'comment_button.dart';

class FeedImageView extends StatelessWidget {
  final String postId;
  final String postOwnerId; // Add post owner ID for notification

  const FeedImageView(
      {super.key, required this.postId, required this.postOwnerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Cover.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomMaskWidget(
                    image: 'assets/Souls(1).png',
                    height: 80,
                    width: 80,
                  ),
                  Expanded(
                    child: HeadingText(
                      text: 'data',
                      textStyle: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const CustomText(text: 'Jamuna', fontSize: 13),
                  const SizedBox(width: 5),
                  const CustomText(text: '5M', fontSize: 13),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.people_outlined,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
                child: Row(
                  children: [
                    CommentButton(
                      commentText: "Comments",
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
                      commentText: "Likes",
                      assetImagePath: 'assets/Icons/Comment.png',
                      onTap: () {
                        // Placeholder for like action or navigation
                      },
                    ),
                    const Spacer(),
                    CommentButton(
                      commentText: '8',
                      assetImagePath: 'assets/Share.png',
                      onTap: () {
                        // Placeholder for share functionality
                      },
                    ),
                    const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
