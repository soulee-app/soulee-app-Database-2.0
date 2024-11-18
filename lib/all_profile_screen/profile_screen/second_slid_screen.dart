import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/all_profile_screen/profile_screen/memories.dart';
import '../../widgest/heading_text.dart';
import 'model/affliations.dart';

class SecondSlideScreen extends StatefulWidget {
  final DatabaseManager databaseManager;

  const SecondSlideScreen({super.key, required this.databaseManager});

  @override
  State<SecondSlideScreen> createState() => _SecondSlideScreenState();
}

class _SecondSlideScreenState extends State<SecondSlideScreen> {
  List<String> _memories = []; // For storing memory URLs
  List<AffiliationData> _zones = []; // For storing zones (communities)
  List<Map<String, dynamic>> _feedPosts = []; // For storing feed posts

  @override
  void initState() {
    super.initState();
    _loadSecondSlideData();
  }

  // Fetch memories, zones, and feed posts from DatabaseManager
  Future<void> _loadSecondSlideData() async {
    try {
      // Fetch all data from the database
      final data = await widget.databaseManager.fetchSecondSlideData();
      setState(() {
        _memories = data['memories'] ?? [];
        _zones = data['zones'] ?? [];
        _feedPosts = data['feedPosts'] ?? [];
      });
    } catch (e) {
      print("Error fetching second slide data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<AffiliationData> affiliations = _zones.isNotEmpty
        ? _zones
        : [
            AffiliationData(
              text1: 'Zone 1',
              text2: 'Description 1',
              image: 'assets/comingsoon.png',
            ),
            AffiliationData(
              text1: 'Zone 2',
              text2: 'Description 2',
              image: 'assets/comingsoon.png',
            ),
          ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Memories Section
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: HeadingText(text: 'MEMORIES'),
          ),
          SizedBox(
            height: 270,
            child: StoryPage(
              memories: _memories, // Pass memories to StoryPage
              databaseManager: widget.databaseManager,
            ), // Adjust StoryPage to use _memories data
          ),
          const SizedBox(height: 10),

          // Zones Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeadingText(text: 'ZONES'),
                HeadingText(text: 'MORE'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemCount: affiliations.length,
              itemBuilder: (context, index) {
                final data = affiliations[index];
                return Image.asset(data.image, fit: BoxFit.cover);
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          ),

          const SizedBox(height: 10),

          // Feed Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeadingText(text: "FEED", fontSize: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InstagramSearchGrid(feedPosts: _feedPosts),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InstagramSearchGrid extends StatelessWidget {
  final List<Map<String, dynamic>> feedPosts;
  final List<String> demoImages = [
    'assets/Cancer.png',
    'assets/Cover.png',
    'assets/Cancer.png',
    'assets/Cover.png',
    'assets/Cancer.png',
    'assets/Cover.png',
    'assets/Cancer.png',
    'assets/Cover.png',
    'assets/Cancer.png',
  ];

  InstagramSearchGrid({super.key, required this.feedPosts});

  @override
  Widget build(BuildContext context) {
    final isEmpty = feedPosts.isEmpty;

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
      itemCount: isEmpty ? demoImages.length : feedPosts.length,
      itemBuilder: (context, index) {
        if (isEmpty) {
          // Display demo images if no feed posts are available
          return Image.asset(demoImages[index], fit: BoxFit.cover);
        } else {
          // Display feed posts
          final post = feedPosts[index];
          final mediaUrl = post['mediaUrls']?.isNotEmpty == true
              ? post['mediaUrls'][0] // Use the first media URL
              : null;

          if (mediaUrl == null) {
            return const Center(child: Text("No media available"));
          }

          return Image.network(mediaUrl, fit: BoxFit.cover);
        }
      },
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
