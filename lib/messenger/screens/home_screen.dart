import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';
import '../widgets/profile_image.dart';
import 'ai_screen.dart';
import 'profile_screen.dart';

// Home screen where all available contacts are shown
class HomeScreen extends StatefulWidget {
  final dynamic databaseManager;

  const HomeScreen({super.key, required this.databaseManager});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // For storing all users
  List<ChatUser> _list = [];

  // For storing searched items
  final List<ChatUser> _searchList = [];
  // For storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    // For updating user active status according to lifecycle events
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size; // Ensure mq is initialized

    return GestureDetector(
      // For hiding keyboard when a tap is detected on screen
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        canPop: false,
        onPopInvoked: (_) {
          if (_isSearching) {
            setState(() => _isSearching = !_isSearching);
            return;
          }

          // Some delay before pop
          Future.delayed(
              const Duration(milliseconds: 300), SystemNavigator.pop);
        },
        child: Scaffold(
          // App bar
          appBar: AppBar(
            // View profile
            leading: IconButton(
              tooltip: 'View Profile',
              onPressed: () {
                // Ensure APIs.me is not null
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me)));
              },
              icon: const ProfileImage(size: 32),
            ),

            // Title
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email, ...'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (val) {
                      // Search logic
                      _searchList.clear();

                      val = val.toLowerCase();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val) ||
                            i.email.toLowerCase().contains(val)) {
                          _searchList.add(i);
                        }
                      }
                      setState(() => _searchList);
                    },
                  )
                : Container(
                    child: Image.asset(
                      'assetsm/soulee_logo.png',
                      height: 40,
                    ),
                  ),
            actions: [
              !_isSearching
                  ? IconButton(
                      tooltip: 'Add User',
                      padding: const EdgeInsets.only(right: 8),
                      onPressed: _addChatUserDialog,
                      icon: Image.asset(
                        'assetsm/menu.png',
                        height: 25,
                      ),
                    )
                  : const Text(''),
              IconButton(
                  tooltip: 'Search',
                  onPressed: () => setState(() => _isSearching = !_isSearching),
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search)),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              )
            ],
          ),

          // Floating button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // Ensure AiScreen is available
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiScreen()),
                );
              },
              child: Builder(
                builder: (context) {
                  try {
                    return Lottie.asset('assetsm/lottie/ai.json', width: 40);
                  } catch (e) {
                    // Show a fallback icon or an error message if the asset is missing
                    debugPrint("Lottie asset not found: $e");
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  }
                },
              ),
            ),
          ),

          // Body
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),

            // Get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: APIs.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    // Get only those users whose IDs are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('No Connections Found!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  // For adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),

              // Title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              // Content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: const InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),

              // Actions
              actions: [
                // Cancel button
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                // Add button
                MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email.trim().isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not exist!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
