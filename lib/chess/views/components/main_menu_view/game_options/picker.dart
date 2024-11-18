import 'package:flutter/material.dart';

class Picker<T> extends StatelessWidget {
  final String? label;
  final Map<T, Text>? options;
  final T? selection;
  final Function(T?)? setFunc;

  const Picker(
      {super.key, this.label, this.options, this.selection, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label ?? "",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Jura',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none)),
        const SizedBox(height: 10),
        ToggleButtons(
          isSelected:
              options?.keys.map((key) => key == selection).toList() ?? [],
          onPressed: (index) => setFunc?.call(options?.keys.toList()[index]),
          borderRadius: BorderRadius.circular(10),
          constraints: const BoxConstraints(minWidth: 50, minHeight: 40),
          fillColor: const Color(0x88FFFFFF),
          selectedColor: Colors.white,
          color: Colors.white,
          borderColor: Colors.grey,
          children: options?.values.toList() ?? [],
        ),
      ],
    );
  }
}
