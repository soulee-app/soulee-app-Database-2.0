import 'package:flutter/material.dart';

class MentalStageQuiz extends StatefulWidget {
  const MentalStageQuiz({super.key});

  @override
  State<MentalStageQuiz> createState() => _MentalStageQuizState();
}

class _MentalStageQuizState extends State<MentalStageQuiz> {
  int result1 = 0;
  int result2 = 0;
  int result3 = 0;
  int result4 = 0;
  int currentQuestion = 0;
  bool isQuizStarted = false;

  final List<Map<String, Object>> questions = [
    //1
    {
      'question':
          '"Imagine you are in a crowded place, surrounded by your friends." How do you feel?',
      'answers': [
        {'text': 'I am having a great time. ', 'result': 1},
        {'text': 'I still feel lonely.', 'result': 2},
        {'text': ' I don\'t even have any friends to imagine.', 'result': 3},
        {'text': 'I am not good with crowds.', 'result': 4}
      ]
    },
    //2
    {
      'question':
          '"You\'re invited to a social gathering where you know only a few people." How do you feel about going?',
      'answers': [
        {'text': 'Excited to meet new people.', 'result': 1},
        {'text': 'Anxious but willing to try.', 'result': 2},
        {'text': 'I prefer to stay home.', 'result': 4},
        {'text': 'I feel overwhelmed just thinking about it.', 'result': 3}
      ]
    },
    //3
    {
      'question':
          '"You wake up in the morning and think about the day ahead." What is your first thought?',
      'answers': [
        {'text': 'I\'m ready to take on the day. ', 'result': 1},
        {'text': ' I wish I could stay in bed.', 'result': 3},
        {'text': 'I feel indifferent about it. ', 'result': 2},
        {'text': ' I\'m already exhausted.', 'result': 4}
      ]
    },
    //4
    {
      'question': '"You receive a compliment from someone." How do you react?',
      'answers': [
        {'text': 'I feel happy and grateful.', 'result': 1},
        {'text': 'I doubt if they really mean it.', 'result': 4},
        {'text': 'I feel awkward and don\'t know how to respond.', 'result': 2},
        {'text': 'I don\'t believe it at all. ', 'result': 3}
      ]
    },
    //5
    {
      'question':
          ' "You make a mistake at work or school." What is your response?',
      'answers': [
        {'text': 'Learn from it and move on.', 'result': 1},
        {'text': 'Feel embarrassed and worry about it.', 'result': 3},
        {'text': 'Blame myself harshly.', 'result': 4},
        {'text': 'Try to hide it.', 'result': 2}
      ]
    },
    //6
    {
      'question':
          'You have some time to yourself during the day." How do you spend it?',
      'answers': [
        {'text': ' Do something relaxing or fun.', 'result': 1},
        {'text': 'Catch up on tasks or work.', 'result': 2},
        {'text': 'Scroll through social media.', 'result': 4},
        {'text': ' Overthink about past events.', 'result': 3}
      ]
    },
    //7
    {
      'question':
          '"Someone cancels plans with you at the last minute." What is your immediate reaction?',
      'answers': [
        {'text': 'Feel ok and enjoy the free time.', 'result': 1},
        {'text': 'Feel a bit disappointed but understanding.', 'result': 4},
        {'text': 'Feel rejected and take it personally.', 'result': 2},
        {'text': 'Feel angry or frustrated.', 'result': 3}
      ]
    },
    //8
    {
      'question': '"You\'re about to try something new." How do you feel?',
      'answers': [
        {'text': 'Excited and open to the experience.', 'result': 1},
        {'text': 'Nervous but willing to give it a try.', 'result': 2},
        {'text': ' Anxious and unsure if I can do it. ', 'result': 4},
        {'text': 'I avoid trying new things. ', 'result': 3}
      ]
    },
    //9
    {
      'question':
          ' "You receive constructive criticism." How do you handle it?',
      'answers': [
        {'text': 'Appreciate the feedback and try to improve.', 'result': 1},
        {'text': 'Feel defensive but think about it later.', 'result': 4},
        {'text': 'Take it very personally and feel down.', 'result': 3},
        {'text': ' Ignore it and feel it was unjustified.', 'result': 2}
      ]
    },
    //10
    {
      'question': ' "You’re alone on a weekend." What do you do?',
      'answers': [
        {'text': 'Plan activities I enjoy.', 'result': 1},
        {'text': 'Use the time to rest.', 'result': 2},
        {'text': 'Feel lonely and sad.', 'result': 3},
        {'text': 'Feel anxious about being alone.', 'result': 4}
      ]
    },
    //11
    {
      'question':
          '"You notice changes in your mood recently." How do you feel about it?',
      'answers': [
        {'text': 'I’m aware and trying to understand why.', 'result': 4},
        {'text': 'It\'s confusing, but I manage.', 'result': 1},
        {'text': 'It\'s overwhelming and affecting my life.', 'result': 3},
        {'text': 'I ignore it and hope it passes.', 'result': 2}
      ]
    },
    //12
    {
      'question':
          ' "You\'re feeling overwhelmed with your responsibilities." What do you do?',
      'answers': [
        {'text': ' Make a plan and tackle things one at a time.', 'result': 1},
        {'text': 'Ask for help or support.', 'result': 4},
        {'text': ' Feel stressed and don\'t know where to start.', 'result': 2},
        {'text': 'Shut down and avoid everything.', 'result': 3}
      ]
    },
    //13
    {
      'question':
          '"You have an important event coming up." How do you feel about it?',
      'answers': [
        {'text': ' Excited and prepared.', 'result': 1},
        {'text': ' Nervous but hopeful. ', 'result': 4},
        {'text': ' Anxious and dreading it.', 'result': 3},
        {'text': 'I wish I could skip it.', 'result': 2}
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
      } else if (result == 4) {
        result4++;
      }
      currentQuestion++;
    });
  }

  String getResultImage() {
    if (result1 >= result2 && result1 >= result3 && result1 >= result4) {
      return 'assets/Mental State/Answer 1.png'; // Replace with your image path
    } else if (result2 > result1 && result2 >= result3 && result2 >= result4) {
      return 'assets/Mental State/Answer 2.png'; // Replace with your image path
    } else if (result3 > result1 && result3 >= result2 && result3 >= result4) {
      return 'assets/Mental State/Answer 3.png'; // Replace with your image path
    } else {
      return 'assets/Mental State/Answer 4.png'; // Replace with your image path
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
                    // Question with background image
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(
                              'assets/Mental State.png'), // Image for each question
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
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Stack(
                            children: [
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
                    const SizedBox(height: 10),
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
                              height: 35,
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
                        onPressed: () {},
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
