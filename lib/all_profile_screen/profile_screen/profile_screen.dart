import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/all_profile_screen/profile_screen/postpage.dart';
import 'package:navbar/all_profile_screen/profile_screen/second_slid_screen.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/custom_appbar.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/custom_text_button.dart';
import 'package:widget_mask/widget_mask.dart';
import '../../widgest/custom_text.dart';
import 'first_slide_screen.dart';
import 'add_memory_page.dart';
import 'package:intl/intl.dart';


class ProfileScreen extends StatefulWidget {
  final DatabaseManager databaseManager;

  const ProfileScreen({super.key, required this.databaseManager});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PageController _profilePageController = PageController();
  final PageController _contentPageController = PageController();
  double _currentProfilePage = 0;
  double _currentContentPage = 0;
  late DatabaseManager databaseManager;

  // Firebase data holders with default values
  String _name = "Tanbir Hossain";
  String _age = "24";
  String _secondaryTag = "Fur Parent";
  String _gender = "Male";
  String _birthday = "June 4";
  List<String> _profileImages = [
    'assets/img.png', // Default local asset images
    'assets/Souls(1).png'
  ];

  @override
  void initState() {
    super.initState();
    databaseManager = widget.databaseManager;
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final userData = await databaseManager.fetchUserProfileData();

      // Update state with the fetched data
      setState(() {
        _name = userData['name'] ?? _name;
        _age = userData['age']?.toString() ?? _age;
        _secondaryTag = userData['secondaryTag'] ?? "Default Tag";
        _gender = userData['gender'] ?? _gender;
        //_birthday = userData['dob'] ?? _birthday;
        _birthday = userData['dob'] != null ? DateFormat('dd/MM').format(DateTime.parse(userData['dob'])) : _birthday;

        // Include profileImageUrl and avatarUrl in the profile images list
        _profileImages = [
          if (userData['profile_image'] != null) userData['profile_image'],
          if (userData['avatarUrl'] != null) userData['avatarUrl'],
        ];

        // Ensure fallback to default local images if no URLs provided
        if (_profileImages.isEmpty) {
          _profileImages = [
            'assets/img.png',
            'assets/Souls(1).png',
          ];
        }
      });
    } catch (e) {
      print("Error fetching profile data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch profile data.")),
        );
      }
    }
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
      body: Stack(
        children: [
          Container(color: Colors.white),
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
            top: screenHeight * 0.28,
            child: Column(
              children: [
                SizedBox(
                  height: screenWidth * 0.28,
                  width: screenWidth * 0.28,
                  child: PageView.builder(
                    controller: _profilePageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentProfilePage = index.toDouble();
                      });
                    },
                    itemCount: _profileImages.length,
                    itemBuilder: (context, index) {
                      return _profileImages[index].startsWith('http')
                          ? WidgetMask(
                              childSaveLayer: true,
                              blendMode: BlendMode.srcATop,
                              mask: Image.network(
                                _profileImages[index],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.broken_image,
                                    size: screenWidth * 0.28,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                              child: Image.asset(
                                'assets/Deformed Circle.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : WidgetMask(
                              childSaveLayer: true,
                              blendMode: BlendMode.srcATop,
                              mask: Image.asset(
                                _profileImages[index],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.broken_image,
                                    size: screenWidth * 0.28,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                              child: Image.asset(
                                'assets/Deformed Circle.png',
                                fit: BoxFit.cover,
                              ),
                            );
                    },
                  ),
                ),
                DotsIndicator(
                  dotsCount:
                      _profileImages.isNotEmpty ? _profileImages.length : 2,
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
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.33,
            left: screenWidth * 0.28,
            child: Row(
              children: [
                CustomText(text: _name, icon: Icons.person),
                SizedBox(width: screenWidth * 0.01),
                CustomText(text: '$_age', icon: Icons.cake),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.38,
            left: screenWidth * 0.23,
            child: Row(
              children: [
                CustomText(text: _secondaryTag, icon: Icons.pets),
                SizedBox(width: screenWidth * 0.01),
                CustomText(text: _gender, icon: Icons.female),
                SizedBox(width: screenWidth * 0.01),
                CustomText(text: _birthday, icon: Icons.calendar_month),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.45,
            left: screenWidth * 0.24,
            child: Row(
              children: [
                CustomTextButton(
                  text: 'Post',
                  icon: Icons.upload,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostPage(
                              databaseManager: widget.databaseManager)),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.02),
                CustomTextButton(
                  text: 'Add A Memory',
                  icon: Icons.image,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMemoryPage(
                              databaseManager: widget.databaseManager)),
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
                      FirstSlideScreen(databaseManager: widget.databaseManager),
                      SecondSlideScreen(
                          databaseManager: widget.databaseManager),
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
