import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageFromStorage extends StatelessWidget {
  final String imagePath;
  final FirebaseStorage storage = FirebaseStorage.instance;

  ImageFromStorage({super.key, required this.imagePath});

  Future<Image> _loadImage() async {
    String imageUrl = await storage.ref(imagePath).getDownloadURL();
    return Image.network(
      imageUrl,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
            print('Error loading image: $exception');
            print(stackTrace);
        return const Text('Failed to load image');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImage(),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.error != null) {
          return const Text('Error loading image');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
