import 'package:flutter/cupertino.dart';
import 'package:widget_mask/widget_mask.dart';

class SmallWidgetMaskImage extends StatelessWidget {
  const SmallWidgetMaskImage({super.key, required this.image, required this.isNetworkImage});

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
        height: 20,
        width: 20,
        fit: BoxFit.cover,
      )
          : Padding(
            padding: const EdgeInsets.all(2.5),
            child: Image.asset(
                    image,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
          ),
      child: Image.asset(
        'assets/Deformed Circle.png',
        height: 20,
        width: 20,
        fit: BoxFit.cover,
      ),
    );
  }
}
