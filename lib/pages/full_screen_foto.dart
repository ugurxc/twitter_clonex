
import 'package:flutter/material.dart';
class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImagePage({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tam Ekran Görüntü'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1.0, 
          maxScale: 4.0, 
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}