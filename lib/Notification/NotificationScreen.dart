import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  final dynamic databaseManager;

  const NotificationScreen({super.key, required this.databaseManager});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: const SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "MY NOTIFICATIONS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NotificationTab(title: 'MAIN', isActive: true),
                  NotificationTab(title: 'SUB', isActive: false),
                ],
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications available."));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  notifications[index].data() as Map<String, dynamic>;
              return NotificationTile(
                title: notification['title'] ?? 'No Title',
                description: notification['body'] ?? 'No Description',
                time: notification['timestamp'] != null
                    ? (notification['timestamp'] as Timestamp)
                        .toDate()
                        .toLocal()
                        .toString()
                    : 'Unknown Time',
                avatarUrl: notification['avatarUrl'], // Optional: User avatar
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationTab extends StatelessWidget {
  final String title;
  final bool isActive;

  const NotificationTab(
      {super.key, required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive ? Colors.redAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String? avatarUrl;

  const NotificationTile({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container for the notification icon and the date
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 130, 74, 69), // Container color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  avatarUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl!),
                          radius: 25,
                        )
                      : const Icon(Icons.notifications,
                          size: 50, color: Colors.white),
                  const SizedBox(
                      height: 10), // Space between the icon and the time
                  Text(
                    time,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
