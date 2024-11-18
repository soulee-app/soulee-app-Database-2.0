import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/themes.dart';
import 'pages/home_page.dart';
import 'providers/theme_provider.dart';
import 'utils/theme_preferences.dart';

class WordGame extends StatelessWidget {
  const WordGame({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      initialData: false,
      future: ThemePreferences.getTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Provider.of<ThemeProvider>(context, listen: false)
                .setTheme(turnOn: snapshot.data ?? false);
          });
        }
        return Consumer<ThemeProvider>(
          builder: (_, notifier, __) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: notifier.isDark ? darkTheme : lightTheme,
            home: const Material(child: HomePage()),
          ),
        );
      },
    );
  }
}
