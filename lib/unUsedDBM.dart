import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ********** USER MANAGEMENT **********

  Future<bool> signUpUser({
    required String email,
    required String password,
    required String name,
    required String dob,
    required String gender,
    required String username,
    required String phone,
    File? imageFile,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user?.uid ?? '';

      String? imageUrl;
      if (imageFile != null) {
        final ref = _storage.ref().child('user_images').child('$uid.jpg');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'dob': dob,
        'gender': gender,
        'username': username,
        'phone': phone,
        'email': email,
        'profileImageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        return snapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Get User Data Error: $e");
    }
    return null;
  }

  Future<bool> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final userId = _auth.currentUser?.uid;
      await _firestore.collection('users').doc(userId).update(updates);
      return true;
    } catch (e) {
      print("Update Profile Error: $e");
      return false;
    }
  }

  Future<void> updateUserProfileBio(String bio) async {
    try {
      // Retrieve the current user's ID
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      // Update the bio field in Firestore
      await _firestore.collection('users').doc(userId).update({
        'bio': bio,
      });
    } catch (e) {
      print("Error updating bio: $e");
      rethrow;
    }
  }

  // ********** MEMORY MANAGEMENT **********

  Future<String?> uploadMemoryImage(File imageFile, String userId) async {
    try {
      final ref = _storage
          .ref()
          .child('memories/$userId/${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image Upload Error: $e");
      return null;
    }
  }

  Future<void> addMemory(String userId, Map<String, dynamic> memoryData) async {
    try {
      await _firestore.collection('users/$userId/memories').add({
        ...memoryData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Add Memory Error: $e");
    }
  }

  Future<void> deleteMemory(String userId, String memoryId) async {
    try {
      await _firestore
          .collection('users/$userId/memories')
          .doc(memoryId)
          .delete();
    } catch (e) {
      print("Delete Memory Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getUserMemories(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('users/$userId/memories').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Get Memories Error: $e");
      return [];
    }
  }

  // ********** POST MANAGEMENT **********

  Future<String?> uploadPostImage(File imageFile, String userId) async {
    try {
      final ref = _storage
          .ref()
          .child('posts/$userId/${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Post Image Upload Error: $e");
      return null;
    }
  }

  Future<void> createPost(Map<String, dynamic> postData) async {
    try {
      await _firestore.collection('posts').add({
        ...postData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Create Post Error: $e");
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print("Delete Post Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getFeedPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('posts').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Get Feed Posts Error: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Get User Posts Error: $e");
      return [];
    }
  }

  // ********** NOTIFICATION MANAGEMENT **********

  Future<void> addNotification(
      String userId, Map<String, dynamic> notificationData) async {
    try {
      await _firestore.collection('users/$userId/notifications').add({
        ...notificationData,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Add Notification Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('users/$userId/notifications').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Get Notifications Error: $e");
      return [];
    }
  }

  // ********** FIREBASE AUTH ERROR HANDLING **********

  String getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This user has been disabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // ********** ZONE MANAGEMENT **********

  Future<List<Map<String, dynamic>>> fetchZoneData(String category) async {
    try {
      final snapshot = await _firestore.collection(category).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching $category data: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      QuerySnapshot snapshot = await _firestore
          .collection('users/$userId/notifications')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {
                'title': doc['title'] ?? 'No Title',
                'message': doc['message'] ?? 'No Message',
                'time': (doc['timestamp'] as Timestamp).toDate().toString(),
              })
          .toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  // Utility function for Firestore errors
  String getFirestoreErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'The service is temporarily unavailable. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // ********** FETCH DATA FOR SLIDES **********

  Future<Map<String, dynamic>?> fetchFirstSlideTwoData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();

      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Fetch First Slide Two Data Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchProfileSlideData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();

      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Fetch Profile Slide Data Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchSecondSlideData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      QuerySnapshot snapshot = await _firestore
          .collection('users/$userId/memories')
          .orderBy('createdAt', descending: true)
          .get();

      return {
        'memories': snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList(),
      };
    } catch (e) {
      print("Fetch Second Slide Data Error: $e");
      return null;
    }
  }

  // ********** MEMORY MANAGEMENT EXTENDED **********

  Future<String?> uploadMemory(
      File file, Map<String, Object?> memoryData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      final imageUrl = await uploadMemoryImage(file, userId);
      if (imageUrl != null) {
        memoryData['imageUrl'] = imageUrl;
        await addMemory(userId, memoryData);
        return imageUrl;
      }
      return null;
    } catch (e) {
      print("Upload Memory Error: $e");
      return null;
    }
  }

  // ********** POST MANAGEMENT EXTENDED **********

  Future<void> uploadPost(
      List<File> selectedImages, Map<String, Object?> postData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      List<String> imageUrls = [];
      for (var image in selectedImages) {
        final imageUrl = await uploadPostImage(image, userId);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }
      postData['imageUrls'] = imageUrls;
      postData['userId'] = userId;

      await createPost(postData);
    } catch (e) {
      print("Upload Post Error: $e");
    }
  }

  // ********** USER DATA MANAGEMENT **********

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();

      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Get User Data Error: $e");
      return null;
    }
  }

  // ********** KNOT DATA MANAGEMENT **********

  static Future<Map<String, dynamic>?> fetchKnotData() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final userId = auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      DocumentSnapshot snapshot =
          await firestore.collection('knots').doc(userId).get();

      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Fetch Knot Data Error: $e");
      return null;
    }
  }

  Future<String?> getFcmToken(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot['fcmToken'] as String?;
      }
    } catch (e) {
      print("Get FCM Token Error: $e");
    }
    return null;
  }

  Future<void> setFcmToken(String userId, String fcmToken) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': fcmToken,
      });
    } catch (e) {
      print("Set FCM Token Error: $e");
    }
  }

  // ********** Helper Functions **********

  // Calculate age based on date of birth
  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  // Calculate Zodiac Sign based on date of birth
  String calculateZodiacSign(DateTime dob) {
    int day = dob.day;
    int month = dob.month;
    // A simple zodiac calculation
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return "Aries";
    // Add other signs similarly...
    return "Unknown";
  }

  // ********** USER PROFILE FUNCTIONS **********

  Future<void> updateProfileAvatar(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('user_avatars').child('$userId.jpg');
      await ref.putFile(imageFile);
      String avatarUrl = await ref.getDownloadURL();
      await _firestore.collection('users').doc(userId).update({
        'profile_avatar': avatarUrl,
      });
    } catch (e) {
      print("Error updating avatar: $e");
    }
  }

  Future<void> updateCoverImage(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('cover_images').child('$userId.jpg');
      await ref.putFile(imageFile);
      String coverUrl = await ref.getDownloadURL();
      await _firestore.collection('users').doc(userId).update({
        'cover_image': coverUrl,
      });
    } catch (e) {
      print("Error updating cover image: $e");
    }
  }

  Future<void> updateBio(String userId, String bio) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'bio': bio,
      });
    } catch (e) {
      print("Error updating bio: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }

  // ********** FRIEND / KNOT MANAGEMENT **********

  Future<void> addFriend(String userId, String friendId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .set({
        'status': 'requested',
        'friendSince': FieldValue.serverTimestamp(),
      });
      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .set({
        'status': 'pending',
        'friendSince': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding friend: $e");
    }
  }

  Future<void> updateFriendStatus(
      String userId, String friendId, String status) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .update({
        'status': status,
      });
      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .update({
        'status': status,
      });
    } catch (e) {
      print("Error updating friend status: $e");
    }
  }

  // ********** QUIZZ AND PREFERENCES MANAGEMENT **********

  Future<void> updateQuizzTags(
      String userId, String mainTag, String secondaryTag) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'main_tag': mainTag,
        'secondary_tag': secondaryTag,
      });
    } catch (e) {
      print("Error updating quiz tags: $e");
    }
  }

  // ********** RETRIEVE USER POSTS **********

  Future<List<Map<String, dynamic>>> fetchUserPosts(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

  updateUserMainTag({required String mainTag}) {}
}
