import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navbar/LoginPage/login_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avatar Upload',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AvatarSelectionPage(),
    );
  }
}

class AvatarSelectionPage extends StatefulWidget {
  @override
  _AvatarSelectionPageState createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> avatarImages = [
    'assets/avatar1.png',
    'assets/avatar2.png',
    'assets/avatar3.png',
    'assets/avatar4.png',
    'assets/avatar5.png',
    'assets/avatar6.png',
  ];

  String? selectedAvatarPath;
  bool isUploading = false;

  // Convert asset image to a File
  Future<File> _getFileFromAsset(String assetPath) async {
    final byteData = await rootBundle.load(assetPath); // Load asset as bytes
    final tempDir = await getTemporaryDirectory(); // Get temp directory
    final file = File(
        '${tempDir.path}/${assetPath.split('/').last}'); // Save file in temp directory
    await file.writeAsBytes(byteData.buffer.asUint8List(
        byteData.offsetInBytes, byteData.lengthInBytes)); // Write bytes to file
    return file;
  }

  // Upload selected avatar to Firebase Storage
  Future<void> uploadAvatarToFirebase(String assetPath) async {
    try {
      setState(() {
        isUploading = true;
      });

      // Get the current user
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          isUploading = false;
        });
        return;
      }

      // Convert asset to a File
      File file = await _getFileFromAsset(assetPath);

      // Upload avatar to Firebase Storage
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      UploadTask uploadTask =
          _firebaseStorage.ref('avatars/${user.uid}/$fileName').putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Save URL to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'avatarUrl': downloadUrl,
      }, SetOptions(merge: true));

      setState(() {
        isUploading = false;
      });

      // Navigate to login screen after upload
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error uploading avatar: $e");
      setState(() {
        isUploading = false;
      });
    }
  }

  // Select an avatar
  void selectAvatar(String assetPath) {
    setState(() {
      selectedAvatarPath = assetPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Avatar")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Show progress indicator during upload
            isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: selectedAvatarPath != null
                        ? () => uploadAvatarToFirebase(selectedAvatarPath!)
                        : null,
                    child: Text("Upload Avatar"),
                  ),
            SizedBox(height: 20),

            // Grid of avatars
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: avatarImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      selectAvatar(avatarImages[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: selectedAvatarPath == avatarImages[index]
                              ? Colors.blue
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          avatarImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
