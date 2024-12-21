import 'package:flutter/material.dart';
import 'package:navbar/RunningPage/Quiz/about_me_quiz.dart';
import 'package:navbar/RunningPage/Quiz/emotional_methaphor_quiz.dart';
import 'package:navbar/RunningPage/Quiz/hopeless_romance_quiz.dart';
import 'package:navbar/RunningPage/Quiz/mental_stage_quiz.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 15),
        children: [
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/02.png',
            navigateTo: const AboutMeQuiz(),
            isRoundedLeft: true,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/11.png',
            navigateTo: const MentalStageQuiz(),
            isRoundedLeft: false,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/04.png',
            navigateTo: const HopelessRomanceQuiz(),
            isRoundedLeft: true,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/01.png',
            navigateTo: null,
            isRoundedLeft: false,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/08.png',
            navigateTo: const EmotionalMethaphorQuiz(),
            isRoundedLeft: true,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/03.png',
            navigateTo: null,
            isRoundedLeft: false,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/12.png',
            navigateTo: null,
            isRoundedLeft: true,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/05.png',
            navigateTo: null,
            isRoundedLeft: false,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/06.png',
            navigateTo: null,
            isRoundedLeft: true,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/07.png',
            navigateTo: null,
            isRoundedLeft: false,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/10.png',
            navigateTo: null,
            isRoundedLeft: true,
          ),
          buildNavButton(
            context,
            title: '',
            imagePath: 'assets/09.png',
            navigateTo: null,
            isRoundedLeft: false,
          ),
        ],
      ),
    );
  }

  Widget buildNavButton(BuildContext context,
      {required String title,
      required String imagePath,
      Widget? navigateTo,
      required bool isRoundedLeft}) {
    return GestureDetector(
      onTap: navigateTo == null
          ? () {
              print("Navigation canceled for this button.");
            }
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigateTo),
              );
            },
      child: Opacity(
        opacity: navigateTo == null ? 0.2 : 1.0, // Set opacity for null quizzes
        child: Container(
          margin: const EdgeInsets.only(bottom: 0),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: isRoundedLeft
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
