import 'package:flutter/material.dart';
import 'Book.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    final title = book.title;
    final author = book.author;
    final description = book.description;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book details'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("\"$title\" by $author",
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Text("$description"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}