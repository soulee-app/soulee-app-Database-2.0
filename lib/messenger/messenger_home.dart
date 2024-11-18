import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_screen.dart';

class MessengerHome extends StatefulWidget {
  const MessengerHome({super.key});

  @override
  State<MessengerHome> createState() => _MessengerHomeState();
}

class _MessengerHomeState extends State<MessengerHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<User>> _users;

  Future<List<User>> fetchUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void initState() {
    super.initState();
    _users = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<User>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Image.asset(user.imageUrl), // Assume user has imageUrl
                title: Text(user.name),
                subtitle: Text(
                    user.lastMessage ?? ''), // Last message could be fetched
                onTap: () {
                  // Navigate to chat screen (implement your ChatScreen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(user: user), // Pass user data
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class User {
  final String name;
  final String imageUrl;
  final String lastMessage;

  User({required this.name, required this.imageUrl, this.lastMessage = ''});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      name: doc['name'],
      imageUrl: doc['imageurl'],
      lastMessage: doc['lastMessage'] ?? '',
    );
  }
}
