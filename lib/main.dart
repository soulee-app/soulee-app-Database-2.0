import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:navbar/LoginPage/login_screen.dart';
import 'package:navbar/chess/model/chess_app_model.dart';
import 'package:navbar/feed_page/Reels/providers/video_provider.dart';
import 'package:navbar/ludu/ludo_provider.dart';
import 'package:navbar/word_game/providers/controller.dart';
import 'package:navbar/word_game/providers/theme_provider.dart';
import 'package:navbar/NotificationService.dart';
import 'package:provider/provider.dart';

late Size mq;

// Entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    await _notificationService.initFirebaseMessaging();
    await _notificationService.updateUserFcmToken();

    // Set up a handler for background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background notification handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase
        .initializeApp(); // Ensure Firebase is initialized for background handling
    print("Background message received: ${message.messageId}");
    // Additional background handling logic if required
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size; // Set mq for screen layout usage
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Controller()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChessAppModel()),
        ChangeNotifierProvider(create: (_) => LudoProvider()..startGame()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Soulee',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
