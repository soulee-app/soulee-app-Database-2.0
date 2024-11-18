import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.image,
    this.isNetworkImage = false,
    this.isMask = true,
  });

  final String image;
  final bool isNetworkImage;
  final bool isMask;

  @override
  Widget build(BuildContext context) {
    if (isMask) {

      return WidgetMask(
        childSaveLayer: true,
        blendMode: BlendMode.srcATop,
        mask: isNetworkImage
            ? Image.network(
          image,
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        )
            : Image.asset(
          image,
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
        child: Image.asset(
          'assets/Deformed Circle.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {

      return isNetworkImage
          ? Image.network(
        image,
        height: 100,
        width: 100,
        fit: BoxFit.contain,
      )
          : Image.asset(
        image,
        height: 100,
        width: 100,
        fit: BoxFit.contain,
      );
    }
  }
}
