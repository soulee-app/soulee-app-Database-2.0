import 'dart:io';

import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class SingUpCustomImage extends StatelessWidget {
  const SingUpCustomImage({
    super.key,
    required this.imageFile,
    this.height = 100.0,
    this.width = 100.0,
  });

  final File imageFile;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return WidgetMask(
      childSaveLayer: true,
      blendMode: BlendMode.srcATop,
      mask: Image.file(
        imageFile,
        height: height,
        width: width,
        fit: BoxFit.cover,
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
