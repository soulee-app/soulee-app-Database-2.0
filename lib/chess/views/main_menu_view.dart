import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_screens/games_screen.dart';
import '../model/chess_app_model.dart';
import 'components/main_menu_view/game_options.dart';
import 'components/main_menu_view/main_menu_buttons.dart';
import 'components/shared/bottom_padding.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChessAppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    10, MediaQuery.of(context).padding.top + 10, 10, 0),
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 20),
              GameOptions(appModel),
              const SizedBox(height: 10),
              MainMenuButtons(appModel),
              const BottomPadding(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GameScreeen()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Back To All Game",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFF675C),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xFFFF675C),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
