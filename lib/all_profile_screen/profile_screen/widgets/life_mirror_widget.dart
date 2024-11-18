import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LifeMirrorWidget extends StatelessWidget {
  const LifeMirrorWidget({
    super.key,
    required this.image,
    this.isNetworkImage = false,
    this.onTap, // Optional onTap callback
  });

  final String image;
  final bool isNetworkImage;
  final VoidCallback? onTap; // Declare onTap as a nullable callback

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger onTap when tapped
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: isNetworkImage
            ? Image.network(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
            : Image.asset(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
