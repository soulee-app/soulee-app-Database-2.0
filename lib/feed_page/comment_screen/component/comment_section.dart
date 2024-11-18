import 'package:flutter/material.dart';

import '../../../all_profile_screen/profile_screen/widgets/custom_mask_widget.dart';
import '../../../widgest/heading_text.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: CustomMaskWidget(image: 'assets/Souls(1).png'),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TANBIR Hossain',
                  ),
                  Text('data'),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: HeadingText(
              text:
                  ' সংগঠন ছাত্রলীগকে নিষিদ্ধ করেছে সরকার। সংগঠন ছাত্রলীগকে নিষিদ্ধ করেছে সরকার।',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
