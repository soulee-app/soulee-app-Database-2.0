import 'package:flutter/cupertino.dart';

import '../../shared/text_variable.dart';

class TimerWidget extends StatelessWidget {
  final Duration timeLeft;
  final Color color;

  const TimerWidget({super.key, required this.timeLeft, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(14),
          color: const Color(0x20000000),
        ),
        child: Center(
          child: TextRegular(_durationToString(timeLeft)),
        ),
      ),
    );
  }

  String _durationToString(Duration duration) {
    if (duration.inHours > 0) {
      String hours = duration.inHours.toString();
      String minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    } else if (duration.inMinutes > 0) {
      String minutes = duration.inMinutes.toString();
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      String seconds = duration.inSeconds.toString();
      return seconds;
    }
  }
}
