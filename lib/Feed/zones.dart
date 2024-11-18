import 'package:flutter/material.dart';
import 'package:navbar/Feed/zone-pages/animalpage.dart';
import 'package:navbar/Feed/zone-pages/blood-page.dart';
import 'package:navbar/Feed/zone-pages/busness.dart';

class ZonesPage extends StatelessWidget {
  const ZonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Your Zones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Horizontal scrollable GridView for 'Your Zones'
            SizedBox(
              height: 200,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 22 / 33,
                ),
                itemCount: zoneItems.length,
                itemBuilder: (context, index) {
                  final zone = zoneItems[index];
                  return GestureDetector(
                    onTap: zone['onTap'],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(zone['imagePath']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Alternating Layout for Navigation Images
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: RoundedImageButton(
                    imagePath: 'assets/zones/business.png',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Business()),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedImageButton(
                    imagePath: 'assets/zones/blood.png',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BloodPage()),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RoundedImageButton(
                    imagePath: 'assets/zones/pet.png',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Animal()),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Hyped',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Grid for 'Hyped'
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ImageButton(
                        imagePath: 'assets/zones/Artist zone.png',
                        onTap: () => print('BRAC Uni Artist tapped'),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ImageButton(
                        imagePath: 'assets/zones/Photo dump.png',
                        onTap: () => print('Mohakhali Photo Dump tapped'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ImageButton(
                        imagePath: 'assets/zones/Singers.png',
                        onTap: () => print('TB GATE SINGERS ZONE tapped'),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ImageButton(
                        imagePath: 'assets/zones/Coca Cola.jpeg',
                        onTap: () => print('Coca Cola tapped'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Your Type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: ImageButton(
                    imagePath: 'assets/zones/Samsung.png',
                    onTap: () => print('Samsung tapped'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ImageButton(
                    imagePath: 'assets/zones/Sex education.png',
                    onTap: () => print('Netflix tapped'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Followed by your knots and buddies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4 / 6,
                ),
                itemCount: zoneItems2.length,
                itemBuilder: (context, index) {
                  final zone = zoneItems2[index];
                  return GestureDetector(
                    onTap: zone['onTap'],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(zone['imagePath']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for Rounded Image Button without background or text
class RoundedImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const RoundedImageButton({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

// Image button widget without overlay text
class ImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const ImageButton({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Data for the grid items
final List<Map<String, dynamic>> zoneItems2 = [
  {
    'imagePath': 'assets/zones/Unicef.jpeg',
    'onTap': () => print('Unicef'),
  },
  {
    'imagePath': 'assets/zones/Girl empowerment.png',
    'title': 'GIRLS EMPOWERMENT ZONE',
    'onTap': () => print('Girl Empowerment tapped'),
  },
  {
    'imagePath': 'assets/zones/Nostalgia.png',
    'onTap': () => print('Nostalgia tapped'),
  },
];

final List<Map<String, dynamic>> zoneItems = [
  {
    'imagePath': 'assets/zones/Artist zone.png',
    'onTap': () => print('Sensation tapped'),
  },
  {
    'imagePath': 'assets/zones/Fur parents.png',
    'onTap': () => print('TB Gate Parents tapped'),
  },
  {
    'imagePath': 'assets/zones/Intellectuals.png',
    'onTap': () => print('Mohakhali Intellectual tapped'),
  },
];
