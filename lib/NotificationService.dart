import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize Firebase Messaging
  Future<void> initFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Received a notification in foreground: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked with data: ${message.data}");
    });
  }

  // Store or update the FCM token in Firestore for the current user
  Future<void> updateUserFcmToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final fcmToken = await _firebaseMessaging.getToken();
        if (fcmToken != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'fcmToken': fcmToken,
          });
          print("FCM token updated successfully.");
        }
      }
    } catch (e) {
      print("Error updating FCM token: $e");
    }
  }

  // Send notification to a specific FCM token
  Future<void> sendNotification({
    required String title,
    required String body,
    required String recipientToken,
    required String notificationType, // FCM token of the recipient
  }) async {
    try {
      const String serverKey =
          'YOUR_FIREBASE_SERVER_KEY'; // Replace with your FCM server key

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': recipientToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
