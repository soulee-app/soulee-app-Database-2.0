import 'package:flutter/material.dart';

import '../../all_profile_screen/profile_screen/widgets/custom_mask_widget.dart';

class Animal extends StatelessWidget {
  const Animal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Left Column with three smaller images stacked vertically
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _buildImageButton(
                      context,
                      'assets/zones/animal/Birds.png',
                      'Birds',
                      const BirdsPage(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _buildImageButton(
                      context,
                      'assets/zones/animal/Bunnies.png',
                      'Bunnies',
                      const BunniesPage(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _buildImageButton(
                      context,
                      'assets/zones/animal/Cats.png',
                      'Cats',
                      const CatsPage(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right Column with two larger images stacked vertically
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _buildImageButton(
                      context,
                      'assets/zones/animal/Dogs.png',
                      'Dogs',
                      const DogsPage(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _buildImageButton(
                      context,
                      'assets/zones/animal/List Animals.png',
                      'List Animals',
                      const ListAnimalsPage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton(
    BuildContext context,
    String imagePath,
    String label,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
            // Reduced image size to make space for the label
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 15.0), // Create space for the button
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Positioned text at the bottom-right, half inside and half outside the image
            Positioned(
              bottom: -10, // Slightly below the image
              right: -10, // Slightly to the right of the image
              child: Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BirdsPage extends StatelessWidget {
  const BirdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/zones/Business/BG.png', // Background image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/zones/Business/Group 1.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    const Positioned(
                      bottom: -40, // Negative offset for positioning
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CustomMaskWidget(
                            image: 'assets/img.png',
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Options Section (using images for buttons placed more closely)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildOptionImage('assets/zones/Business/1.png',
                          width: 180, height: 30),
                      const SizedBox(
                          height: 2), // Decreased spacing between buttons
                      _buildOptionImage('assets/zones/Business/2.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/3.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/4.png',
                          width: 180, height: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Switched Image Row Section with Infinity Icon in between
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child:
                      Icon(Icons.all_inclusive, size: 28, color: Colors.grey),
                ),

                const SizedBox(height: 5),

                // Tap Your Favorite Button Section
                Center(
                  child: Image.asset(
                    'assets/Knot Business/Animal/bird (1).png', // Button image asset with embedded text
                    width: 130, // Made smaller to fit the layout
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 5),

                Image.asset(
                  'assets/Animal 2/Birds.png', // Button image asset with embedded text
                  width: 500,
                  height: 100, // Made smaller to fit the layout
                  fit: BoxFit.cover,
                ),
                // Map Section with Overlay
                Expanded(
                  child: Stack(
                    children: [
                      // Map Image with proper fit and alignment
                      Positioned.fill(
                        child: Image.asset(
                          'assets/zones/Business/Group 6.png', // Map image asset path
                          fit: BoxFit
                              .cover, // Cover the entire width while preserving aspect ratio
                          alignment: Alignment
                              .topCenter, // Align to show the wave properly
                        ),
                      ),
                      // Overlay "5 Miles Radius" Text
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/zones/Business/Group 5.png', // "5 Miles Radius" asset
                          width: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionImage(
    String imagePath, {
    double width = 150,
    double height = 30,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

class BunniesPage extends StatelessWidget {
  const BunniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/zones/Business/BG.png', // Background image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/zones/Business/Group 1.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    const Positioned(
                      bottom: -40, // Negative offset for positioning
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CustomMaskWidget(
                            image: 'assets/img.png',
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Options Section (using images for buttons placed more closely)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildOptionImage('assets/zones/Business/1.png',
                          width: 180, height: 30),
                      const SizedBox(
                          height: 2), // Decreased spacing between buttons
                      _buildOptionImage('assets/zones/Business/2.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/3.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/4.png',
                          width: 180, height: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Switched Image Row Section with Infinity Icon in between
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child:
                      Icon(Icons.all_inclusive, size: 28, color: Colors.grey),
                ),

                const SizedBox(height: 5),

                // Tap Your Favorite Button Section
                Center(
                  child: Image.asset(
                    'assets/Knot Business/Animal/bunny (1).png', // Button image asset with embedded text
                    width: 130, // Made smaller to fit the layout
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 5),

                Image.asset(
                  'assets/Animal 2/Bunnies.png', // Button image asset with embedded text
                  width: 500,
                  height: 100, // Made smaller to fit the layout
                  fit: BoxFit.cover,
                ),
                // Map Section with Overlay
                Expanded(
                  child: Stack(
                    children: [
                      // Map Image with proper fit and alignment
                      Positioned.fill(
                        child: Image.asset(
                          'assets/zones/Business/Group 6.png', // Map image asset path
                          fit: BoxFit
                              .cover, // Cover the entire width while preserving aspect ratio
                          alignment: Alignment
                              .topCenter, // Align to show the wave properly
                        ),
                      ),
                      // Overlay "5 Miles Radius" Text
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/zones/Business/Group 5.png', // "5 Miles Radius" asset
                          width: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionImage(
    String imagePath, {
    double width = 150,
    double height = 30,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

class DogsPage extends StatelessWidget {
  const DogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/zones/Business/BG.png', // Background image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/zones/Business/Group 1.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    const Positioned(
                      bottom: -40, // Negative offset for positioning
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CustomMaskWidget(
                            image: 'assets/img.png',
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Options Section (using images for buttons placed more closely)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildOptionImage('assets/zones/Business/1.png',
                          width: 180, height: 30),
                      const SizedBox(
                          height: 2), // Decreased spacing between buttons
                      _buildOptionImage('assets/zones/Business/2.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/3.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/4.png',
                          width: 180, height: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Switched Image Row Section with Infinity Icon in between
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child:
                      Icon(Icons.all_inclusive, size: 28, color: Colors.grey),
                ),

                const SizedBox(height: 5),

                // Tap Your Favorite Button Section
                Center(
                  child: Image.asset(
                    'assets/Knot Business/Animal/dog (1).png', // Button image asset with embedded text
                    width: 130, // Made smaller to fit the layout
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 5),

                Image.asset(
                  'assets/Animal 2/Dog.png', // Button image asset with embedded text
                  width: 500,
                  height: 100, // Made smaller to fit the layout
                  fit: BoxFit.cover,
                ),
                // Map Section with Overlay
                Expanded(
                  child: Stack(
                    children: [
                      // Map Image with proper fit and alignment
                      Positioned.fill(
                        child: Image.asset(
                          'assets/zones/Business/Group 6.png', // Map image asset path
                          fit: BoxFit
                              .cover, // Cover the entire width while preserving aspect ratio
                          alignment: Alignment
                              .topCenter, // Align to show the wave properly
                        ),
                      ),
                      // Overlay "5 Miles Radius" Text
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/zones/Business/Group 5.png', // "5 Miles Radius" asset
                          width: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionImage(
    String imagePath, {
    double width = 150,
    double height = 30,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

class CatsPage extends StatelessWidget {
  const CatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/zones/Business/BG.png', // Background image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/zones/Business/Group 1.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    const Positioned(
                      bottom: -40, // Negative offset for positioning
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CustomMaskWidget(
                            image: 'assets/img.png',
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Options Section (using images for buttons placed more closely)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildOptionImage('assets/zones/Business/1.png',
                          width: 180, height: 30),
                      const SizedBox(
                          height: 2), // Decreased spacing between buttons
                      _buildOptionImage('assets/zones/Business/2.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/3.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/4.png',
                          width: 180, height: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Switched Image Row Section with Infinity Icon in between
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child:
                      Icon(Icons.all_inclusive, size: 28, color: Colors.grey),
                ),

                const SizedBox(height: 5),

                // Tap Your Favorite Button Section
                Center(
                  child: Image.asset(
                    'assets/Knot Business/Animal/cat (1).png', // Button image asset with embedded text
                    width: 130, // Made smaller to fit the layout
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 5),

                Image.asset(
                  'assets/Animal 2/Cat.png', // Button image asset with embedded text
                  width: 500,
                  height: 100, // Made smaller to fit the layout
                  fit: BoxFit.cover,
                ),
                // Map Section with Overlay
                Expanded(
                  child: Stack(
                    children: [
                      // Map Image with proper fit and alignment
                      Positioned.fill(
                        child: Image.asset(
                          'assets/zones/Business/Group 6.png', // Map image asset path
                          fit: BoxFit
                              .cover, // Cover the entire width while preserving aspect ratio
                          alignment: Alignment
                              .topCenter, // Align to show the wave properly
                        ),
                      ),
                      // Overlay "5 Miles Radius" Text
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/zones/Business/Group 5.png', // "5 Miles Radius" asset
                          width: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionImage(
    String imagePath, {
    double width = 150,
    double height = 30,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

class ListAnimalsPage extends StatelessWidget {
  const ListAnimalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/zones/Business/BG.png', // Background image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/zones/Business/Group 1.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    const Positioned(
                      bottom: -40, // Negative offset for positioning
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CustomMaskWidget(
                            image: 'assets/img.png',
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Options Section (using images for buttons placed more closely)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildOptionImage('assets/zones/Business/1.png',
                          width: 180, height: 30),
                      const SizedBox(
                          height: 2), // Decreased spacing between buttons
                      _buildOptionImage('assets/zones/Business/2.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/3.png',
                          width: 180, height: 30),
                      const SizedBox(height: 2),
                      _buildOptionImage('assets/zones/Business/4.png',
                          width: 180, height: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Switched Image Row Section with Infinity Icon in between
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child:
                      Icon(Icons.all_inclusive, size: 28, color: Colors.grey),
                ),

                const SizedBox(height: 5),

                // Tap Your Favorite Button Section
                Center(
                  child: Image.asset(
                    'assets/Knot Business/Animal/list animal (1).png', // Button image asset with embedded text
                    width: 130, // Made smaller to fit the layout
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 5),

                Image.asset(
                  'assets/Animal 2/List Animals.png', // Button image asset with embedded text
                  width: 500,
                  height: 100, // Made smaller to fit the layout
                  fit: BoxFit.cover,
                ),
                // Map Section with Overlay
                Expanded(
                  child: Stack(
                    children: [
                      // Map Image with proper fit and alignment
                      Positioned.fill(
                        child: Image.asset(
                          'assets/zones/Business/Group 6.png', // Map image asset path
                          fit: BoxFit
                              .cover, // Cover the entire width while preserving aspect ratio
                          alignment: Alignment
                              .topCenter, // Align to show the wave properly
                        ),
                      ),
                      // Overlay "5 Miles Radius" Text
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/zones/Business/Group 5.png', // "5 Miles Radius" asset
                          width: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionImage(
    String imagePath, {
    double width = 150,
    double height = 30,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
