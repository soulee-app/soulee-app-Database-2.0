import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart';

import '../models/chat_user.dart';
import '../models/message.dart';
import '../models/call.dart';
import 'notification_access_token.dart';

class APIs {
  // for authentication
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using Soulee!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });

    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  static Future<void> sendPushNotification(ChatUser chatUser, String msg,
      {String? callType, String? callId}) async {
    try {
      // Construct the notification body with optional call data
      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me.name, // Sender's name
            "body": msg, // Message content or call notification
          },
          "data": {
            "type": callType != null
                ? "call"
                : "message", // Indicates 'call' or 'message'
            if (callType != null)
              "callType": callType, // 'audio' or 'video' (optional for calls)
            if (callId != null)
              "callId": callId, // Unique call ID (optional for calls)
            "fromId": me.id, // Sender's user ID
            "toId": chatUser.id // Receiver's user ID
          }
        }
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'soulee-database';

      // Get Firebase Admin token
      final bearerToken = await NotificationAccessToken.getToken;

      log('bearerToken: $bearerToken');

      // Handle null token
      if (bearerToken == null) return;

      // Make the API call to FCM
      var res = await post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        APIs.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using Soulee!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where('id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type,
      [String? fileName]) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time,
        fileName: fileName);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //send voice
  static Future<void> sendVoice(ChatUser chatUser, File file) async {
    // Getting voice file extension
    final ext = file.path.split('.').last;

    // Storage file reference with path
    final ref = FirebaseStorage.instance.ref().child(
        'voices/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // Uploading voice
    await ref
        .putFile(file, SettableMetadata(contentType: 'audio/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // Updating voice in Firestore database
    final voiceUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, voiceUrl, Type.voice);
  }

//send attachment
  static Future<void> sendAttachmentFile(ChatUser chatUser, File file) async {
    // Getting file name and extension
    final fileName = file.path.split('/').last; // Extracts name with extension
    final ext = fileName.split('.').last;

    // Determine content type based on file extension
    String contentType = _getContentType(ext);

    // Storage file ref with path
    final ref = storage.ref().child(
        'attachments/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // Uploading file with correct content type
    await ref
        .putFile(file, SettableMetadata(contentType: contentType))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // Updating file URL in Firestore database
    final fileUrl = await ref.getDownloadURL();

    // Sending message with the file name and extension instead of just the URL
    await sendMessage(chatUser, fileUrl, Type.attachment,
        fileName); // Use fileName to show `name.type`
  }

// Helper function to determine content type based on file extension
  static String _getContentType(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      default:
        return 'application/octet-stream'; // fallback for unknown types
    }
  }

// Video call initiation
  static Future<void> startVideoCall(ChatUser chatUser) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Call call = Call(
      toId: chatUser.id,
      fromId: user.uid,
      callId: time,
      callType: 'video',
      callStatus: 'initiated',
      startedAt: time,
    );

    // Save the call in calls/{conversationID}/video
    final collectionPath = 'calls/${getConversationID(chatUser.id)}/video';
    print('Collection Path: $collectionPath'); // Log for debugging

    final ref = firestore.collection(collectionPath);

    try {
      // Save the call data to Firestore
      await ref.doc(time).set(call.toJson());
      // Send push notification with call type and call ID
      sendPushNotification(chatUser, 'Incoming video call...',
          callType: 'video', callId: time);

      // Send a message indicating a video call has started
      await sendMessage(chatUser, 'Incoming video call...', Type.videoCall);
    } catch (e) {
      print('Error saving video call to Firestore: $e');
    }
  }

// Send ICE candidate to Firestore
  static Future<void> sendIceCandidate(
      ChatUser chatUser, Map<String, dynamic> candidate) async {
    try {
      // Add ICE candidate to Firestore (auto-generate unique doc IDs for each candidate)
      await firestore
          .collection('calls')
          .doc(chatUser.id)
          .collection('candidates')
          .add(candidate);
    } catch (e) {
      print('Error sending ICE candidate: $e');
    }
  }

// Listen for signaling (SDP offer/answer and ICE candidates)
  static Future<void> listenForSignaling(
      String callId, RTCPeerConnection peerConnection) async {
    try {
      // Listen for ICE candidates from the remote peer
      firestore
          .collection('calls')
          .doc(callId)
          .collection('candidates')
          .snapshots()
          .listen((snapshot) async {
        for (var doc in snapshot.docChanges) {
          if (doc.type == DocumentChangeType.added) {
            var candidateData = doc.doc.data();
            if (candidateData != null) {
              RTCIceCandidate candidate = RTCIceCandidate(
                candidateData['candidate'],
                candidateData['sdpMid'],
                candidateData['sdpMLineIndex'],
              );
              try {
                // await peerConnection.addIceCandidate(candidate);
              } catch (e) {
                print('Error adding ICE candidate: $e');
              }
            }
          }
        }
      });

      // Listen for SDP offer/answer signaling
      firestore
          .collection('calls')
          .doc(callId)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.exists) {
          var data = snapshot.data()!;
          if (data.containsKey('sdp')) {
            try {
              if (data['type'] == 'offer') {
                await peerConnection.setRemoteDescription(
                    RTCSessionDescription(data['sdp'], 'offer'));
              } else if (data['type'] == 'answer') {
                await peerConnection.setRemoteDescription(
                    RTCSessionDescription(data['sdp'], 'answer'));
              }
            } catch (e) {
              print('Error setting remote description: $e');
            }
          }
        }
      });
    } catch (e) {
      print('Error listening for signaling: $e');
    }
  }

// Clean up after the call (end call and remove Firestore documents)
  static Future<void> endCall(String callId) async {
    try {
      // Delete the call document from Firestore
      await firestore.collection('calls').doc(callId).delete();
      print('Call ended and cleaned up');
    } catch (e) {
      print('Error ending call: $e');
    }
  }

// Audio call
  static Future<void> startAudioCall(ChatUser chatUser) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Call call = Call(
      toId: chatUser.id,
      fromId: user.uid,
      callId: time,
      callType: 'audio',
      callStatus: 'initiated',
      startedAt: time,
    );

    // Save the call in calls/{conversationID}/audio
    final collectionPath = 'calls/${getConversationID(chatUser.id)}/audio';
    print('Collection Path: $collectionPath'); // Log for debugging

    final ref = firestore.collection(collectionPath);

    try {
      // Save the call data to Firestore
      await ref.doc(time).set(call.toJson());
      // Send push notification with callType and callId
      sendPushNotification(chatUser, 'Incoming audio call...',
          callType: 'audio', // Audio call type
          callId: time // Unique call ID
          );

      // Send a message indicating an audio call has started
      await sendMessage(chatUser, 'Incoming audio call...', Type.audioCall);
    } catch (e) {
      print('Error saving audio call to Firestore: $e');
    }
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}
