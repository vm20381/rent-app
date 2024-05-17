// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntityDetailsPage extends StatelessWidget {
  const EntityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entityId = Get.parameters['entityId'];
    if (kDebugMode) {
      print('Entity ID: $entityId');
    }
    if (entityId == null) {
      // If no entityId, redirect to the home page
      Future.microtask(
        () => Get.offAndToNamed('/'),
      );
      return const SizedBox(); // Returns an empty widget while the navigation completes
    } else {
      // If entityId is found, redirect to the entity-detail page with the entityId
      if (kDebugMode) {
        print('Redirecting to entity-detail page with entityId: $entityId');
      }
      Future.microtask(
        () => Get.offAndToNamed('/entities/entity-detail/$entityId'),
      );
      return const SizedBox(); // Returns an empty widget while the navigation completes
    }
  }
}

// class EntityDetailsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final entityId = Get.parameters['entityId'];
//     if (entityId == null) {
//       Future.microtask(
//         () => Get.offAndToNamed('/'),
//       ); // Redirects to the home page
//       return const SizedBox(); // Returns an empty widget while the navigation completes
//     } else {
//       return AssetPage(id: entityId);
//     }
//   }
// }

// class AssetPage extends StatefulWidget {
//   const AssetPage({super.key, required this.id});

//   final String id;

//   @override
//   State<AssetPage> createState() => _AssetPageState();
// }

// class _AssetPageState extends State<AssetPage> {
//   Map<String, dynamic> item = {};
//   List<Map<String, dynamic>> documents = []; // List to store document data
//   final FirebaseStorage storage = FirebaseStorage.instance;

//   Future<List<Map<String, String>>> listFiles() async {
//     // Get the list result from the specified folder
//     ListResult result = await storage.ref('documents/${item['id']}').listAll();

//     // Initialize an empty list of maps
//     List<Map<String, String>> files = [];

//     // Use a for loop to await on each getDownloadURL call
//     for (var fileRef in result.items) {
//       var url = await fileRef.getDownloadURL(); // Await the future to resolve
//       files.add({
//         'name': fileRef.name, // File name is already a string
//         'url': url, // URL is a string from the awaited Future
//       });
//     }

//     return files;
//   }

//   Future<void> safeLaunchUrl(String urlString) async {
//     try {
//       final bool launched = await launchUrl(Uri.parse(urlString));

//       if (!launched) {
//         // Handle the fact that the launch was not successful

//         throw 'Failed to launch $urlString'; // `throw could not launch` is used for error handling
//       }
//     } on Exception catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Fetch data from Firestore
//     FirebaseFirestore.instance
//         .collection('entities')
//         .doc(widget.id)
//         .get()
//         .then((DocumentSnapshot doc) {
//       item = {
//         'id': doc.id,
//         'name': doc['name'],
//         'category': doc['category'],
//         'description': doc['description'],
//       };

//       listFiles().then((files) {
//         for (var file in files) {
//           documents.add(file);
//         }
//         setState(() {});
//       });

//       // Update the UI with the new data
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (item.isEmpty) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               item['name'], // Displaying the name
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8), // Adds spacing between text widgets
//             Text(
//               item['category'], // Displaying the category
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[600],
//               ),
//             ),
//             Text(
//               item['id'].toString(), // Displaying the ID
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 16), // Adds spacing before the description
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 item['description'], // Displaying the description
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[800],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 24,
//             ), // Adds spacing before the image
//             SvgPicture.network(
//               "https://storage.googleapis.com/co2-target/qrcodes/${item['id']}.svg",
//               width: MediaQuery.of(context).size.width * 0.8,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(
//               height: 20,
//             ), // Adds vertical space between SVG and document list
//             Container(
//               alignment: Alignment.center,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: documents.map((doc) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           doc['name']!,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(width: 20),
//                         IconButton(
//                           icon: const Icon(Icons.download),
//                           onPressed: () async {
//                             if (await canLaunchUrl(Uri.parse(doc['url']))) {
//                               await launchUrl(Uri.parse(doc['url']));
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content:
//                                       Text('Could not launch ${doc['url']}'),
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ), // Adds vertical space before the back button
//             ElevatedButton(
//               onPressed: () => Get.toNamed('/dashboard'),
//               child: const Text('Back to list'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
