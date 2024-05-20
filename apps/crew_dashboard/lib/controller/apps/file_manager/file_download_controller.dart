import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/models/entity_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FileDownloadController extends MyController {
  List<EntityDocument> fileList = [];

  @override
  void onInit() {
    super.onInit();
    loadFilesFromEntities();
  }

  void loadFilesFromEntities() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Fetch all documents from the 'entities' collection
      QuerySnapshot entitiesSnapshot =
          await firestore.collection('entities').get();

      for (var entityDoc in entitiesSnapshot.docs) {
        String entityId = entityDoc.id;

        // Fetch documents related to the current entity
        QuerySnapshot documentsSnapshot =
            await firestore.collection('entities/$entityId/documents').get();

        // Map the documents to the EntityDocument class with proper type handling
        List<EntityDocument> entityDocuments =
            documentsSnapshot.docs.map((doc) {
          // Extract data with type conversion and null checks
          String name = doc['name']?.toString() ?? 'Unnamed';
          // String size = doc['size']?.toString() ??
          //     '0'; // Convert to string and ensure default value

          return EntityDocument(
            id: doc.id,
            name: name,
            // size: size, // Ensure size is expected to be a string
          );
        }).toList();

        fileList.addAll(entityDocuments);

        // Optionally initiate a download process for each document
        for (var doc in entityDocuments) {
          downloadDocument(
              doc,); // Assuming you have a function to handle the download
        }
      }

      // Update the UI after loading new data
      update();
    } catch (error) {
      // Handle any errors that occur during data fetching or conversion
      print('Error loading documents: $error');
    }
  }

  void downloadDocument(EntityDocument document) {
    // Implement the actual download logic here
    // For example, downloading a file from a URL found in the document data
    print('Downloading document: ${document.name}');
  }
}
