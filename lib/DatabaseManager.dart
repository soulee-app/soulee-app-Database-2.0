import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:navbar/UserData.dart';
import 'package:navbar/all_profile_screen/profile_screen/model/affliations.dart';

class DatabaseManager {
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //_________________________________________________________________________________//
  //-------------------------Codes For Handling User Data----------------------------//

  // UserData class instance
  // will be used to store user basic data locally
  UserData _userdata = UserData();

  // Getter for the class variables
  UserData get userData => _userdata;
  FirebaseStorage get storage => _storage;
  FirebaseFirestore get firestore => _firestore;

  // Method to sign up a user and create Firestore document
  Future<bool> signUp({
    required String username,
    required String name,
    required DateTime dob,
    required String gender,
    required String bloodGroup,
    required String email,
    required String phone,
    required String password,
    File? profileImage,
  }) async {
    bool success = false;
    try {
      // Firebase Authentication signup
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? profileImageUrl;

      // Upload profile image if provided
      if (profileImage != null) {
        String uid = userCredential.user!.uid;
        Reference ref = _storage.ref().child('profile_images/$uid');
        UploadTask uploadTask = ref.putFile(profileImage);
        TaskSnapshot snapshot = await uploadTask;
        profileImageUrl = await snapshot.ref.getDownloadURL();
      }

      // Calculate additional fields
      int age = DateTime.now().year - dob.year;
      String zodiacSign = _calculateZodiacSign(dob);

      // Create Firestore user document
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': username,
        'name': name,
        'dob': dob.toIso8601String(),
        'age': age,
        'zodiac_sign': zodiacSign,
        'gender': gender,
        'blood_group': bloodGroup,
        'email': email,
        'phone': phone,
        'profile_image': profileImageUrl,
        'account_created': DateTime.now().toIso8601String(),
      });
      success = true;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }

    if (success) {
      return true;
    } else
      // ignore: dead_code
      return false;
  }

  // Method to log in a user
  Future<void> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Update local UserData instance
        _userdata = UserData.fromMap(userData);
      } else {
        throw Exception('User document does not exist.');
      }
    } catch (e) {
      throw Exception('Failed to log in: $e');
    }
  }

  // Method to fetch a user's data
  Future<UserData> fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return UserData.fromMap(userData);
      } else {
        throw Exception('User document does not exist.');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  // Method to log out the user
  Future<void> logOut() async {
    try {
      await _auth.signOut();
      _userdata = UserData(); // Clear local UserData instance
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  // Helper function to calculate zodiac sign in Area-51, i mean line 51
  String _calculateZodiacSign(DateTime dob) {
    final int day = dob.day;
    final int month = dob.month;

    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return "Aquarius";
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return "Pisces";
    } else if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return "Aries";
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return "Taurus";
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return "Gemini";
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return "Cancer";
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return "Leo";
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return "Virgo";
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return "Libra";
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return "Scorpio";
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return "Sagittarius";
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return "Capricorn";
    }
    return "Unknown";
  }

  // Fetch user data from Firestore
  // will use it if needed
  Future<void> refreshUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        _userdata = UserData.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error refreshing user data: $e");
    }
  }

  // Start periodic refresh
  void startPeriodicRefresh(Duration interval) {
    Timer.periodic(interval, (timer) async {
      await refreshUserData();
    });
  }

  //__________________________________________________________________________________//
  //----------------------------Codes For Handling posts------------------------------//

  //Adding new post
  Future<void> addPost({
    required String content,
    List<File>? mediaFiles,
    String? gifUrl,
    String? pollQuestion,
    List<String>? pollOptions,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      List<String> mediaUrls = [];

      // Upload media files
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          final mediaUrl = await uploadMedia(file, 'posts/$userId/media');
          mediaUrls.add(mediaUrl);
        }
      }

      // Prepare post data
      final postData = {
        'userId': userId,
        'text': content,
        'gif': gifUrl,
        'pollQuestion': pollQuestion,
        'pollOptions': pollOptions,
        'mediaUrls': mediaUrls,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save post data to Firestore
      await _firestore.collection('posts').add(postData);
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  // Getting posts from friends
  Future<List<Map<String, dynamic>>> fetchFeedPosts() async {
    try {
      // Get the current user's ID from userData in DatabaseManager
      final userId = userData.uid;
      if (userId == null) throw Exception('User ID not found');

      // Fetch the friend list for the current user
      final friendList = await getFriendList();
      final friendIds = friendList.map((friend) => friend['friendId']).toList();

      // Fetch posts for the current user and their friends
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where('userId',
              whereIn: [userId, ...friendIds]) // Current user and friends
          .orderBy('timestamp', descending: true)
          .get();

      // Map the query results to a list of post data
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch feed posts: $e');
    }
  }

  // Getting posets for current user profile
  Future<List<Map<String, dynamic>>> fetchProfilePosts(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch profile posts: $e');
    }
  }

  // Add Like on a post
  Future<void> likePost(String postId, String userId) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);

      // Add the user to the likes array
      await postRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // Add comment on a post
  Future<void> addComment(String postId, String userId, String comment) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);

      // Add the comment to the post's comments sub-collection
      await postRef.collection('comments').add({
        'userId': userId,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Get comments of a post
  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  // Delete Post (For future use)
  Future<void> deletePost(String postId, String userId) async {
    try {
      // Delete the post from the main posts collection
      await _firestore.collection('posts').doc(postId).delete();

      // Delete the post from the user's profile posts collection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .doc(postId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Upload a single media file to Firebase Storage
  Future<String> uploadMedia(File mediaFile, String folder) async {
    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${mediaFile.path.split('/').last}';
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putFile(mediaFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  // Upload memory
  Future<void> uploadMemory(
      File imageFile, Map<String, dynamic> memoryData) async {
    try {
      // Ensure the user is authenticated
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User is not authenticated.');
      }

      final userId = currentUser.uid;

      // Upload image to Firebase Storage
      String imageUrl = await uploadMedia(imageFile, 'memories/$userId');

      // Add image URL to memoryData
      memoryData['imageUrl'] = imageUrl;

      // Add metadata
      memoryData['userId'] = userId;
      memoryData['timestamp'] = FieldValue.serverTimestamp();

      // Save memory data under posts collection for efficient querying
      await _firestore.collection('posts').add(memoryData);
    } catch (e) {
      throw Exception('Failed to upload memory: $e');
    }
  }

  // Get memory in profile page
  // Fetch memories for a user's profile page
  Future<List<Map<String, dynamic>>> fetchMemories(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts') // Assuming memories are stored in posts
          .where('userId', isEqualTo: userId) // Filter by user ID
          .where('visibility',
              isEqualTo: 'Everyone') // Optional: filter visibility
          .orderBy('timestamp', descending: true) // Sort by most recent
          .get();

      // Convert the Firestore documents into a list of maps
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch memories: $e');
    }
  }

  // Update user bio
  Future<void> updateUserProfileBio(String bio) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await _firestore.collection('users').doc(userId).update({'bio': bio});
    } catch (e) {
      throw Exception('Failed to update bio: $e');
    }
  }

  // Update user music preferences
  Future<void> updateUserProfileMusic({
    String? albumName,
    String? artistName,
    String? albumImageUrl,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await _firestore.collection('users').doc(userId).update({
        'music': albumName,
        'musicArtist': artistName,
        'musicImageUrl': albumImageUrl,
      });
      refreshUserData();
    } catch (e) {
      throw Exception('Failed to update music preferences: $e');
    }
  }

  // Update user movie preferences
  Future<void> updateUserProfileMovie({
    String? movieName,
    String? movieImageUrl,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await _firestore.collection('users').doc(userId).update({
        'movie': movieName,
        'movieImageUrl': movieImageUrl,
      });
      refreshUserData();
    } catch (e) {
      throw Exception('Failed to update movie preferences: $e');
    }
  }

  // Update user book preferences
  Future<void> updateUserProfileBook({
    String? bookName,
    String? bookAuthor,
    String? bookImageUrl,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await _firestore.collection('users').doc(userId).update({
        'book': bookName,
        'bookAuthor': bookAuthor,
        'bookImageUrl': bookImageUrl,
      });
      refreshUserData();
    } catch (e) {
      throw Exception('Failed to update book preferences: $e');
    }
  }

  // Returns data for the second slide screen in profile page
  Future<Map<String, dynamic>> fetchSecondSlideData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated");

      // Fetch memories
      final memoriesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('memories')
          .get();
      final memories =
          memoriesSnapshot.docs.map((doc) => doc['imageUrl']).toList();

      // Fetch zones
      final zonesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('zones')
          .get();
      final zones = zonesSnapshot.docs.map((doc) {
        return AffiliationData(
          text1: doc['name'],
          text2: doc['description'],
          image: doc['imageUrl'],
        );
      }).toList();

      // Fetch feed posts
      final postsSnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      final feedPosts = postsSnapshot.docs.map((doc) => doc.data()).toList();

      return {
        'memories': memories,
        'zones': zones,
        'feedPosts': feedPosts,
      };
    } catch (e) {
      throw Exception("Failed to fetch second slide data: $e");
    }
  }

  // Codes for knot page

  // Finding a knot
  Future<Map<String, dynamic>?> fetchMatchedUser({
    required String mainTag,
    required List<String> compatibleTags,
    required String currentUserGender,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('No current user found');

      // Determine the opposite gender
      String oppositeGender =
          currentUserGender.toLowerCase() == "male" ? "female" : "male";

      // Query Firestore for users with compatible mainTags, opposite gender, excluding the current user
      final matchedUsersQuery = await firestore
          .collection('users')
          .where('mainTag', whereIn: compatibleTags)
          .where('gender',
              isEqualTo:
                  oppositeGender) // just comment this line if dont want only opposite gender knot
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      if (matchedUsersQuery.docs.isNotEmpty) {
        // Select a random user from the matched users
        final matchedDocs = matchedUsersQuery.docs;
        final randomIndex = Random().nextInt(matchedDocs.length);
        return matchedDocs[randomIndex].data();
      }

      return null; // No matched user found
    } catch (e) {
      print("Error fetching matched user: $e");
      throw Exception("Failed to fetch matched user: $e");
    }
  }

  //Function to add friend to users friend list
  Future<void> addFriend({
    required String currentUserId,
    required String friendUserId,
  }) async {
    try {
      // Add friend to current user's friend list
      await firestore
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendUserId)
          .set({
        'friendId': friendUserId,
        'status': 'connected',
        'friendSince': DateTime.now().toIso8601String(),
      });

      // Add current user to friend's friend list
      await firestore
          .collection('users')
          .doc(friendUserId)
          .collection('friends')
          .doc(currentUserId)
          .set({
        'friendId': currentUserId,
        'status': 'connected',
        'friendSince': DateTime.now().toIso8601String(),
      });

      print("Friends added successfully.");
    } catch (e) {
      print("Error adding friend: $e");
      throw Exception("Failed to add friend: $e");
    }
  }

  // Get current users friend list
  Future<List<Map<String, dynamic>>> getFriendList() async {
    try {
      // Ensure the user is authenticated and userData is loaded
      final currentUser = userData;
      if (currentUser.uid == null) {
        throw Exception('User not authenticated or user data unavailable');
      }

      // Fetch the friend list from the "friends" sub-collection
      QuerySnapshot friendQuery = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('friends')
          .get();

      // Map the friend documents to a list of friend data
      return friendQuery.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch friend list: $e');
    }
  }

  //update main tag from hobby quiz
  Future<void> updateUserMainTag({required String mainTag}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).update({
        'mainTag': mainTag,
      });
    }
  }
}
