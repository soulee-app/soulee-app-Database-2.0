import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/LoginPage/component/Singup_Custom_image.dart';
import 'dart:io';

import 'package:navbar/RunningPage/Quiz/hobby_quiz.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final DatabaseManager _databaseManager = DatabaseManager();

  bool _isFirstStep = true;
  String? _selectedGender;
  File? _selectedImage;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _signup() async {
    if (_nameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _selectedGender == null ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    DateTime? dob;
    try {
      final dobParts = _dobController.text.split('/');
      if (dobParts.length != 3) throw Exception("Invalid date format");

      final day = int.parse(dobParts[0]);
      final month = int.parse(dobParts[1]);
      final year = int.parse(dobParts[2]);

      dob = DateTime(year, month, day);
      if (dob.isAfter(DateTime.now())) {
        throw Exception("Date of birth cannot be in the future.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid date of birth.')),
      );
      return;
    }
    try {
      bool isSignedUp = await _databaseManager.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        dob: dob,
        gender: _selectedGender!,
        username: _usernameController.text,
        phone: _phoneController.text,
        profileImage: _selectedImage,
        bloodGroup: '',
      );

      if (isSignedUp) {
        var user = FirebaseAuth.instance.currentUser;

        if (user != null && !user.emailVerified) {
          try {
            await user.sendEmailVerification();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Verification email sent! Please verify and log in.'),
              ),
            );

            // Sign out the user after sending the verification email
            //await _databaseManager.signOutUser();

            // Navigate to HobbyQuiz after successful signup
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HobbyQuiz(
                  databaseManager: DatabaseManager(),
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Failed to send verification email: ${e.toString()}'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Failed to send verification email. Try again later.'),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${e.toString()}')),
      );
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF3EDED),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildFirstStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/sign_up/1726164386864.png', height: 100),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          decoration: _inputDecoration('Name'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _dobController,
          decoration: _inputDecoration(
            'Date of Birth',
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          hint: const Text('Select Gender'),
          decoration: _inputDecoration('Gender'),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _usernameController,
          decoration: _inputDecoration('Username').copyWith(
            prefixText: 'https://souleeapp.com/',
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => setState(() => _isFirstStep = false),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6F61),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
          ),
          child: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildSecondStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/sign_up/Deformed Circle.png',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              if (_selectedImage != null)
                SingUpCustomImage(
                  imageFile: _selectedImage!,
                  height: 150,
                  width: 150,
                ),
              if (_selectedImage == null)
                const Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: _inputDecoration('Email'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _phoneController,
          decoration: _inputDecoration('Phone Number'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: _inputDecoration('Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _confirmPasswordController,
          decoration: _inputDecoration('Confirm Password'),
          obscureText: true,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _signup,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6F61),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
          ),
          child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_isFirstStep) {
              Navigator.pop(context);
            } else {
              setState(() {
                _isFirstStep = true;
              });
            }
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isFirstStep ? _buildFirstStep() : _buildSecondStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
