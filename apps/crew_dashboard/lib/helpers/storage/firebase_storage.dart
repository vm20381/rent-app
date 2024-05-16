import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageFromStorage extends StatelessWidget {
  final String imagePath;
  final FirebaseStorage storage = FirebaseStorage.instance;

  ImageFromStorage({Key? key, required this.imagePath}) : super(key: key);

  Future<Image> _loadImage() async {
    String imageUrl = await storage.ref(imagePath).getDownloadURL();
    return Image.network(
      imageUrl,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
            print('Error loading image: $exception');
            print(stackTrace);
        return Text('Failed to load image');
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
          return Text('Error loading image');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
