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

class GetAKnotScreen extends StatefulWidget {
  const GetAKnotScreen({super.key});

  @override
  State<GetAKnotScreen> createState() => _GetAKnotScreenState();
}

class _GetAKnotScreenState extends State<GetAKnotScreen> {
  final PageController _profilePageController = PageController();
  final PageController _contentPageController = PageController();
  final DatabaseManager _databaseManager = DatabaseManager();
  double _currentProfilePage = 0;
  double _currentContentPage = 0;

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

          // App Bar
          Positioned(
            top: screenHeight * 0.03,
            left: 0,
            right: 0,
            child: const CustomAppbar(),
          ),

          // Profile Image Carousel
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
                    children: [
                      _buildMaskedImage('assets/img.png'),
                      _buildMaskedImage('assets/Souls(1).png'),
                    ],
                  ),
                ),
                DotsIndicator(
                  dotsCount: 2,
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

          // Profile Information Section
          Positioned(
            top: screenHeight * 0.33,
            left: screenWidth * 0.32,
            child: Row(
              children: [
                const CustomText(
                  text:
                      'Tanbir Hossain', // Use dynamic user data here if available
                  icon: Icons.person,
                ),
                SizedBox(width: screenWidth * 0.01),
                const CustomText(
                  text: '24', // Use dynamic user age here if available
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
                const CustomText(
                  text: 'Fur parent', // Dynamic tag if available
                  icon: Icons.pets,
                ),
                SizedBox(width: screenWidth * 0.01),
                const CustomText(
                  text: 'Female', // Dynamic gender if available
                  icon: Icons.female,
                ),
                SizedBox(width: screenWidth * 0.01),
                const CustomText(
                  text: 'June 4', // Dynamic date if available
                  icon: Icons.calendar_month,
                ),
              ],
            ),
          ),

          // Button Section
          Positioned(
            top: screenHeight * 0.45,
            left: screenWidth * 0.05,
            child: Row(
              children: [
                CustomTextButton(
                  text: 'Knotted',
                  icon: Icons.upload,
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
                  text: 'Text',
                  icon: Icons.message,
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
                SizedBox(width: screenWidth * 0.02),
                CustomTextButton(
                  text: 'Get A Knot Report',
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
            ),
          ),

          // Content Area at Bottom
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
                      const FirstSlideTwo(),
                      SecondSlideScreen(
                        databaseManager: _databaseManager,
                      ),
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

  // Helper method to create masked images for the profile carousel
  Widget _buildMaskedImage(String imagePath) {
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
}
