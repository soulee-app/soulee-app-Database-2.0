import 'package:flutter/material.dart';

class AboutMeQuiz extends StatefulWidget {
  const AboutMeQuiz({super.key});

  @override
  State<AboutMeQuiz> createState() => _AboutMeQuizState();
}

class _AboutMeQuizState extends State<AboutMeQuiz> {
  int result1 = 0;
  int result2 = 0;
  int result3 = 0;
  int currentQuestion = 0;
  bool isQuizStarted = false;

  final List<Map<String, Object>> questions = [
    //1
    {
      'question': 'I\'m having free time, I\'d prefer -',
      'answers': [
        {
          'text': 'staying in and spending quality time with Myself',
          'result': 1
        },
        {'text': 'going out and having fun with my friends', 'result': 2},
        {'text': 'I like both, depends on my mood ', 'result': 3}
      ]
    },
    //2
    {
      'question':
          'suppose you had a hectic week. how would you like to spend your weekend?',
      'answers': [
        {
          'text': 'I would chill in my room and binge movies and shows',
          'result': 1
        },
        {'text': 'I would meet my friends and have a good time', 'result': 2},
        {'text': 'I would spend quality time with my family ', 'result': 3}
      ]
    },
    //3
    {
      'question':
          'your institution arranged a sports event. which of the following would you enjoy more?',
      'answers': [
        {'text': 'indoor games like Uno cards Ludo', 'result': 1},
        {'text': 'outdoor games like cricket football badminton ', 'result': 2},
        {
          'text': 'doesn\'t really matter, I prefer being an audience.',
          'result': 3
        }
      ]
    },
    //4
    {
      'question': 'I feel like dancing when-',
      'answers': [
        {'text': 'I am alone ', 'result': 1},
        {'text': 'I am with my friends', 'result': 3},
        {'text': 'In occasions like a wedding etc.', 'result': 2}
      ]
    },
    //5
    {
      'question':
          'imagine there has been a fight online. in this case which of the following role will you play?',
      'answers': [
        {'text': 'I would engage in drama.', 'result': 2},
        {
          'text':
              'I would add fuel to the fire and instigate others to engage in the drama.',
          'result': 3
        },
        {
          'text': 'Dnone of this really bothers me so I will stay neutral.',
          'result': 1
        }
      ]
    },
    //6
    {
      'question': 'which kind of weather goes with your personality the most? ',
      'answers': [
        {'text': 'bright sunny summer or spring morning', 'result': 2},
        {'text': 'gloomy winter morning or rainy day', 'result': 1},
        {'text': 'a cozy fall afternoon', 'result': 3}
      ]
    },
    //7
    {
      'question': 'which one describes you?',
      'answers': [
        {'text': 'I think about past all the time', 'result': 1},
        {'text': 'I focus on the present ', 'result': 3},
        {'text': 'I worry about the future', 'result': 2}
      ]
    },
    //8
    {
      'question':
          'imagine you\'re having a mental breakdown. which of the following set of activities comforts you the most? ',
      'answers': [
        {
          'text': 'music, sleep, selfcare,  giving time to yourself',
          'result': 1
        },
        {
          'text': 'social gathering, hangout with friends, clubbing ',
          'result': 2
        },
        {'text': 'rant online, hangout alone, gym, solo date', 'result': 3}
      ]
    },
    //9
    {
      'question':
          'what is your favourite kind of travel destination and activity?',
      'answers': [
        {'text': ' mountain trekking with friends', 'result': 3},
        {'text': ' watching sunset at sea beach in a solo trip', 'result': 1},
        {'text': 'camping with random strangers in a forest', 'result': 2}
      ]
    },
    //10
    {
      'question': 'if you were given an opportunity to become famous -',
      'answers': [
        {'text': 'yes I would love to', 'result': 2},
        {'text': 'no thanks I will pass', 'result': 1},
        {'text': 'I don\'t know man maybe I will give it a shot.', 'result': 3}
      ]
    },
    //11
    {
      'question':
          'you have a deadline. how would you like to finish the task? ',
      'answers': [
        {'text': 'I would finish it timely in daytime', 'result': 3},
        {
          'text':
              'I would procrastinate your last moment and somehow complete it  at night',
          'result': 2
        },
        {'text': 'I would finish it long before the deadline', 'result': 3}
      ]
    },
    //12
    {
      'question':
          ' let\'s say your favourite artist is visiting your city. will you attend his concert? ',
      'answers': [
        {'text': 'of course at any cost', 'result': 2},
        {
          'text':
              'it\'s really doesn\'t matter that much. I might or I might not',
          'result': 3
        },
        {
          'text':
              'YouTube performance sounds better than life performance. I would brother enjoy from my room',
          'result': 1
        }
      ]
    },
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
      return 'assets/About Me/Answer 1.png'; // Replace with the actual path for introspective result
    } else if (result2 > result1 && result2 >= result3) {
      return 'assets/About Me/Answer 2.png'; // Replace with the actual path for social result
    } else {
      return 'assets/About Me/Answer 3.png'; // Replace with the actual path for adaptive result
    }
  }

  void onConfirm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultPage()),
    );
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
                          'assets/About Me/Intro.png'), // Replace with your intro image path
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
                    // Question with background image (same as before)
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/About me.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.dstATop,
                          ),
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Stack(
                            children: [
                              // Stroke text
                              Text(
                                questions[currentQuestion]['question']
                                    as String,
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
                              // Shadowed white text
                              Text(
                                questions[currentQuestion]['question']
                                    as String,
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
                          ),
                        ),
                      ),
                    ),
                    // Options (same as before)
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

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
      ),
      body: const Center(
        child: Text(
          'You have confirmed your result!',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
