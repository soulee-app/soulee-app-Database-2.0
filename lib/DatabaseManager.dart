import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:navbar/UserData.dart';
import 'package:navbar/all_profile_screen/profile_screen/model/affliations.dart';

class DatabaseManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserData _userdata = UserData();
  UserData get userData => _userdata;
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;

  // Sign up a new user and create Firestore document
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
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? profileImageUrl;

      // Upload profile image
      if (profileImage != null) {
        final ref =
            _storage.ref().child('profile_images/${userCredential.user!.uid}');
        final uploadTask = ref.putFile(profileImage);
        final snapshot = await uploadTask;
        profileImageUrl = await snapshot.ref.getDownloadURL();
      }

      // Calculate additional details
      final int age = DateTime.now().year - dob.year;
      String zodiacSign = _calculateZodiacSign(dob).toString();

      // Save user data to Firestore
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

      return true;
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }

  // Log in an existing user
  Future<void> logIn(User user) async {
    try {
      // Fetch and store user data locally
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        _userdata = UserData.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('User document does not exist.');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signOutUser() async => _auth.signOut();

  // Fetch user data
  Future<UserData> fetchUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return UserData.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  String _calculateZodiacSign(DateTime dob) {
    final int day = dob.day;
    final int month = dob.month;

    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return "Aquarius";
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return "Pisces";
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return "Aries";
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return "Taurus";
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return "Gemini";
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return "Cancer";
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return "Leo";
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return "Virgo";
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return "Libra";
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
      return "Scorpio";
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return "Sagittarius";
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return "Capricorn";
    return "Unknown";
  }

  // Adding a new post
  Future<void> addPost({
    required String content,
    List<File>? mediaFiles,
    String? gifUrl,
    String? pollQuestion,
    List<String>? pollOptions,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;

      // Fetch user details
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User data not found.');
      }

      final userData = userDoc.data();
      final authorName = userData?['name'] ?? 'Unknown User';
      final authorProfilePic = userData?['profilePic'] ?? 'assets/defImg.png';

      final List<String> mediaUrls = [];

      // Upload media files if provided
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          final mediaUrl = await uploadMedia(file, 'posts/$userId/media');
          mediaUrls.add(mediaUrl);
        }
      }

      // Prepare the post data
      final postData = {
        'userId': userId,
        'authorName': authorName, // Add author's name
        'authorProfilePic': authorProfilePic, // Add author's profile picture
        'text': content,
        'gif': gifUrl,
        'pollQuestion': pollQuestion,
        'pollOptions': pollOptions,
        'mediaUrls': mediaUrls,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the post to Firestore
      await _firestore.collection('posts').add(postData);
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }


  // Fetch posts for the feed
  Future<List<Map<String, dynamic>>> fetchFeedPosts() async {
    try {
      final userId = _auth.currentUser!.uid;
      if (userId == null) throw Exception('User ID not found.');

      // Fetch the user's friend list
      final friendList = await getFriendList();
      final friendIds = friendList.map((friend) => friend['friendId']).toList();

      // Fetch posts by the user and their friends
      final querySnapshot = await _firestore
          .collection('posts')
          .where('userId', whereIn: [userId, ...friendIds])
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> posts = [];

      for (var doc in querySnapshot.docs) {
        final postData = doc.data();

        // Fetch the user data for the post's author
        final userDoc = await _firestore.collection('users').doc(postData['userId']).get();
        final userData = userDoc.exists ? userDoc.data() : null;

        posts.add({
          ...postData,
          'authorName': userData?['name'] ?? 'Unknown User',
          'authorProfilePic': userData?['profilePic'] ?? 'assets/defImg.png',
        });
      }

      return posts;
    } catch (e) {
      throw Exception('Failed to fetch feed posts: $e');
    }
  }


  // Fetch posts for a user's profile
  Future<List<Map<String, dynamic>>> fetchProfilePosts(String userId) async {
    try {
      // Fetch posts from the user's profile
      final querySnapshot = await _firestore
          .collection('posts') // Assuming posts are stored in a top-level collection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> posts = [];

      for (var doc in querySnapshot.docs) {
        final postData = doc.data();

        // Fetch the user data for the post's author
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final userData = userDoc.exists ? userDoc.data() : null;

        posts.add({
          ...postData,
          'authorName': userData?['name'] ?? 'Unknown User',
          'authorProfilePic': userData?['profilePic'] ?? 'assets/defImg.png',
        });
      }

      return posts;
    } catch (e) {
      throw Exception('Failed to fetch profile posts: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchProfileMemories(String userId) async {
    try {
      // Fetch memories associated with the user's profile
      final querySnapshot = await _firestore
          .collection('memory') // Assuming memories are stored in a top-level collection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> memories = [];

      for (var doc in querySnapshot.docs) {
        final memoryData = doc.data();

        // Fetch the user data for the memory's owner
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final userData = userDoc.exists ? userDoc.data() : null;

        memories.add({
          ...memoryData,
          'ownerName': userData?['name'] ?? 'Unknown User',
          'ownerProfilePic': userData?['profilePic'] ?? 'assets/defImg.png',
        });
      }

      return memories;
    } catch (e) {
      throw Exception('Failed to fetch profile memories: $e');
    }
  }



  // Like a post
  Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await postRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // Add a comment to a post
  Future<void> addComment(String postId, String userId, String comment) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await postRef.collection('comments').add({
        'userId': userId,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Fetch comments for a post
  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp')
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
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

  // Upload media file to Firebase Storage
  Future<String> uploadMedia(File mediaFile, String folder) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${mediaFile.path.split('/').last}';
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = ref.putFile(mediaFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  // Upload memory
  Future<void> uploadMemory(
      File imageFile, Map<String, dynamic> memoryData) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User is not authenticated.');

      final userId = currentUser.uid;

      // Upload image to storage
      final imageUrl = await uploadMedia(imageFile, 'memories/$userId');

      // Validate memoryData and add required fields
      memoryData['imageUrl'] = imageUrl;
      memoryData['userId'] = userId;
      memoryData['timestamp'] = FieldValue.serverTimestamp();
      memoryData['visibility'] = memoryData['visibility'] ?? 'Everyone'; // Default

      // Save memory data to Firestore
      await _firestore.collection('memory').add(memoryData);
    } catch (e) {
      print('Error in uploadMemory: $e'); // Log error for debugging
      throw Exception('Failed to upload memory: $e');
    }
  }


  // Fetch memories for a user's profile page
  Future<List<Map<String, dynamic>>> fetchMemories(String userId,
      {String visibility = 'Everyone'}) async {
    try {
      final querySnapshot = await _firestore
          .collection('memory')
          .where('userId', isEqualTo: userId)
          .where('visibility', isEqualTo: visibility) // Optional visibility filter
          .orderBy('timestamp', descending: true)
          .get();

      // Map documents to list of memory data
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error in fetchMemories: $e'); // Log error for debugging
      throw Exception('Failed to fetch memories: $e');
    }
  }


  // Update user profile bio
  Future<void> updateUserProfileBio(String bio) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

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
      if (userId == null) throw Exception('User not authenticated');

      await _firestore.collection('users').doc(userId).update({
        'music': albumName,
        'musicArtist': artistName,
        'musicImageUrl': albumImageUrl,
      });
      await refreshUserData();
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
      if (userId == null) throw Exception('User not authenticated');

      await _firestore.collection('users').doc(userId).update({
        'movie': movieName,
        'movieImageUrl': movieImageUrl,
      });
      await refreshUserData();
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
      if (userId == null) throw Exception('User not authenticated');

      await _firestore.collection('users').doc(userId).update({
        'book': bookName,
        'bookAuthor': bookAuthor,
        'bookImageUrl': bookImageUrl,
      });
      await refreshUserData();
    } catch (e) {
      throw Exception('Failed to update book preferences: $e');
    }
  }

  // Fetch data for the second slide screen
  Future<Map<String, dynamic>> fetchSecondSlideData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Initialize return data structure
      Map<String, dynamic> secondSlideData = {
        'memories': [],
        'zones': [],
        'feedPosts': [],
      };

      // Fetch memories
      final memoriesSnapshot = await _firestore
          .collection('memory') // Updated to fetch from 'memory' collection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(10) // Optional: Limit results for better performance
          .get();

      secondSlideData['memories'] = memoriesSnapshot.docs
          .map((doc) => doc['imageUrl'] as String)
          .toList();

      // Fetch zones
      final zonesSnapshot = await _firestore
          .collection('zones') // Assume zones are stored in a central 'zones' collection
          .where('members', arrayContains: userId) // Check if the user is a member
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
      secondSlideData['zones'] = zonesSnapshot.docs.map((doc) {
        return AffiliationData(
          text1: doc['name'] as String,
          text2: doc['description'] as String,
          image: doc['imageUrl'] as String,
        );
      }).toList();

      // Fetch feed posts
      final friendList = await getFriendList(); // Fetch user's friend list
      final friendIds = friendList.map((friend) => friend['friendId']).toList();
      final postsSnapshot = await _firestore
          .collection('posts')
          .where('userId', whereIn: [userId, ...friendIds]) // User's and friends' posts
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      secondSlideData['feedPosts'] =
          postsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      return secondSlideData;
    } catch (e) {
      print('Error fetching second slide data: $e'); // Log error for debugging
      throw Exception('Failed to fetch second slide data: $e');
    }
  }

  /*
  Future<Map<String, dynamic>> fetchSecondSlideData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

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
      throw Exception('Failed to fetch second slide data: $e');
    }
  }
  */
  // Update main tag from hobby quiz
  Future<void> updateUserMainTag({required String mainTag}) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).update({
        'mainTag': mainTag,
      });
    }
  }

  // Add friend to the user's friend list
  Future<void> addFriend({
    required String currentUserId,
    required String friendUserId,
  }) async {
    try {
      // Add friend to current user's friend list
      await _firestore
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
      await _firestore
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

  // Get current user's friend list
  Future<List<Map<String, dynamic>>> getFriendList() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
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

  // Get matched user for Knot page
  Future<Map<String, dynamic>?> fetchMatchedUser({
    required String mainTag,
    required List<String> compatibleTags,
    required String currentUserGender,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('No current user found');

      // Determine the opposite gender
      final oppositeGender =
          currentUserGender.toLowerCase() == "male" ? "female" : "male";

      // Query Firestore for users with compatible mainTags and opposite gender
      final matchedUsersQuery = await _firestore
          .collection('users')
          .where('mainTag', whereIn: compatibleTags)
          //.where('gender', isEqualTo: oppositeGender)
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      if (matchedUsersQuery.docs.isNotEmpty) {
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

  // Delete user account and all associated data
  Future<void> deleteUserAccount() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found.');
      }

      final uid = currentUser.uid;

      // Delete user's documents from Firestore
      await _firestore.collection('users').doc(uid).delete();

      // Delete associated data such as posts, memories, etc.
      final postSnapshots = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: uid)
          .get();
      for (var doc in postSnapshots.docs) {
        await doc.reference.delete();
      }

      // Delete user authentication record
      await currentUser.delete();

      print("User account and associated data deleted successfully.");
    } catch (e) {
      print("Error deleting user account: $e");
      throw Exception('Failed to delete user account: $e');
    }
  }

  // Refresh user data manually
  Future<void> refreshUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _userdata = UserData.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error refreshing user data: $e');
      throw Exception('Failed to refresh user data');
    }
  }

  // Periodically refresh user data
  void startPeriodicRefresh(Duration interval) {
    Timer.periodic(interval, (_) async {
      try {
        await refreshUserData();
      } catch (e) {
        print('Periodic refresh failed: $e');
      }
    });
  }

  Future<Map<String, dynamic>> fetchUserProfileData() async {
    try {
      // Get the current user's ID
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User is not authenticated.");

      // Fetch the user profile data from Firestore
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) throw Exception("User profile data not found.");

      // Return the user data as a Map
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Failed to fetch user profile data: $e");
    }
  }

}
