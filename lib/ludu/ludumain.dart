import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'main_screen.dart';

class LuduGame extends StatefulWidget {
  const LuduGame({super.key});

  @override
  State<LuduGame> createState() => _LuduGameState();
}

class _LuduGameState extends State<LuduGame> {
  @override
  void initState() {
    ///Initialize images and precache it
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        precacheImage(const AssetImage("assets/images/thankyou.gif"), context),
        precacheImage(const AssetImage("assets/images/board.png"), context),
        precacheImage(const AssetImage("assets/images/dice/1.png"), context),
        precacheImage(const AssetImage("assets/images/dice/2.png"), context),
        precacheImage(const AssetImage("assets/images/dice/3.png"), context),
        precacheImage(const AssetImage("assets/images/dice/4.png"), context),
        precacheImage(const AssetImage("assets/images/dice/5.png"), context),
        precacheImage(const AssetImage("assets/images/dice/6.png"), context),
        precacheImage(const AssetImage("assets/images/dice/draw.gif"), context),
        precacheImage(const AssetImage("assets/images/crown/1st.png"), context),
        precacheImage(const AssetImage("assets/images/crown/2nd.png"), context),
        precacheImage(const AssetImage("assets/images/crown/3rd.png"), context),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
