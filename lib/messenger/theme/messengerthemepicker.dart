import 'package:flutter/cupertino.dart';

import '../models/messengertheme.dart';

class MessengerThemePicker extends StatelessWidget {
  final int themeIndex;
  final Function(int) onThemeChanged;

  const MessengerThemePicker({super.key, 
    required this.themeIndex,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text('App Theme', style: TextStyle(fontSize: 16)),
        ),
        Container(
          height: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0x20000000),
          ),
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: themeIndex,
            ),
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              background: Color(0x20000000),
            ),
            itemExtent: 50,
            onSelectedItemChanged: onThemeChanged,
            children: messengerthemeList
                .map(
                  (theme) => Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(theme.name ?? ""),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
