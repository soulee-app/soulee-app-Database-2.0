// comment_button.dart
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final String commentText;
  final IconData? iconData;
  final String? assetImagePath;
  final VoidCallback? onTap;

  const CommentButton({
    super.key,
    required this.commentText,
    this.iconData,
    this.assetImagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 30,
        child: Material(
          color: const Color(0xEDE1C9C7),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Row(
              children: [
                assetImagePath != null
                    ? Image.asset(
                        assetImagePath!,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      )
                    : Icon(iconData ?? Icons.comment, size: 20),
                const SizedBox(width: 5),
                Text(commentText, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
