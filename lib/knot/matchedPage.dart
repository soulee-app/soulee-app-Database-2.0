import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';

class MatchedPage extends StatefulWidget {
  final DatabaseManager databaseManager;

  const MatchedPage({super.key, required this.databaseManager});

  @override
  State<MatchedPage> createState() => _MatchedPageState();
}

class _MatchedPageState extends State<MatchedPage> {
  bool isLoading = true;
  Map<String, dynamic>? matchedUser;
  String? userMainTag;
  String? matchedUserMainTag;
  String userGender = '';
  int percentage = 0;

  // Tag compatibility map
  final Map<String, List<String>> tagCompatibility = {
    'Athlete': ['Traveller', 'Change maker'],
    'Nerd': ['Fan-fictioner', 'Artist'],
    'Tech savvy': ['Nerd', 'Traveller'],
    'Change maker': ['Artist', 'Fur parent'],
    'Fur parent': ['Nerd', 'Artist'],
    'Artist': ['Nerd', 'Change maker'],
    'Traveller': ['Athlete', 'Change maker'],
  };

  @override
  void initState() {
    super.initState();
    _fetchMatchedUserData();
  }

  Future<void> _fetchMatchedUserData() async {
    try {
      // Fetch current user's data from DatabaseManager
      final currentUserData = widget.databaseManager.userData;
      userMainTag = currentUserData.mainTag;
      userGender = currentUserData.gender!;

      if (userMainTag == null || !tagCompatibility.containsKey(userMainTag!)) {
        throw Exception('Invalid or missing main tag');
      }

      // Get compatible tags for current user's mainTag
      List<String> compatibleTags = tagCompatibility[userMainTag!]!;

      // Fetch a matched user from DatabaseManager
      final matchedUserData = await widget.databaseManager.fetchMatchedUser(
        mainTag: userMainTag!,
        compatibleTags: compatibleTags,
        currentUserGender: userGender,
      );

      if (matchedUserData != null) {
        matchedUser = matchedUserData;
        matchedUserMainTag = matchedUser?['mainTag'];

        // Calculate compatibility percentage
        if (userMainTag != null && matchedUserMainTag != null) {
          percentage = _calculateCompatibilityPercentage(
              userMainTag!, matchedUserMainTag!);
        } else {
          percentage = 50; // Default compatibility if tags are missing
        }

        // Add both users to each other's friend lists
        await widget.databaseManager.addFriend(
          currentUserId: currentUserData.uid!,
          friendUserId: matchedUser!['uid'],
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching matched user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  int _calculateCompatibilityPercentage(
      String mainUserTag, String matchedUserMainTag) {
    if (mainUserTag == 'Athlete' && matchedUserMainTag == 'Traveller') {
      return 85;
    } else if (mainUserTag == 'Athlete' &&
        matchedUserMainTag == 'Change maker') {
      return 70;
    } else if (mainUserTag == 'Nerd' && matchedUserMainTag == 'Fan-fictioner') {
      return 85;
    } else if (mainUserTag == 'Nerd' && matchedUserMainTag == 'Artist') {
      return 70;
    } else if (mainUserTag == 'Tech savvy' && matchedUserMainTag == 'Nerd') {
      return 85;
    } else if (mainUserTag == 'Tech savvy' &&
        matchedUserMainTag == 'Traveller') {
      return 70;
    } else if (mainUserTag == 'Change maker' &&
        matchedUserMainTag == 'Artist') {
      return 85;
    } else if (mainUserTag == 'Change maker' &&
        matchedUserMainTag == 'Fur parent') {
      return 70;
    } else if (mainUserTag == 'Fur parent' && matchedUserMainTag == 'Nerd') {
      return 85;
    } else if (mainUserTag == 'Fur parent' && matchedUserMainTag == 'Artist') {
      return 70;
    } else if (mainUserTag == 'Artist' && matchedUserMainTag == 'Nerd') {
      return 85;
    } else if (mainUserTag == 'Artist' &&
        matchedUserMainTag == 'Change maker') {
      return 70;
    } else if (mainUserTag == 'Traveller' && matchedUserMainTag == 'Athlete') {
      return 85;
    } else if (mainUserTag == 'Traveller' &&
        matchedUserMainTag == 'Change maker') {
      return 70;
    } else {
      return 50; // Default compatibility percentage
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchedUser != null
              ? _buildMatchedUserView(context, matchedUser!, screenWidth)
              : const Center(child: Text('No matches found')),
    );
  }

  Widget _buildMatchedUserView(
      BuildContext context, Map<String, dynamic> user, double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Image.asset('assets/knot/soulee.png', height: 60),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          "KNOTS",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset('assets/knot/Knot.png', height: 30),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          "CONNECTIONS",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              // Display matched user's avatar
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: user['profileImage'] != null
                      ? NetworkImage(user['profileImage'])
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    children: [
                      buildStaticQuizOption('assets/knot/n1.png', screenWidth),
                      buildStaticQuizOption('assets/knot/n2.png', screenWidth),
                      buildStaticQuizOption('assets/knot/n3.png', screenWidth),
                      buildStaticQuizOption('assets/knot/n4.png', screenWidth),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    top: 70,
                    child: Container(
                      color: Colors.yellow,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "MATCHED $percentage%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.yellow,
                      child: Text(
                        user['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.yellow,
                      child: Text(
                        user['age']?.toString() ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: const Column(
                        children: [
                          Text("TEXT"),
                          SizedBox(height: 5),
                          Text(
                            "04:59",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: const Text("KNOT REPORT"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStaticQuizOption(String imagePath, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Opacity(
        opacity: 0.4,
        child: Image.asset(
          imagePath,
          width: screenWidth,
          height: 80,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
