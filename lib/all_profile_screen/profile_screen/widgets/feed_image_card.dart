import 'package:flutter/cupertino.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/small_widget_mask_image.dart';

import 'custome_small_text.dart';
import 'feed_image_data.dart';

class FeedImageCard extends StatelessWidget {
  const FeedImageCard({super.key, required this.imageData});
  final ImageData imageData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageData.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSmallText(text: 'text'),
            Spacer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: SmallWidgetMaskImage(image: 'assets/images/Souls.png', isNetworkImage: false),
                  ),
                  SizedBox(width: 4,),
                  CustomSmallText(text: 'text'),
                  SizedBox(width: 4,),
                  CustomSmallText(text: 'text'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
