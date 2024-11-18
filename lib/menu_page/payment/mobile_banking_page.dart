import 'package:flutter/material.dart';

class MobileBankingPage extends StatefulWidget {
  const MobileBankingPage({super.key});

  @override
  State<MobileBankingPage> createState() => _MobileBankingPageState();
}

class _MobileBankingPageState extends State<MobileBankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soulee.com.bd'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.support),
                    Text('Support'),
                  ],
                ),
                Column(
                  children: [
                    Stack(
                      children: [
                        Icon(Icons.help),
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Text(
                              '2',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('FAQ'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.local_offer),
                    Text('Offers'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.login),
                    Text('Login'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 30,
          ),
          Container(
            color: Colors.redAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Cards',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Mobile Banking',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Net Banking',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                _buildBankingOption('bKash', 'assets/payment/bkash.png'),
                _buildBankingOption('Rocket', 'assets/payment/rocket.png'),
                _buildBankingOption(
                    'Islami Bank M Cash', 'assets/payment/mcash.png'),
                _buildBankingOption('MY Cash', 'assets/payment/mycash.png'),
                _buildBankingOption('AB Bank', 'assets/payment/ab.png'),
                _buildBankingOption('T-Cash', 'assets/payment/tcash.png'),
                _buildBankingOption('OK Wallet', 'assets/payment/okwallet.png'),
                _buildBankingOption('SureCash', 'assets/payment/surecash.png'),
                _buildBankingOption('Dmoney', 'assets/payment/dmoney.png'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent, // Set the background color to redAccent
              ),
              onPressed: () {},
              child: const Text(
                'Pay ৳60.00',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankingOption(String name, String assetPath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(assetPath, height: 50),
        const SizedBox(height: 8),
        Text(name, textAlign: TextAlign.center),
      ],
    );
  }
}
