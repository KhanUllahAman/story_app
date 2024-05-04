import 'package:epub_reader/epub_reader.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EPUB Reader',
      home: EpubReaderScreen(
        link:'https://firebasestorage.googleapis.com/v0/b/pagewise-dikr0z.appspot.com/o/Alices%20Adventures%20in%20Wonderland.epub?alt=media&token=2eebed6d-46ac-4b7a-8714-62fc7e3d4d6d',
      ),
    );
  }
}
