import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navbar/DatabaseManager.dart';

class AddMemoryPage extends StatefulWidget {
  final DatabaseManager databaseManager;

  const AddMemoryPage({super.key, required this.databaseManager});

  @override
  _AddMemoryPageState createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends State<AddMemoryPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _selectedRatio;
  String _caption = "";
  final List<String> _tags = [];
  bool _isUploading = false;
  String _visibility = 'Everyone';
  late DatabaseManager databaseManager;

  @override
  void initState() {
    super.initState();
    databaseManager = widget.databaseManager;
  }

  Future<void> _pickImage(String ratio) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedRatio = ratio;
      });
    }
  }

  Future<void> _uploadMemory() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Prepare memory data
      final memoryData = {
        'caption': _caption,
        'tags': _tags,
        'ratio': _selectedRatio,
        'visibility': _visibility,
      };

      // Upload memory using DatabaseManager
      await widget.databaseManager.uploadMemory(
        _selectedImage!,
        memoryData,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memory uploaded successfully!')),
      );

      // Navigate back after successful upload
      Navigator.of(context).pop();
    } catch (e) {
      print("Error uploading memory: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading memory: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _addTag() {
    TextEditingController tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Tag"),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(hintText: "Enter a tag"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tagController.text.isNotEmpty) {
                  setState(() {
                    _tags.add(tagController.text);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Memory'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.person, size: 35, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _visibility,
                      items:
                          ['Everyone', 'Buddies', 'Custom'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _visibility = value ?? 'Everyone';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'SELECT SIZE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _selectedImage == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSizeOption('3:2', 120, 80),
                        _buildSizeOption('1:1', 80, 80),
                        _buildSizeOption('16:9', 80, 140),
                      ],
                    )
                  : _buildSelectedImagePreview(),
              const SizedBox(height: 20),
              const Text(
                'ADD YOUR FEELINGS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type Here',
                  filled: true,
                  fillColor: Colors.redAccent.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _caption = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'TAGS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addTag,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Add a Tag'),
              ),
              const SizedBox(height: 20),
              _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _uploadMemory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Save Memory'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeOption(String ratio, double width, double height) {
    return GestureDetector(
      onTap: () {
        _pickImage(ratio);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            ratio,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Stack(
      children: [
        Container(
          width: _getPreviewWidth(),
          height: _getPreviewHeight(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.redAccent),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Wrap(
            spacing: 5,
            children: _tags
                .map((tag) => Chip(
                      label: Text(tag,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.redAccent,
                      deleteIconColor: Colors.white,
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                    ))
                .toList(),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _caption,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedImage = null;
                _selectedRatio = null;
              });
            },
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  double _getPreviewHeight() {
    switch (_selectedRatio) {
      case '3:2':
        return 200;
      case '1:1':
        return 300;
      case '16:9':
        return 225;
      default:
        return 200;
    }
  }

  double _getPreviewWidth() {
    switch (_selectedRatio) {
      case '3:2':
        return 300;
      case '1:1':
        return 300;
      case '16:9':
        return 400;
      default:
        return 300;
    }
  }
}
