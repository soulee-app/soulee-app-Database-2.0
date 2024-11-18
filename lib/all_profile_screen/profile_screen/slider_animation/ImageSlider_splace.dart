// image_slider1.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImagesliderSplace extends StatefulWidget {
  const ImagesliderSplace({super.key});

  @override
  State<ImagesliderSplace> createState() => _ImagesliderSplaceState();
}

class _ImagesliderSplaceState extends State<ImagesliderSplace> {
  int _currentIndex = 0;

  // List of image paths for the sliding images.
  final List<String> _images = [
    'assets/animation1/Beaches/Slider.png',
    'assets/animation1/Canyons/Slider.png',
    'assets/animation1/Caves/Slider.png',
    'assets/animation1/Dessert/Slider.png',
    'assets/animation1/Floating Islands/Slider.png',
    'assets/animation1/Frozen Landscape/Slider.png',
    'assets/animation1/Jungles/Slider.png',
    'assets/animation1/Lava Mountains/Slider.png',
    'assets/animation1/Mirror Lakes/Slider.png',
    'assets/animation1/Mountains/Slider.png',
    'assets/animation1/Mystical Gardens/Slider.png',
    'assets/animation1/Ocean/Slider.png',
    'assets/animation1/Ruins and Ancient Temples/Slider.png',
    'assets/animation1/Skies/Slider.png',
    'assets/animation1/Urban Landscape/Slider.png',
  ];

  // List of background image paths.
  final List<String> _backgroundImages = [
    'assets/animation1/Beaches/Background.png',
    'assets/animation1/Canyons/Background.png',
    'assets/animation1/Caves/Background.png',
    'assets/animation1/Dessert/Background.png',
    'assets/animation1/Floating Islands/Background.png',
    'assets/animation1/Frozen Landscape/Background.png',
    'assets/animation1/Jungles/Background.png',
    'assets/animation1/Lava Mountains/Background.png',
    'assets/animation1/Mirror Lakes/Background.png',
    'assets/animation1/Mountains/Background.png',
    'assets/animation1/Mystical Gardens/Background.png',
    'assets/animation1/Ocean/Background.png',
    'assets/animation1/Ruins and Ancient Temples/Background.png',
    'assets/animation1/Skies/Background.png',
    'assets/animation1/Urban Landscape/Background.png',
  ];

  // List of names to display as labels below the images.
  final List<String> _names = [
    'Beaches',
    'Canyons',
    'Caves',
    'Dessert',
    'Floating Islands',
    'Frozen Landscape',
    'Jungles',
    'Lava Mountains',
    'Mirror Lakes',
    'Mountains',
    'Mystical Gardens',
    'Ocean',
    'Ruins and Ancient Temples',
    'Skies',
    'Urban Landscape',
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
