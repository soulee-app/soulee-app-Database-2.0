import 'package:flutter/material.dart';
import 'package:navbar/menu_page/payment/mobile_banking_page.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isChecked = false;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<String> _backgroundImages = [
    'assets/payment/60tk/BG.png',
    'assets/payment/110tk/BG110.png',
    'assets/payment/150tk/BG.png'
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image that changes with the page index
          Positioned.fill(
            child: Image.asset(
              _backgroundImages[_currentPage],
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      buildPageContent('assets/payment/60tk/Price.png', [
                        'assets/payment/60tk/Group 8.png',
                        'assets/payment/60tk/Group 7.png',
                        'assets/payment/60tk/Group 6.png',
                        'assets/payment/60tk/Group 5.png',
                        'assets/payment/60tk/Group 4.png',
                      ]),
                      buildPageContent('assets/payment/110tk/Price 110.png', [
                        'assets/payment/110tk/12.png',
                        'assets/payment/110tk/13.png',
                        'assets/payment/110tk/14.png',
                        'assets/payment/110tk/15.png',
                      ]),
                      buildPageContent('assets/payment/150tk/Price.png', [
                        'assets/payment/150tk/17.png',
                        'assets/payment/150tk/18.png',
                        'assets/payment/150tk/19.png',
                        'assets/payment/150tk/20.png',
                        'assets/payment/150tk/21.png',
                      ]),
                    ],
                  ),
                ),
                buildPageIndicator(),
                buildTermsAndConditions(),
                buildSubscribeButton(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageContent(String mainImage, List<String> otherImages) {
    return Stack(
      children: [
        Positioned(
          top: 75,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(mainImage),
                ),
              ),
            ),
          ),
        ),
        for (int i = 0; i < otherImages.length; i++)
          Positioned(
            top: 290 + i * 70.0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(otherImages[i]),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.redAccent : Colors.grey,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }

  Widget buildTermsAndConditions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
          const Expanded(
            child: Text(
              'TERMS AND CONDITIONS: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubscribeButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 10,
        ),
        onPressed: isChecked
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MobileBankingPage()));
              }
            : null,
        child: const Text(
          'SUBSCRIBE NOW',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
