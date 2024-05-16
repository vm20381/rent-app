import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageFromStorage extends StatelessWidget {
  final String imagePath;
  final FirebaseStorage storage = FirebaseStorage.instance;

  ImageFromStorage({Key? key, required this.imagePath}) : super(key: key);

  Future<Image> _loadImage() async {
    String imageUrl = await storage.ref(imagePath).getDownloadURL();
    return Image.network(imageUrl);
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
          // return Text('Error loading image');
          return Icon(Icons.error_outline);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
