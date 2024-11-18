import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white,size: 30,),
            ),
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.settings, color: Colors.white,size: 30,),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.search_sharp, color: Colors.white,size: 30),
            ),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white,size: 30,),
            ),
          ],
        ),
      ],
    );
  }
}
