import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/all_profile_screen/profile_screen/second_slid_screen.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/custom_appbar.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/custom_text_button.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../widgest/custom_text.dart';
import '../profile_screen/add_memory_page.dart';
import '../profile_screen/postpage.dart';

class LowCompatibilityScreen extends StatefulWidget {
  const LowCompatibilityScreen({super.key});

  @override
  State<LowCompatibilityScreen> createState() => _LowCompatibilityScreenState();
}

class _LowCompatibilityScreenState extends State<LowCompatibilityScreen> {
  final PageController _profilePageController = PageController();
  final PageController _contentPageController = PageController();
  final DatabaseManager _databaseManager = DatabaseManager();
  double _currentProfilePage = 0;
  double _currentContentPage = 0;
  List<Map<String, dynamic>> lowCompatibilityUsers = [];
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchLowCompatibilityUsers();
  }

  Future<void> _fetchLowCompatibilityUsers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data();
        });
        _loadOtherUsers(user.uid, userData?['mainTag']);
      }
    }
  }

  Future<void> _loadOtherUsers(String currentUserId, String? mainTag) async {
    if (mainTag == null) return;

    final usersCollection = FirebaseFirestore.instance.collection('users');
    final querySnapshot =
        await usersCollection.where('mainTag', isNotEqualTo: mainTag).get();

    final filteredUsers = querySnapshot.docs
        .where((doc) {
          final compatibilityScore =
              _calculateCompatibility(mainTag, doc['mainTag']);
          return doc.id != currentUserId && compatibilityScore < 60;
        })
        .map((doc) => doc.data())
        .toList();

    setState(() {
      lowCompatibilityUsers = filteredUsers;
    });
  }

  int _calculateCompatibility(String currentUserTag, String? otherUserTag) {
    if (otherUserTag == null) return 0;

    // Compatibility mapping based on main tags
    final compatibilityMatrix = {
      'Athlete': ['Traveller', 'Change maker'],
      'Nerd': ['Fan-fictioner', 'Artist'],
      'Tech savvy': ['Nerd', 'Traveller'],
      'Change maker': ['Artist', 'Fur parent'],
      'Fur parent': ['Nerd', 'Artist'],
      'Artist': ['Nerd', 'Change maker'],
      'Traveller': ['Athlete', 'Change maker'],
    };

    return compatibilityMatrix[currentUserTag]?.contains(otherUserTag) ?? false
        ? 50
        : 40;
  }

  @override
  void dispose() {
    _profilePageController.dispose();
    _contentPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  color: Colors.white,
                ),
                Container(
                  height: screenHeight * 0.35,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Cover.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.03,
                  left: 0,
                  right: 0,
                  child: const CustomAppbar(),
                ),
                Positioned(
                  top: screenHeight * 0.27,
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenWidth * 0.32,
                        width: screenWidth * 0.32,
                        child: PageView(
                          controller: _profilePageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentProfilePage = index.toDouble();
                            });
                          },
                          children: lowCompatibilityUsers.isNotEmpty
                              ? lowCompatibilityUsers.map((user) {
                                  return WidgetMask(
                                    childSaveLayer: true,
                                    blendMode: BlendMode.srcATop,
                                    mask: user['profileImage'] != null
                                        ? Image.network(
                                            user['profileImage'],
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset('assets/img.png'),
                                    child: Image.asset(
                                      'assets/Deformed Circle.png',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList()
                              : [
                                  const Center(
                                    child: Text(
                                      "No low-compatibility users found",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                ],
                        ),
                      ),
                      DotsIndicator(
                        dotsCount: lowCompatibilityUsers.isNotEmpty
                            ? lowCompatibilityUsers.length
                            : 1,
                        position: _currentProfilePage,
                        decorator: DotsDecorator(
                          shape: const CircleBorder(),
                          size: Size(screenWidth * 0.03, screenWidth * 0.03),
                          activeSize:
                              Size(screenWidth * 0.03, screenWidth * 0.03),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          color: Colors.grey,
                          activeColor: const Color(0xFFFF675C),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.33,
                  left: screenWidth * 0.32,
                  child: Row(
                    children: [
                      CustomText(
                        text: lowCompatibilityUsers.isNotEmpty
                            ? lowCompatibilityUsers[_currentProfilePage.toInt()]
                                    ['name'] ??
                                'Name'
                            : 'Name',
                        icon: Icons.person,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      CustomText(
                        text: lowCompatibilityUsers.isNotEmpty
                            ? (lowCompatibilityUsers[
                                        _currentProfilePage.toInt()]['age'] ??
                                    'N/A')
                                .toString()
                            : 'Age',
                        icon: Icons.cake,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.38,
                  left: screenWidth * 0.27,
                  child: Row(
                    children: [
                      CustomText(
                        text: lowCompatibilityUsers.isNotEmpty
                            ? lowCompatibilityUsers[_currentProfilePage.toInt()]
                                    ['petPreference'] ??
                                'Pet Preference'
                            : 'Pet Preference',
                        icon: Icons.pets,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      CustomText(
                        text: lowCompatibilityUsers.isNotEmpty
                            ? lowCompatibilityUsers[_currentProfilePage.toInt()]
                                    ['gender'] ??
                                'Gender'
                            : 'Gender',
                        icon: Icons.female,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      CustomText(
                        text: lowCompatibilityUsers.isNotEmpty
                            ? lowCompatibilityUsers[_currentProfilePage.toInt()]
                                    ['birthDate'] ??
                                'Birth Date'
                            : 'Birth Date',
                        icon: Icons.calendar_month,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.45,
                  left: screenWidth * 0.035,
                  child: Row(
                    children: [
                      CustomTextButton(
                        text: 'Low Compatibility',
                        icon: Icons.upload,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostPage(
                                databaseManager: _databaseManager,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      CustomTextButton(
                        text: 'Increase Compatibility',
                        icon: Icons.image,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMemoryPage(
                                databaseManager: _databaseManager,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      DotsIndicator(
                        dotsCount: 2,
                        position: _currentContentPage,
                        decorator: DotsDecorator(
                          size: Size.square(screenWidth * 0.03),
                          activeSize:
                              Size(screenWidth * 0.03, screenWidth * 0.03),
                          activeColor: const Color(0xFFFF675C),
                          color: Colors.grey,
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.47,
                        width: screenWidth,
                        child: PageView(
                          controller: _contentPageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentContentPage = index.toDouble();
                            });
                          },
                          children: [
                            SecondSlideScreen(
                                databaseManager: _databaseManager),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
