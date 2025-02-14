import 'package:flutter/cupertino.dart';

import 'picker.dart';

class GameModePicker extends StatelessWidget {
  final Map<int, Text> playerCountOptions = const <int, Text>{
    1: Text('One Player'),
    2: Text('Two Player')
  };

  final int playerCount;
  final Function(int?) setFunc;

  const GameModePicker(this.playerCount, this.setFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Game Mode',
      options: playerCountOptions,
      selection: playerCount,
      setFunc: setFunc,
    );
  }
}
