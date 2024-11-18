import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:navbar/DatabaseManager.dart';
import 'package:xml/xml.dart';

class PostPage extends StatefulWidget {
  final DatabaseManager databaseManager;

  const PostPage({super.key, required this.databaseManager});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  String? _selectedGifUrl;
  String? _pollQuestion;
  List<String> _pollOptions = [];
  bool _isUploading = false; // Added _isUploading to manage upload state
  final List<TextEditingController> _pollOptionControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  late DatabaseManager databaseManager;

  @override
  void initState() {
    super.initState();
    databaseManager = widget.databaseManager;
  }

  @override
  void dispose() {
    _postController.dispose();
    for (var controller in _pollOptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleImageSelection() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  Future<void> _handleGifSelection() async {
    const apiKey =
        'YOUR_GIPHY_API_KEY'; // Replace with your actual Giphy API key
    final url = Uri.parse(
        'https://api.giphy.com/v1/gifs/trending?api_key=$apiKey&limit=10&rating=g');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final gifs = List<Map<String, dynamic>>.from(
            (json.decode(response.body)['data'] as List)
                .map((gif) => {'url': gif['images']['fixed_height']['url']}));

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Choose a GIF"),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: gifs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGifUrl = gifs[index]['url'];
                      });
                      Navigator.pop(context);
                    },
                    child: Image.network(gifs[index]['url'], height: 100),
                  );
                },
              ),
            ),
          ),
        );
      } else {
        print('Failed to load GIFs: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching GIFs: $e");
    }
  }

  Future<void> _showPollDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create a Poll"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Poll Question',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _pollQuestion = value;
                      });
                    },
                  ),
                  ..._pollOptionControllers.map((controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText:
                              'Option ${_pollOptionControllers.indexOf(controller) + 1}',
                        ),
                      ),
                    );
                  }),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _pollOptionControllers.add(TextEditingController());
                      });
                    },
                    child: const Text("Add another option"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _pollOptions = _pollOptionControllers
                          .map((controller) => controller.text)
                          .where((option) => option.isNotEmpty)
                          .toList();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save Poll"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _uploadPost() async {
    final content = _postController.text.trim();

    // Validate post content
    if (content.isEmpty && _selectedImages.isEmpty && _selectedGifUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some content to post")),
      );
      return;
    }

    // Verify post with RSS feed
    final verified = await _verifyPostWithRssFeed(content);
    if (!verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Post content is not verified by the RSS feed")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Delegate to DatabaseManager
      await widget.databaseManager.addPost(
        content: content,
        mediaFiles: _selectedImages.isNotEmpty ? _selectedImages : null,
        gifUrl: _selectedGifUrl,
        pollQuestion: _pollQuestion,
        pollOptions: _pollOptions,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post uploaded successfully")),
      );

      // Navigate back after successful upload
      Navigator.of(context).pop();
    } catch (e) {
      print("Failed to upload post: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload post")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<bool> _verifyPostWithRssFeed(String content) async {
    const rssUrl = 'https://www.prothomalo.com/feed/';
    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');
        for (var item in items) {
          final title = item.findElements('title').single.text;
          if (content.contains(title)) {
            return false;
          }
        }
        return true;
      } else {
        print("RSS feed not accessible: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error parsing RSS feed: $e");
      return false;
    }
  }

  Widget _buildImageGrid() {
    if (_selectedImages.isEmpty) return const SizedBox.shrink();
    if (_selectedImages.length == 1) {
      return Image.file(
        _selectedImages[0],
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    } else if (_selectedImages.length == 2) {
      return Row(
        children: _selectedImages.map<Widget>((file) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1.0,
        ),
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Image.file(
            _selectedImages[index],
            fit: BoxFit.cover,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _uploadPost,
            child: _isUploading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Text(
                  "Your Username",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _postController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: "What's happening?",
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            _buildImageGrid(),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.redAccent),
                  onPressed: _handleImageSelection,
                ),
                IconButton(
                  icon: const Icon(Icons.gif, color: Colors.redAccent),
                  onPressed: _handleGifSelection,
                ),
                IconButton(
                  icon: const Icon(Icons.poll, color: Colors.redAccent),
                  onPressed: _showPollDialog,
                ),
                const Spacer(),
                TextButton(
                  onPressed: _isUploading ? null : _uploadPost,
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
