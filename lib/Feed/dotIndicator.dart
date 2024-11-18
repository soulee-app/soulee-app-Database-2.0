import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';

import 'package:navbar/Feed/zones.dart';
import 'package:navbar/feed_page/feed_screen.dart';

class DotIndicatorPage extends StatefulWidget {
  final dynamic databaseManager;

  const DotIndicatorPage({super.key, required this.databaseManager});

  @override
  _DotIndicatorPageState createState() => _DotIndicatorPageState();
}

class _DotIndicatorPageState extends State<DotIndicatorPage> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  late DatabaseManager databaseManager;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    databaseManager = widget.databaseManager;
    // Initialize _pages dynamically in initState
    _pages = [
      FeedScreen(databaseManager: widget.databaseManager),
      const ZonesPage(), // Keep const for static widgets
    ];
  }

  void _onDotTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Dot indicator row below the AppBar
          DotIndicator(
            currentIndex: _currentPageIndex,
            totalDots: _pages.length,
            onDotTapped: _onDotTapped,
          ),
          // PageView to switch between FeedScreen and ZonesPage
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

// lib/Feed/dot_indicator.dart

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  final Function(int) onDotTapped;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.totalDots,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => GestureDetector(
          onTap: () => onDotTapped(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: currentIndex == index ? 12 : 8,
            height: currentIndex == index ? 12 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? const Color.fromARGB(255, 223, 48, 83)
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
