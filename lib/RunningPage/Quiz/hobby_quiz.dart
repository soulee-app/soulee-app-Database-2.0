import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/LoginPage/login_screen.dart';
import 'package:navbar/RunningPage/avaterPage/avaterPage.dart';

class HobbyQuiz extends StatefulWidget {
  const HobbyQuiz({super.key, required DatabaseManager databaseManager});

  @override
  State<HobbyQuiz> createState() => _HobbyQuizState();
}

class _HobbyQuizState extends State<HobbyQuiz> {
  bool isQuizStarted = false;
  final List<Map<String, Object>> _questions = [
    {
      'question': 'How do you prefer to spend your time?',
      'answers': [
        {'text': 'Playing sports or working out', 'type': 'Athlete'},
        {
          'text': 'Reading books or writing fanfiction',
          'type': 'Fan-fictioner'
        },
        {'text': 'Experimenting with new tech or coding', 'type': 'Tech savvy'},
        {'text': 'Volunteering or attending a protest', 'type': 'Change maker'}
      ]
    },
    {
      'question': 'What activity feels most rewarding to you?',
      'answers': [
        {'text': 'Completing a challenging workout', 'type': 'Athlete'},
        {
          'text': 'Writing fanfiction or diving into fandoms',
          'type': 'Fan-fictioner'
        },
        {'text': 'Creating art or writing poetry', 'type': 'Artist'},
        {'text': 'Planning my next travel adventure', 'type': 'Traveller'}
      ]
    },
    {
      'question': 'What do you usually spend your extra money on?',
      'answers': [
        {'text': 'Fitness gear or sports equipment', 'type': 'Athlete'},
        {'text': 'Fandom merchandise or books', 'type': 'Fan-fictioner'},
        {'text': 'New gadgets or apps', 'type': 'Tech savvy'},
        {
          'text': 'Art supplies or ingredients for a creative dish',
          'type': 'Artist'
        }
      ],
    },
    {
      'question': 'Which of these brings you the most joy?',
      'answers': [
        {
          'text': 'Competing in sports or achieving fitness goals',
          'type': 'Athlete'
        },
        {
          'text': 'Writing fanfiction or exploring new fandom content',
          'type': 'Fan-fictioner'
        },
        {
          'text': 'Solving tech problems or building something new',
          'type': 'Tech savvy'
        },
        {
          'text': 'Volunteering for a cause you believe in',
          'type': 'Change maker'
        }
      ],
    },
    {
      'question': 'What’s your idea of a fun social activity?',
      'answers': [
        {
          'text': 'Competing in sports or working out with friends',
          'type': 'Athlete'
        },
        {
          'text': 'Attending a fandom convention or fanfic writing session',
          'type': 'Fan-fictioner'
        },
        {
          'text': 'Participating in a hackathon or tech event',
          'type': 'Tech savvy'
        },
        {
          'text': 'Joining a community rally or social movement event',
          'type': 'Change maker'
        }
      ],
    },
    {
      'question': 'How do you prefer to relax?',
      'answers': [
        {'text': 'Going for a run or doing a workout', 'type': 'Athlete'},
        {'text': 'Writing or reading fanfiction', 'type': 'Fan-fictioner'},
        {
          'text': 'Exploring new gadgets or solving tech puzzles',
          'type': 'Tech savvy'
        },
        {'text': 'Spending time with your pet', 'type': 'Fur parent'},
      ],
    },
    {
      'question': 'What do you like to share with others?',
      'answers': [
        {'text': 'Fitness tips or workout routines', 'type': 'Athlete'},
        {'text': 'Fandom theories or fanfiction', 'type': 'Fan-fictioner'},
        {'text': 'Tech knowledge or fixing devices', 'type': 'Tech savvy'},
        {'text': 'Stories about your pet', 'type': 'Fur parent'},
      ],
    },
    {
      'question': 'How do you enjoy expressing yourself?',
      'answers': [
        {
          'text': 'Competing in sports or physical challenges',
          'type': 'Athlete'
        },
        {
          'text': 'Writing stories or engaging in fandoms',
          'type': 'Fan-fictioner'
        },
        {'text': 'Coding or working with tech projects', 'type': 'Tech savvy'},
        {'text': 'Painting, cooking, or writing poetry', 'type': 'Artist'},
      ],
    },
    {
      'question': 'What’s your idea of a fun time?',
      'answers': [
        {
          'text': 'Going hiking or participating in a sports retreat',
          'type': 'Athlete'
        },
        {
          'text': 'Attending a fan convention or meeting fandom friends',
          'type': 'Fan-fictioner'
        },
        {
          'text': 'Exploring a new country or trying local foods',
          'type': 'Traveller'
        },
        {'text': 'Spending time with your pet', 'type': 'Fur parent'},
      ],
    },
    {
      'question': 'What inspires you the most?',
      'answers': [
        {'text': 'Pushing yourself to new physical limits', 'type': 'Athlete'},
        {
          'text': 'Creating stories or theories based on your favorite fandoms',
          'type': 'Fan-fictioner'
        },
        {
          'text': 'Innovating with tech or creating new things',
          'type': 'Tech savvy'
        },
        {
          'text': 'Advocating for social justice or human rights',
          'type': 'Change maker'
        },
      ],
    },
  ];

  final Map<String, int> _score = {
    'Athlete': 0,
    'Fan-fictioner': 0,
    'Tech savvy': 0,
    'Change maker': 0,
    'Artist': 0,
    'Traveller': 0,
    'Fur parent': 0,
  };

  int _questionIndex = 0;
  bool _isQuizCompleted = false;
  String _mainHobby = '';

  void _answerQuestion(String type) {
    setState(() {
      _score[type] = _score[type]! + 1;
      _questionIndex += 1;

      if (_questionIndex >= _questions.length) {
        _isQuizCompleted = true;
        _mainHobby = _getMainHobby();
        _updateMainTagInFirebase(
            _mainHobby); // Update Firebase with the main tag
      }
    });
  }

  String _getMainHobby() {
    List<MapEntry<String, int>> sortedEntries = _score.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries.first.key;
  }

  Future<void> _updateMainTagInFirebase(String mainHobby) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDoc.update({'mainTag': mainHobby});
        print("Main tag updated to $mainHobby in Firebase.");
      } else {
        print("No user is signed in.");
      }
    } catch (e) {
      print("Error updating mainTag in Firebase: $e");
    }
  }

  void startQuiz() {
    setState(() {
      isQuizStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: !isQuizStarted
          ? const Stack(
              children: [
                // Background image and Start Quiz button here
              ],
            )
          : _isQuizCompleted
              ? Stack(
                  children: [
                    // Show result and Confirm button here
                    Positioned(
                      bottom: 140,
                      left: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {
                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AvatarSelectionPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          backgroundColor: Colors.white.withOpacity(0.8),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    // Quiz question display here
                    Expanded(
                      child: Column(
                        children: (_questions[_questionIndex]['answers']
                                as List<Map<String, Object>>)
                            .map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.1),
                                  ),
                                  textStyle: const TextStyle(fontSize: 15),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: () =>
                                    _answerQuestion(answer['type'] as String),
                                child: Text(answer['text'] as String),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
    );
  }
}
