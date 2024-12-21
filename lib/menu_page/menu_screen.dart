import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navbar/all_profile_screen/profile_screen/profile_screen.dart';
import 'package:navbar/menu_page/components/menu_widgets.dart';
import 'package:navbar/menu_page/payment/paymentScreen.dart';
import '../LoginPage/login_screen.dart';
import 'package:navbar/DatabaseManager.dart'; // Import DatabaseManager

class MenuScreen extends StatefulWidget {
  final DatabaseManager databaseManager;

  const MenuScreen({super.key, required this.databaseManager});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _userName = 'User name';
  String _profileImage = 'assets/default_profile.png';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = widget.databaseManager.auth.currentUser?.uid;
      if (userId == null) return;

      // Fetch user data from DatabaseManager
      final userData = await widget.databaseManager.fetchUserData(userId);

      setState(() {
        _userName = userData.name ?? 'Unknown User';
        _profileImage =
            userData.profileImageUrl ?? 'assets/default_profile.png';
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'image': _profileImage,
        'isMask': true,
        'isNetworkImage': true,
        'text': _userName
      },
      {
        'image': 'assets/Settings.png',
        'isMask': false,
        'isNetworkImage': false,
        'text': 'Settings'
      },
      {
        'image': 'assets/Privacy.png',
        'isMask': false,
        'isNetworkImage': false,
        'text': 'Privacy'
      },
      {
        'image': 'assets/Help & Support.png',
        'isMask': false,
        'isNetworkImage': false,
        'text': 'Support'
      },
      {
        'image': 'assets/Soulee Premium.jpg',
        'isMask': false,
        'isNetworkImage': false,
        'text': 'Soulee Premium'
      },
      {
        'image': 'assets/Logout.png', // Add a logout icon
        'isMask': false,
        'isNetworkImage': false,
        'text': 'Logout'
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(width: 0.1),
                ),
                child: ListTile(
                  onTap: () async {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            databaseManager: widget.databaseManager,
                          ),
                        ),
                      );
                    } else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ),
                      );
                    } else if (index == 5) {
                      // Logout action
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: MenuWidget(
                      image: item['image'],
                      isMask: item['isMask'],
                      isNetworkImage: item['isNetworkImage'],
                    ),
                  ),
                  title: Text(
                    item['text'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
