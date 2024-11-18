import 'package:flutter/material.dart';

class HashTagText extends StatelessWidget {
  const HashTagText({
    super.key,
    required this.texts,
  });

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(texts.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Text(
                '#',
              ),
              Text(
                texts[index],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}


