import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/all_profile_screen/profile_screen/add_memory_page.dart';
import 'package:navbar/all_profile_screen/profile_screen/postpage.dart';

class StoryPage extends StatefulWidget {
  final List<String> memories; // Accept only string data (URLs)
  final DatabaseManager databaseManager;

  const StoryPage({
    super.key,
    required this.memories,
    required this.databaseManager,
  });

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late List<String> stories; // Store memory URLs here
  bool _isFabOpen = false;

  @override
  void initState() {
    super.initState();
    _initializeStories();
  }

  // Initialize stories using the memory URLs passed
  void _initializeStories() {
    stories = widget.memories;
  }

  void _toggleFab() {
    setState(() {
      _isFabOpen = !_isFabOpen;
    });
  }

  void _onFabOptionSelected(String choice) {
    switch (choice) {
      case 'Post Something':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PostPage(databaseManager: widget.databaseManager),
          ),
        );
        break;
      case 'Add Memories':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddMemoryPage(databaseManager: widget.databaseManager),
          ),
        );
        break;
      default:
        print("$choice selected");
    }
    _toggleFab();
  }

  Widget _buildStoryItem(String storyUrl) {
    return GestureDetector(
      onTap: () => _showFullImage(storyUrl), // Updated to use `storyUrl`
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: storyUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  void _showFullImage(String storyUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: storyUrl,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double pageViewHeight = screenHeight / 5; // Set height to 1/5 of the screen

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Memories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: pageViewHeight,
            child: stories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : CarouselSlider.builder(
                    itemCount: stories.length,
                    itemBuilder: (context, index, realIndex) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: _buildStoryItem(stories[index]),
                    ),
                    options: CarouselOptions(
                      height: pageViewHeight,
                      viewportFraction: 0.9,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isFabOpen) ...[
            FloatingActionButton.extended(
              onPressed: () => _onFabOptionSelected('Post Something'),
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.create),
              label: const Text('Post Something'),
              heroTag: 'post_something',
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () => _onFabOptionSelected('Add Memories'),
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.photo_library),
              label: const Text('Add Memories'),
              heroTag: 'add_memories',
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            onPressed: _toggleFab,
            backgroundColor: Colors.redAccent,
            child: Icon(_isFabOpen ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }
}
