import 'package:flutter/material.dart';

class EmotionalMethaphorQuiz extends StatefulWidget {
  const EmotionalMethaphorQuiz({super.key});

  @override
  State<EmotionalMethaphorQuiz> createState() => _EmotionalMethaphorQuizState();
}

class _EmotionalMethaphorQuizState extends State<EmotionalMethaphorQuiz> {
  int result1 = 0;
  int result2 = 0;
  int result3 = 0;
  int currentQuestion = 0;
  bool isQuizStarted = false;

  final List<Map<String, Object>> questions = [
    {
      'question':
          'When you can sense that the other person is upset with something but isn\'t taking the initiative to tell you why, what do you usually do?',
      'answers': [
        {
          'text': 'A.  Wait for them to bring it up when they feel ready  |  ',
          'result': 2
        },
        {
          'text': 'B.  Ask them gently if anything\'s bothering them  |  ',
          'result': 1
        },
        {
          'text': 'C.  Get frustrated and demand to know what\'s wrong  |  ',
          'result': 3
        }
      ]
    },
    {
      'question':
          'When someone shares their thoughts bout something, whether it\'s bout their day at work or a song they liked. What do you like to do typically?',
      'answers': [
        {
          'text': 'A.  Listen to them, give nods or a generic answer  |  ',
          'result': 2
        },
        {
          'text':
              'B.  Participate in the conversation with thoughtful comments  |  ',
          'result': 1
        },
        {
          'text':
              'C.  Wait for your turn to talk about your own experience  |  ',
          'result': 3
        }
      ]
    },
    {
      'question':
          'How do you feel about your loved one setting up some boundaries in the relationship you two share?',
      'answers': [
        {
          'text':
              'A.  Every Individual can have their own set of personal boundaries and if I care for them I would respect the boundaries.  |  ',
          'result': 1
        },
        {
          'text':
              'B.  When two people become close enough, such stuff as "boundaries" shouldn\'t be a thing to worry about.  |  ',
          'result': 3
        },
        {
          'text':
              'C.  First I would try to define if the boundaries are logical enough to me. If they are, I don\'t mind respecting it cause I care for them.  |  ',
          'result': 2
        }
      ]
    },
    {
      'question': 'If they bring up a past mistake of you, how do you react?',
      'answers': [
        {
          'text':
              'A.  Get a bit defensive and try not to take the conversation further  |  ',
          'result': 2
        },
        {
          'text': 'B.  Acknowledge their feelings and discuss the issue  |  ',
          'result': 1
        },
        {
          'text': 'C.  Remind them of their own mistakes instead  |  ',
          'result': 3
        }
      ]
    },
    {
      'question':
          'When you are very stressed how do you usually react towards others?',
      'answers': [
        {
          'text':
              'A.  Taking out on them without realising but feeling guilty later  |  ',
          'result': 3
        },
        {'text': 'B.  Try to remain calm and composed  |  ', 'result': 1},
        {'text': 'C.  Distance yourself to avoid interaction  |  ', 'result': 2}
      ]
    },
    {
      'question':
          'If someone cancels their plans with you at the very last minute how do you feel about it?',
      'answers': [
        {
          'text':
              'A.  Feel bad but understand that they may have a reason  |  ',
          'result': 1
        },
        {
          'text': 'B.  Hold grudge and stop responding to their texts  |  ',
          'result': 2
        },
        {
          'text':
              'C.  Think of doing the same to them in future to make it equal equal  |  ',
          'result': 3
        }
      ]
    },
    {
      'question':
          'How do you feel when your loved one expresses their needs and expectations from you?',
      'answers': [
        {'text': 'A.  Overwhelmed I guess  |  ', 'result': 2},
        {
          'text': 'B.  Open to hearing them and adjust if needed  |  ',
          'result': 1
        },
        {
          'text':
              'C.  Nah I prefer to stick to my own ways of doing things  |  ',
          'result': 3
        }
      ]
    },
    {
      'question': 'How do you handle conflict with your loved ones?',
      'answers': [
        {
          'text':
              'A.  I calmly express my feelings and seek a resolution together.  |  ',
          'result': 1
        },
        {
          'text':
              'B.  I argue my point anyhow possible and hope my partner understands.  |  ',
          'result': 2
        },
        {
          'text': 'C.  I try to avoid the conflict or change the subject.  |  ',
          'result': 3
        }
      ]
    },
    {
      'question': 'How do you react when your partner criticizes you?',
      'answers': [
        {
          'text':
              'A.  I take time to reflect on their feedback and consider it thoughtfully.  |  ',
          'result': 1
        },
        {
          'text': 'B.  I get defensive and explain why they are wrong.  |  ',
          'result': 3
        },
        {
          'text': 'C.  I shut down and feel hurt without responding much.  |  ',
          'result': 2
        }
      ]
    },
    {
      'question':
          'How do you approach difficult conversations in your relationship?',
      'answers': [
        {
          'text':
              'A.  I initiate them thoughtfully and focus on mutual understanding.  |  ',
          'result': 1
        },
        {
          'text':
              'B.  I approach them with a sense of urgency to resolve issues quickly.  |  ',
          'result': 2
        },
        {
          'text':
              'C.  I avoid them for as long as possible to prevent conflict.  |  ',
          'result': 3
        }
      ]
    },
    {
      'question':
          'How do you deal with jealousy or insecurity in the relationship?',
      'answers': [
        {
          'text':
              'A.  I communicate my feelings openly and try to understand the root cause.  |  ',
          'result': 1
        },
        {
          'text':
              'B.  I feel jealous but keep it to myself most of the time.  |  ',
          'result': 2
        },
        {
          'text':
              'C.  I avoid the conversation and let the feelings simmer.  |  ',
          'result': 3
        }
      ]
    }
  ];

  void answerQuestion(int result) {
    setState(() {
      if (result == 1) {
        result1++;
      } else if (result == 2) {
        result2++;
      } else if (result == 3) {
        result3++;
      }
      currentQuestion++;
    });
  }

  String getResultImage() {
    if (result1 >= result2 && result1 >= result3) {
      return 'assets/Emotional Metaphor/Answer 1.png';
    } else if (result2 > result1 && result2 >= result3) {
      return 'assets/Emotional Metaphor/Answer 1.png';
    } else {
      return 'assets/Emotional Metaphor/Answer 1.png';
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
          ? Stack(
              children: [
                // Background image
                Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/Emotional Metaphor/Intro.png'), // Replace with your intro image path
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Start Quiz button
                Positioned(
                  bottom: 140,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: startQuiz,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        backgroundColor: Colors.white.withOpacity(0.8),
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : currentQuestion < questions.length
              ? Column(
                  children: [
                    // Question with background image
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(
                              'assets/Emotional Metaphor.png'), // Image for each question
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.dstATop, // Applies transparency
                          ),
                        ),
                        border: Border.all(
                          color: Colors.black, // Set the border color
                          width: 2.0, // Set the border width
                        ),
                        borderRadius:
                            BorderRadius.circular(0), // Add a slight curve
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                            child: Stack(
                          children: [
                            // Text with a black stroke (border)
                            Text(
                              questions[currentQuestion]['question'] as String,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3
                                  ..color = Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              questions[currentQuestion]['question'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2.0,
                                    color: Colors.black,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                      ),
                    ),
                    // Options (no background image here)
                    Expanded(
                      child: Column(
                        children: (questions[currentQuestion]['answers']
                                as List<Map<String, Object>>)
                            .map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // Square corners
                                    side: const BorderSide(
                                        color: Colors.black,
                                        width: 0.1), // Black border
                                  ),
                                  textStyle: const TextStyle(fontSize: 15),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors
                                      .transparent, // Transparent background
                                  shadowColor: Colors
                                      .transparent, // Remove button shadow
                                ),
                                onPressed: () =>
                                    answerQuestion(answer['result'] as int),
                                child: Text(answer['text'] as String),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    // Result image covering the entire screen
                    SizedBox(
                      width: screenSize.width,
                      height: screenSize.height,
                      child: Image.asset(
                        getResultImage(),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Confirm button positioned at the bottom center
                    Positioned(
                      bottom: 140,
                      left: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the confirm action, e.g., navigate to another page
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
                ),
    );
  }
}
