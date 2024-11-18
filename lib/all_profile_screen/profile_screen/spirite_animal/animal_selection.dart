import 'package:flutter/material.dart';
import 'package:navbar/all_profile_screen/profile_screen/spirite_animal/slider_animation.dart';

class AnimalSelectionApp extends StatelessWidget {
  const AnimalSelectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimalSliderPage(),
    );
  }
}

class AnimalSliderPage extends StatefulWidget {
  const AnimalSliderPage({super.key});

  @override
  _AnimalSliderPageState createState() => _AnimalSliderPageState();
}

class _AnimalSliderPageState extends State<AnimalSliderPage> {
  List<String> animalNames = [
    'Angora Rabbit', 'Ankylosaurus', 'Bald Eagle', 'Border Collie',
    'Bunny', 'Capybara', 'Cat', 'Cow', 'Dodo',
    // Add more animals if needed
  ];

  String selectedAnimal = '';
  int currentIndex = 0; // To track the current index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/Logo.png', //logo image path
          height: 170, // Increase the height to make the logo larger
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/Background.png'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Add some space between the app bar and ListView
          Padding(
            padding: const EdgeInsets.only(
                top: 40.0), // Adjust the top padding as needed
            child: SizedBox(
              height: 200, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: animalNames.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              'assets/animal/${animalNames[index]}.png',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            animalNames[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Center(
                    child: InfiniteDragableSlider(
                      itemCount: animalNames.length,
                      onIndexChanged: (index) {
                        setState(() {
                          currentIndex = index %
                              animalNames
                                  .length; // Ensure the index is in range
                        });
                      },
                      itemBuilder: (context, index) {
                        currentIndex = index % animalNames.length;
                        final animalName = animalNames[currentIndex];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              animalName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Image.asset(
                              'assets/animal/$animalName.png',
                              width: 240,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedAnimal = animalNames[
                        currentIndex]; // Select the animal based on current index
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AnimalDetailPage(animalName: selectedAnimal),
                    ),
                  );
                },
                child: const Text("Confirm Selection",
                    style: TextStyle(
                      color: Colors.redAccent,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimalDetailPage extends StatelessWidget {
  final String animalName;

  const AnimalDetailPage({super.key, required this.animalName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/Logo.png', // Replace with your logo image path
          height: 170,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              animalName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/animal/$animalName.png',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
