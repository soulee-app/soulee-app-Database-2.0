import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class CustomMaskWidget extends StatelessWidget {
  const CustomMaskWidget({
    super.key,
    required this.image,
    this.isNetworkImage = false,
  });

  final String image;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
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
  }
}
