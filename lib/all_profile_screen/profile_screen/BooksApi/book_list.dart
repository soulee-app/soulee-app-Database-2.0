// lib/screens/book_list.dart

import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  final List<dynamic> books;
  final Function(dynamic) onBookTap; // Callback for book selection

  const BookList({super.key, required this.books, required this.onBookTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index]['volumeInfo'];
        return ListTile(
          leading: book['imageLinks'] != null
              ? Image.network(book['imageLinks']['thumbnail'])
              : const Icon(Icons.book),
          title: Text(book['title'] ?? 'No Title Available'),
          subtitle: Text(
            book['authors'] != null
                ? book['authors'].join(', ')
                : 'Unknown Author',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              onBookTap(book); // Trigger the callback with the selected book
            },
          ),
          onTap: () {
            onBookTap(book); // Trigger the callback with the selected book
          },
        );
      },
    );
  }
}
