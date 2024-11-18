// image_slider4.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImagesliderHobby extends StatefulWidget {
  const ImagesliderHobby({super.key});

  @override
  State<ImagesliderHobby> createState() => _ImagesliderHobbyState();
}

class _ImagesliderHobbyState extends State<ImagesliderHobby> {
  int _currentIndex = 0;

  // List of image paths for the sliding images.
  final List<String> _images = [
    'assets/animation4/Baking/Slider.png',
    'assets/animation4/Calligraphy/Slider.png',
    'assets/animation4/Cooking/Slider.png',
    'assets/animation4/Dancing/Slider.png',
    'assets/animation4/Gardening/Slider.png',
    'assets/animation4/Journaling/Slider.png',
    'assets/animation4/Painting/Slider.png',
    'assets/animation4/Photography/Slider.png',
    'assets/animation4/Traveller/Slider.png',
    'assets/animation4/Writing/Slider.png',
  ];

  // List of background image paths.
  final List<String> _backgroundImages = [
    'assets/animation4/Baking/Background.png',
    'assets/animation4/Calligraphy/Background.png',
    'assets/animation4/Cooking/Background.png',
    'assets/animation4/Dancing/Background.png',
    'assets/animation4/Gardening/Background.png',
    'assets/animation4/Journaling/Background.png',
    'assets/animation4/Painting/Background.png',
    'assets/animation4/Photography/Background.png',
    'assets/animation4/Traveller/Background.png',
    'assets/animation4/Writing/Background.png',
  ];

  // List of names to display as labels below the images.
  final List<String> _names = [
    'Baking',
    'Calligraphy',
    'Cooking',
    'Dancing',
    'Gardening',
    'Journaling',
    'Painting',
    'Photography',
    'Traveller',
    'Writing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image that changes as per the selected image
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_backgroundImages[_currentIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Carousel slider for sliding the images manually
          Center(
            child: CarouselSlider.builder(
              itemCount: _images.length,
              options: CarouselOptions(
                height: 300, // Adjust height as needed
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: false, // Disable automatic sliding
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Transform.rotate(
                  angle: -0.1, // Slight tilt effect
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(_images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dynamic label for the current image
          Positioned(
            bottom: 190,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200,
                height: 35,
                color: const Color.fromARGB(255, 182, 82, 10),
                child: Center(
                  child: Stack(
                    children: [
                      Text(
                        _names[_currentIndex],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        _names[_currentIndex],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Confirm button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle image selection confirmation
                  Navigator.pop(
                      context, _names[_currentIndex]); // Returning the name
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
