import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../model/chess_app_model.dart';
import '../../../model/app_themes.dart';
import '../shared/text_variable.dart';

class AppThemePicker extends StatelessWidget {
  const AppThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChessAppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const TextSmall('App Theme'),
          ),
          Container(
            height: 120,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0x20000000),
            ),
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: appModel.themeIndex,
              ),
              selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                background: Color(0x20000000),
              ),
              itemExtent: 50,
              onSelectedItemChanged: appModel.setTheme,
              children: themeList
                  .map(
                    (theme) => Container(
                      padding: const EdgeInsets.all(10),
                      child: TextRegular(theme.name ?? ""),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
