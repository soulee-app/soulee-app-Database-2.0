import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class CustomMaskWidget extends StatelessWidget {
  const CustomMaskWidget({
    super.key,
    required this.image,
    this.isNetworkImage = false,
    this.height = 100.0,
    this.width = 100.0,
  });

  final String image;
  final bool isNetworkImage;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return WidgetMask(
      childSaveLayer: true,
      blendMode: BlendMode.srcATop,
      mask: isNetworkImage
          ? Image.network(
        image,
        height: height,
        width: width,
        fit: BoxFit.contain,
      )
          : Image.asset(
        image,
        height: height,
        width: width,
        fit: BoxFit.contain,
      ),
      child: Image.asset(
        'assets/Deformed Circle.png',
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}
