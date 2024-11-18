import 'package:flutter/material.dart';

class HopelessRomanceQuiz extends StatefulWidget {
  const HopelessRomanceQuiz({super.key});

  @override
  State<HopelessRomanceQuiz> createState() => _HopelessRomanceQuizState();
}

class _HopelessRomanceQuizState extends State<HopelessRomanceQuiz> {
  int result1 = 0;
  int result2 = 0;
  int result3 = 0;
  int result4 = 0;
  int result5 = 0;
  int currentQuestion = 0;
  bool isQuizStarted = false;

  final List<Map<String, Object>> questions = [
    {
      'question': 'Your date suggests splitting the bill. What\'s your move?',
      'answers': [
        {'text': 'No way! I believe in treating my date.', 'result': 1},
        {'text': 'Sure, that\'s fair!', 'result': 2},
        {
          'text':
              'They suggested the date, so they better be ready to cover it!',
          'result': 3
        }
      ]
    },
    {
      'question':
          'You\'ve been texting your date for a while, but they\'re taking forever to reply. How do you handle it?',
      'answers': [
        {
          'text':
              'Ignored? Hell no! they should be worshipping the ground I walk on!',
          'result': 3
        },
        {
          'text': 'No big deal, they\'ll reply when they\'re ready.',
          'result': 2
        },
        {
          'text':
              'I\'ll give them space, but they better have a good explanation.',
          'result': 1
        }
      ]
    },
    {
      'question':
          'Your date wants to meet your friends right away. How do you feel?',
      'answers': [
        {'text': 'Whoa, whoa, calm down bro!', 'result': 3},
        {'text': 'Sure, why not? Could be fun!', 'result': 2},
        {'text': 'Not yet, I like keeping things private for now.', 'result': 1}
      ]
    },
    {
      'question': 'How do you prefer to communicate in a relationship?',
      'answers': [
        {'text': 'Face-to-face, maybe over a cup of tea at TSC.', 'result': 1},
        {
          'text': 'We met on "Soulee". For now, you better stay on "Soulee!"',
          'result': 3
        },
        {'text': 'Let\'s go clubbing or hit up concerts.', 'result': 2},
        {'text': 'I call, I rant, you shut up and listen.', 'result': 3},
        {'text': 'You rant, I listen. That\'s how it works.', 'result': 1}
      ]
    },
    {
      'question': 'What\'s your go-to comfort food in Dhaka?',
      'answers': [
        {'text': 'Kebab from Star because why not?', 'result': 2},
        {
          'text':
              'Fuchka from street stalls – who needs hygiene when you\'ve got flavor?',
          'result': 4
        },
        {
          'text': 'Hazi Biriyani, because only the best for my taste buds.',
          'result': 1
        },
        {
          'text':
              'I dine in high-end places; the taste of luxury is my comfort food',
          'result': 3
        },
        {'text': 'I cook at home – I hate capitalism.', 'result': 5}
      ]
    },
    {
      'question':
          'If you could travel anywhere in Bangladesh with a date, where would you go?',
      'answers': [
        {
          'text':
              'Cox\'s Bazar for a beach trip – because who doesn\'t want to look like a sun-kissed model?',
          'result': 1
        },
        {
          'text':
              'Sylhet for the tea gardens – where the only thing fresher than the tea is our date',
          'result': 2
        },
        {
          'text':
              'Shajek for the stunning views – let\'s get lost in nature and each other',
          'result': 2
        },
        {
          'text':
              'Puran Dhaka because I\'m an authentic "Dhakar Pola" who\'s very, very smart',
          'result': 3
        },
        {
          'text': 'The Sundarbans to see a different tiger other than myself',
          'result': 5
        }
      ]
    },
    {
      'question': 'What\'s your ideal way to spend a weekend in Dhaka?',
      'answers': [
        {'text': 'Enjoying a romantic dinner and movie date', 'result': 1},
        {
          'text':
              'Couch potato mode: binge-watching every show and pretending my sofa is a time machine',
          'result': 4
        },
        {'text': 'Exploring Dhaka\'s coolest spots', 'result': 2},
        {
          'text':
              'Partying hard at the trendiest club – because sleep is overrated',
          'result': 3
        }
      ]
    },
    {
      'question': 'Which type of movies do you enjoy the most?',
      'answers': [
        {
          'text':
              'Action/Adventure – because explosions make everything better',
          'result': 3
        },
        {'text': 'Comedy – because reality\'s already a joke', 'result': 4},
        {
          'text': 'Romance – because a little cheese never hurt anyone',
          'result': 1
        },
        {
          'text': 'Documentaries – perfect for looking smart while snoozing',
          'result': 5
        }
      ]
    },
    {
      'question':
          'How do you feel about posting your relationship on social media?',
      'answers': [
        {
          'text': 'I love it – let\'s show the world how cute we are!',
          'result': 1
        },
        {
          'text': 'It\'s cool, but not too much – we need our privacy too.',
          'result': 2
        },
        {
          'text':
              'Oh, we\'re doing couple pics? Better make sure I look flawless.',
          'result': 3
        },
        {
          'text': 'I prefer to keep it low-key – no need to advertise.',
          'result': 5
        },
        {
          'text':
              'Post about my relationship? Yeah, sure, let me just Photoshop myself into someone else\'s couple pics.',
          'result': 4
        }
      ]
    },
    {
      'question': 'How do you handle anniversaries in a relationship?',
      'answers': [
        {
          'text': 'Big celebrations with gifts and dinner – I go all out.',
          'result': 1
        },
        {
          'text': 'A simple yet thoughtful gesture like a handwritten note.',
          'result': 2
        },
        {
          'text': 'I\'ll remember at the last minute and hope for the best.',
          'result': 4
        },
        {'text': 'Set a reminder and make sure we both remember!', 'result': 3},
        {
          'text':
              'Anniversaries? I can\'t even get past a "Hi, how are you?" phase',
          'result': 5
        }
      ]
    },
    {
      'question': 'How do you handle awkward silences on a date?',
      'answers': [
        {
          'text': 'Fill it with jokes or random conversation topics.',
          'result': 2
        },
        {'text': 'Compliment them to break the tension.', 'result': 1},
        {'text': 'Sip my drink and hope they talk first.', 'result': 5},
        {'text': 'Embrace it – sometimes silence is nice.', 'result': 4},
        {
          'text': 'Awkward silences? I\'ve been on silent mode my whole life.',
          'result': 3
        }
      ]
    },
    {
      'question': 'How do you feel about sharing your past with a new partner?',
      'answers': [
        {
          'text': 'Open book – I believe in being honest from the start.',
          'result': 1
        },
        {
          'text': 'Absolutely not! What\'s done is done, let\'s move on.',
          'result': 3
        },
        {
          'text':
              'If I vibe with you, sure. If not, well… good luck finding out!',
          'result': 4
        },
        {'text': 'It depends on how comfortable I am with them.', 'result': 2},
        {'text': 'What past? It\'s just been me and Netflix.', 'result': 5}
      ]
    },
    {
      'question': 'How do you feel about double-texting?',
      'answers': [
        {'text': 'No problem! Sometimes one text isn\'t enough.', 'result': 2},
        {
          'text': 'Only if it\'s urgent – otherwise, patience is key.',
          'result': 1
        },
        {
          'text': 'If I\'m double-texting you, I\'m already in my feelings.',
          'result': 3
        },
        {'text': 'I\'d rather wait. Let them miss me.', 'result': 5},
        {
          'text': 'Double-text? I\'m still drafting my first message, okay?',
          'result': 4
        }
      ]
    },
    {
      'question': 'How do you feel about pet names in a relationship?',
      'answers': [
        {'text': 'Love them! It\'s cute and personal.', 'result': 1},
        {'text': 'Only if it\'s something unique – no clichés!', 'result': 2},
        {
          'text': 'If you call me "babe," you better bring your A-game.',
          'result': 3
        },
        {
          'text': 'As long as it\'s not too cheesy, I\'m cool with it.',
          'result': 4
        },
        {
          'text':
              'Pet names? I\'m just hoping someone will remember my real name first.',
          'result': 5
        }
      ]
    },
    {
      'question':
          'Scenario: You\'re having a disagreement and your partner is being very quiet. How do you handle it?',
      'answers': [
        {
          'text':
              'Silent treatment? I\'ll just start talking about my feelings in a monologue.',
          'result': 3
        },
        {
          'text': 'Apologize first, even if I have no idea what I did wrong.',
          'result': 1
        },
        {
          'text':
              'Drop a random meme to lighten the mood and quietly switch topics.',
          'result': 2
        },
        {
          'text':
              'Call my bestie for advice – they\'re basically my relationship coach.',
          'result': 4
        },
        {
          'text':
              'Disagreement? I\'m more concerned about my phone\'s battery life.',
          'result': 5
        }
      ]
    },
    {
      'question':
          'Scenario: Your partner wants to move in together, but you\'re not sure. What do you do?',
      'answers': [
        {
          'text':
              'Move in together? We haven\'t even managed a successful date night!',
          'result': 3
        },
        {
          'text': 'Consider it, but I need to make sure it\'s the right time.',
          'result': 4
        },
        {'text': 'Move in together? My idea of a cozy', 'result': 5},
        {'text': 'Discuss it openly and weigh the pros and cons.', 'result': 2},
        {
          'text': 'Think about it carefully and maybe set a timeline.',
          'result': 1
        }
      ]
    },
    {
      'question':
          'Scenario: You find out your partner has a secret hobby you didn\'t know about. What\'s your response?',
      'answers': [
        {'text': 'Intrigued – I\'m excited to learn about it!', 'result': 2},
        {
          'text': 'Curious – I\'d like to know why they kept it a secret.',
          'result': 1
        },
        {
          'text':
              'Secret hobby? If it\'s not a reality TV binge, I\'m not impressed.',
          'result': 3
        },
        {'text': 'Open to it – everyone needs their own thing.', 'result': 4},
        {
          'text':
              'Secret hobbies? As long as it\'s not talking to other people, I\'m good.',
          'result': 5
        }
      ]
    },
    {
      'question':
          'Scenario: Your partner cancels a date last minute. What\'s your reaction?',
      'answers': [
        {
          'text':
              'Last-minute cancel? Looks like I\'m having a solo Netflix marathon.',
          'result': 3
        },
        {
          'text': 'I\'ll be annoyed but will give them another chance.',
          'result': 4
        },
        {
          'text': 'Disappointed, but I\'ll reschedule and try again.',
          'result': 1
        },
        {'text': 'I\'m understanding – things come up.', 'result': 2},
        {
          'text':
              'Cancelled? Guess I\'ll be having dinner with my couch and snacks.',
          'result': 5
        }
      ]
    },
    {
      'question':
          'Your partner wants to try a new activity, but you\'re not sure. What do you do?',
      'answers': [
        {
          'text':
              'New activity? If it doesn\'t involve me sitting comfortably, I\'m not in.',
          'result': 3
        },
        {'text': 'Hesitate but agree to try it once.', 'result': 1},
        {'text': 'Give it a try – it might be fun!', 'result': 2},
        {
          'text': 'Discuss it and see if it fits both your interests.',
          'result': 4
        },
        {
          'text':
              'New activity? I\'m still figuring out how to get out of bed in the morning.',
          'result': 5
        }
      ]
    },
    {
      'question':
          'Your partner wants to introduce you to their family. How do you feel?',
      'answers': [
        {
          'text': 'Meet the family? As long as they don\'t quiz me on trivia.',
          'result': 3
        },
        {'text': 'Nervous but ready to meet them.', 'result': 1},
        {
          'text': 'Excited – it\'s a step forward in the relationship.',
          'result': 2
        },
        {
          'text': 'Willing but a bit anxious about making a good impression.',
          'result': 4
        },
        {
          'text':
              'Meet the family? I\'m still trying to meet someone who texts me back.',
          'result': 5
        }
      ]
    },
    {
      'question':
          'You and your partner have different opinions on a major decision. What\'s your approach?',
      'answers': [
        {
          'text': 'Different opinions? I\'m just here for the snacks anyway.',
          'result': 3
        },
        {
          'text':
              'Listen to their perspective and try to understand their point of view.',
          'result': 4
        },
        {'text': 'Have a calm discussion to find common ground.', 'result': 2},
        {
          'text': 'Compromise and find a solution that works for both.',
          'result': 1
        }
      ]
    },
    {
      'question': 'How do you handle arguments in a relationship?',
      'answers': [
        {
          'text':
              'Silent treatment until they figure out what\'s wrong (it\'s obvious, right?).',
          'result': 3
        },
        {
          'text': 'Apologize first, even if I have no idea what I did wrong.',
          'result': 1
        },
        {
          'text':
              'Drop a random meme to lighten the mood and quietly switch topics.',
          'result': 2
        },
        {
          'text':
              'Call my bestie for advice – they\'re basically my relationship coach.',
          'result': 4
        },
        {
          'text':
              'No arguments, ever – we\'re living in a perfect fantasy world.',
          'result': 5
        }
      ]
    },
    {
      'question': 'How do you handle public displays of affection (PDA)?',
      'answers': [
        {
          'text': 'PDA? More like "Please Don\'t, Anyone\'s watching."',
          'result': 4
        },
        {
          'text': 'I\'m all for it – hand-holding, hugging, whatever.',
          'result': 1
        },
        {
          'text':
              'A little is fine, but let\'s not make everyone else uncomfortable.',
          'result': 2
        },
        {
          'text':
              'I\'ll blush like crazy, but I\'ll pretend to be cool with it.',
          'result': 3
        },
        {
          'text': 'Why hold hands when you can just text each other?',
          'result': 5
        }
      ]
    },
    {
      'question': 'How do you feel about texting in a relationship?',
      'answers': [
        {'text': 'Text me 24/7 – I need updates on everything!', 'result': 1},
        {
          'text':
              'Check-in every few hours, but we don\'t need to talk all day.',
          'result': 2
        },
        {
          'text': 'Occasional messages, just to remind them I\'m alive.',
          'result': 3
        },
        {
          'text':
              'Late-night conversations only – that\'s where the real magic happens.',
          'result': 4
        },
        {'text': 'Talk? We post memes here, sir.', 'result': 5}
      ]
    },
    {
      'question': 'What\'s your biggest relationship pet peeve?',
      'answers': [
        {'text': 'Replying with "K".', 'result': 3},
        {
          'text':
              'Not talking about politics – we need to discuss the important stuff!',
          'result': 2
        },
        {
          'text': 'Forgetting important dates – I\'ve reminded you 10 times!',
          'result': 1
        },
        {
          'text': 'Leaving me on "read" but posting stories. Seriously, rude.',
          'result': 4
        },
        {
          'text': 'Talking too much about your ex – I\'m here, aren\'t I?',
          'result': 5
        }
      ]
    },
    {
      'question': 'How quickly do you respond to texts?',
      'answers': [
        {
          'text': 'Instantly – my phone is basically glued to my hand.',
          'result': 1
        },
        {'text': 'Within an hour or two – I\'m pretty prompt.', 'result': 2},
        {
          'text': 'When (and if) I get the time – I\'m busy being fabulous.',
          'result': 3
        },
        {
          'text':
              'It depends on the mood – sometimes immediately, sometimes... well, let\'s just say eventually.',
          'result': 4
        }
      ]
    },
    {
      'question': 'How do you feel about starting a family?',
      'answers': [
        {'text': 'Can\'t wait! Kids are part of the plan.', 'result': 1},
        {'text': 'Maybe one day, but I\'m not in a rush.', 'result': 2},
        {'text': 'Not sure – I\'m more focused on the present.', 'result': 3},
        {'text': 'Nope, just not my thing right now.', 'result': 4}
      ]
    },
    {
      'question': 'Where do you see yourself in five years?',
      'answers': [
        {
          'text': 'With my partner, settled down, working towards a family.',
          'result': 1
        },
        {
          'text': 'Focused on career goals but making time for love.',
          'result': 2
        },
        {'text': 'Traveling the world with my significant other.', 'result': 3},
        {
          'text':
              'Still figuring things out – enjoying the ride with my partner by my side.',
          'result': 4
        }
      ]
    },
    {
      'question': 'How important is career growth in your relationship?',
      'answers': [
        {
          'text': 'Very important – we both need to be ambitious and driven.',
          'result': 1
        },
        {
          'text': 'Important, but there\'s more to life than just work.',
          'result': 2
        },
        {
          'text':
              'As long as we\'re happy, career stuff will figure itself out.',
          'result': 3
        },
        {
          'text':
              'Meh, let\'s just be happy together and see where life takes us.',
          'result': 4
        }
      ]
    },
    {
      'question': 'What\'s your main relationship goal?',
      'answers': [
        {
          'text': 'Building a strong, loving partnership – ride or die!',
          'result': 1
        },
        {
          'text': 'Growing together, learning, and supporting each other.',
          'result': 2
        },
        {
          'text': 'Taking it one day at a time – no rush, just vibes.',
          'result': 3
        },
        {
          'text':
              'Figuring out if we\'re both on the same page for the long run.',
          'result': 4
        }
      ]
    },
    {
      'question':
          'What\'s your take on balancing tradition and modernity in a relationship?',
      'answers': [
        {'text': 'Embrace both – tradition with a modern twist.', 'result': 2},
        {
          'text': 'Mostly modern, but some traditions are important to me.',
          'result': 1
        },
        {'text': '100% modern – no room for old-school rules.', 'result': 3},
        {
          'text': 'Let\'s go with whatever works for us, no pressure.',
          'result': 4
        }
      ]
    },
    {
      'question': 'How important are shared religious or cultural values?',
      'answers': [
        {
          'text':
              'Very important – they form the foundation of a relationship.',
          'result': 1
        },
        {'text': 'Important, but love and respect come first.', 'result': 2},
        {'text': 'Not a dealbreaker – we can find common ground.', 'result': 3},
        {
          'text': 'We\'re all about building our own values together.',
          'result': 4
        }
      ]
    },
    {
      'question': 'What\'s your view on marriage?',
      'answers': [
        {'text': 'It\'s the goal – let\'s make it official.', 'result': 1},
        {'text': 'It\'s nice, but let\'s focus on us first.', 'result': 2},
        {
          'text':
              'Marriage? I\'m still trying to figure out what to have for dinner.',
          'result': 3
        },
        {'text': 'Maybe later. Right now, I\'m happy as we are.', 'result': 4}
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
      } else if (result == 4) {
        result4++;
      } else if (result == 5) {
        result5++;
      }
      currentQuestion++;
    });
  }

  String getResultImage() {
    if (result1 >= result2 &&
        result1 >= result3 &&
        result1 >= result4 &&
        result1 >= result5) {
      return 'assets/Hopeless Romance/Answer 1.png';
    } else if (result2 >= result1 &&
        result2 >= result3 &&
        result2 >= result4 &&
        result2 >= result5) {
      return 'assets/Hopeless Romance/Answer 2.png';
    } else if (result3 >= result1 &&
        result3 >= result2 &&
        result3 >= result4 &&
        result3 >= result5) {
      return 'assets/Hopeless Romance/Answer 3.png';
    } else if (result4 >= result1 &&
        result4 >= result2 &&
        result4 >= result3 &&
        result4 >= result5) {
      return 'assets/Hopeless Romance/Answer 4.png';
    } else {
      return 'assets/Hopeless Romance/Answer 5.png';
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
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(
                              'assets/Hopeless Romance.png'), // Image for each question
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(
                                0.5), // Adjust opacity (0.0 - fully transparent, 1.0 - fully opaque)
                            BlendMode.dstATop, // Applies transparency
                          ),
                        ),
                        border: Border.all(
                          color: Colors.black, // Set the border color
                          width: 2.0, // Set the border width
                        ),
                        borderRadius:
                            BorderRadius.circular(12.0), // Add a slight curve
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Stack(
                            children: [
                              // Text with a black stroke (border)
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
