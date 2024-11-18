import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import '../api/apis.dart';

class ProfileImage extends StatelessWidget {
  final double size;
  final String? url;

  const ProfileImage({super.key, required this.size, this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size)),
      child: CachedNetworkImage(
        width: size,
        height: size,
        fit: BoxFit.cover,
        imageUrl: url ?? APIs.user.photoURL.toString(),
        errorWidget: (context, url, error) => Container(
            child: const Stack(
          children: [
            Image(image: AssetImage('assetsm/deformedcircle.png')),
            Center(child: Icon(CupertinoIcons.person)),
          ],
        )),
      ),
    );
  }
}
