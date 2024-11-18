import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/all_profile_screen/profile_screen/second_slid_screen.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../widgest/custom_text.dart';
import '../profile_screen/add_memory_page.dart';
import '../profile_screen/first_slide_two(dosent_need).dart';
import '../profile_screen/postpage.dart';
import '../profile_screen/widgets/custom_appbar.dart';
import '../profile_screen/widgets/custom_text_button.dart';

class CustomKnotScreen extends StatefulWidget {
  const CustomKnotScreen({super.key});

  @override
  State<CustomKnotScreen> createState() => _CustomKnotScreenState();
}

class _CustomKnotScreenState extends State<CustomKnotScreen> {
  final PageController _profilePageController = PageController();
  final PageController _contentPageController = PageController();
  final DatabaseManager _databaseManager = DatabaseManager();
  double _currentProfilePage = 0;
  double _currentContentPage = 0;

  // Sample dynamic data (in a real scenario, load this from a database)
  final List<Map<String, dynamic>> userProfiles = [
    {
      'name': 'Tanbir Hossain',
      'age': 24,
      'tag': 'Fur parent',
      'gender': 'Female',
      'birthDate': 'June 4',
      'profileImage': 'assets/img.png'
    },
    {
      'name': 'User Two',
      'age': 25,
      'tag': 'Tech Savvy',
      'gender': 'Male',
      'birthDate': 'July 15',
      'profileImage': 'assets/Souls(1).png'
    },
  ];

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
      body: Stack(
        children: [
          // Background Cover
          _buildBackgroundCover(screenHeight),

          // Custom App Bar
          Positioned(
            top: screenHeight * 0.03,
            left: 0,
            right: 0,
            child: const CustomAppbar(),
          ),

          // Profile Image Carousel and Info
          Positioned(
            top: screenHeight * 0.27,
            child: Column(
              children: [
                _buildProfileImageCarousel(screenWidth),
                _buildProfileDotsIndicator(screenWidth),
              ],
            ),
          ),

          // User Information
          Positioned(
            top: screenHeight * 0.33,
            left: screenWidth * 0.32,
            child: _buildUserInfo(screenWidth),
          ),

          Positioned(
            top: screenHeight * 0.38,
            left: screenWidth * 0.27,
            child: _buildUserTags(screenWidth),
          ),

          // Action Buttons
          Positioned(
            top: screenHeight * 0.45,
            left: screenWidth * 0.16,
            child: _buildActionButtons(screenWidth),
          ),

          // Bottom Content Pages with Indicator
          Positioned(
            bottom: 0,
            child: _buildContentPages(screenHeight, screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCover(double screenHeight) {
    return Container(
      height: screenHeight * 0.35,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Cover.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImageCarousel(double screenWidth) {
    return SizedBox(
      height: screenWidth * 0.32,
      width: screenWidth * 0.32,
      child: PageView(
        controller: _profilePageController,
        onPageChanged: (index) {
          setState(() {
            _currentProfilePage = index.toDouble();
          });
        },
        children: userProfiles.map((profile) {
          return _buildMaskedProfileImage(profile['profileImage']);
        }).toList(),
      ),
    );
  }

  Widget _buildMaskedProfileImage(String imagePath) {
    return WidgetMask(
      childSaveLayer: true,
      blendMode: BlendMode.srcATop,
      mask: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
      child: Image.asset(
        'assets/Deformed Circle.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProfileDotsIndicator(double screenWidth) {
    return DotsIndicator(
      dotsCount: userProfiles.length,
      position: _currentProfilePage,
      decorator: DotsDecorator(
        shape: const CircleBorder(),
        size: Size(screenWidth * 0.03, screenWidth * 0.03),
        activeSize: Size(screenWidth * 0.03, screenWidth * 0.03),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        color: Colors.grey,
        activeColor: const Color(0xFFFF675C),
      ),
    );
  }

  Widget _buildUserInfo(double screenWidth) {
    final profile = userProfiles[_currentProfilePage.toInt()];
    return Row(
      children: [
        CustomText(
          text: profile['name'],
          icon: Icons.person,
        ),
        SizedBox(width: screenWidth * 0.01),
        CustomText(
          text: profile['age'].toString(),
          icon: Icons.cake,
        ),
      ],
    );
  }

  Widget _buildUserTags(double screenWidth) {
    final profile = userProfiles[_currentProfilePage.toInt()];
    return Row(
      children: [
        CustomText(
          text: profile['tag'],
          icon: Icons.pets,
        ),
        SizedBox(width: screenWidth * 0.01),
        CustomText(
          text: profile['gender'],
          icon: profile['gender'] == 'Female' ? Icons.female : Icons.male,
        ),
        SizedBox(width: screenWidth * 0.01),
        CustomText(
          text: profile['birthDate'],
          icon: Icons.calendar_month,
        ),
      ],
    );
  }

  Widget _buildActionButtons(double screenWidth) {
    return Row(
      children: [
        CustomTextButton(
          text: 'Custom Knot',
          icon: Icons.nat_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PostPage(databaseManager: _databaseManager)),
            );
          },
        ),
        SizedBox(width: screenWidth * 0.02),
        CustomTextButton(
          text: 'Get A Report',
          icon: Icons.report,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMemoryPage(
                        databaseManager: _databaseManager,
                      )),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContentPages(double screenHeight, double screenWidth) {
    return Column(
      children: [
        DotsIndicator(
          dotsCount: 2,
          position: _currentContentPage,
          decorator: DotsDecorator(
            size: Size.square(screenWidth * 0.03),
            activeSize: Size(screenWidth * 0.03, screenWidth * 0.03),
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
              const FirstSlideTwo(),
              SecondSlideScreen(databaseManager: _databaseManager),
            ],
          ),
        ),
      ],
    );
  }
}
