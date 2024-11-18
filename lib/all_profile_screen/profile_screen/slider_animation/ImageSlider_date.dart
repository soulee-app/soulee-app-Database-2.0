// image_slider2.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImagesliderDate extends StatefulWidget {
  const ImagesliderDate({super.key});

  @override
  State<ImagesliderDate> createState() => _ImagesliderDateState();
}

class _ImagesliderDateState extends State<ImagesliderDate> {
  int _currentIndex = 0;

  // List of image paths for the sliding images.
  final List<String> _images = [
    'assets/animation2/Beachdate/Slider.png',
    'assets/animation2/Bookstore Hangout/Slider.png',
    'assets/animation2/Concert Date/Slider.png',
    'assets/animation2/Dinner Date/Slider.png',
    'assets/animation2/Game Night/Slider.png',
    'assets/animation2/Movie Date/Slider.png',
    'assets/animation2/Museum Date/Slider.png',
    'assets/animation2/Picnic in a Park/Slider.png',
    'assets/animation2/Protest Together/Slider.png',
    'assets/animation2/Rave/Slider.png',
    'assets/animation2/Sport Event/Slider.png',
    'assets/animation2/Stargazing/Slider.png',
    'assets/animation2/Touring/Slider.png',
    'assets/animation2/Zoo Date/Slider.png',
  ];

  // List of background image paths.
  final List<String> _backgroundImages = [
    'assets/animation2/Beachdate/Background.png',
    'assets/animation2/Bookstore Hangout/Background.png',
    'assets/animation2/Concert Date/Background.png',
    'assets/animation2/Dinner Date/Background.png',
    'assets/animation2/Game Night/Background.png',
    'assets/animation2/Movie Date/Background.png',
    'assets/animation2/Museum Date/Background.png',
    'assets/animation2/Picnic in a Park/Background.png',
    'assets/animation2/Protest Together/Background.png',
    'assets/animation2/Rave/Background.png',
    'assets/animation2/Sport Event/Background.png',
    'assets/animation2/Stargazing/Background.png',
    'assets/animation2/Touring/Background.png',
    'assets/animation2/Zoo Date/Background.png',
  ];

  // List of names to display as labels below the images.
  final List<String> _names = [
    'Beachdate',
    'Bookstore Hangout',
    'Concert Date',
    'Dinner Date',
    'Game Night',
    'Movie Date',
    'Museum Date',
    'Picnic in a Park',
    'Protest Together',
    'Rave',
    'Sport Event',
    'Stargazing',
    'Touring',
    'Zoo Date',
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
