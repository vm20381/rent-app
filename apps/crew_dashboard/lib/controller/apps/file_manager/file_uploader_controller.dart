import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:http_parser/http_parser.dart';

class FileUploaderController extends MyController {
  List<PlatformFile> files = [];

  // Function to pick files
  Future<void> pickFile(String entityId) async {
    var result = await FilePicker.platform.pickFiles();
    if (result?.files.isNotEmpty == true) {
      files.addAll(result!.files);
      update();
      for (var file in files) {
        await apendFileData(entityId, file);
      }
      uploadFiles(entityId);
    }
  }

  void removeFile(PlatformFile file) {
    files.remove(file);
    update();
  }

  Future<void> apendFileData(
    String entityId,
    PlatformFile file,
  ) async {
    String baseName = file.name.split('.').first.split('-').last;
    String catagory = file.name.split('.').first.split('-').first;

    String baseURL =
        'https://firebasestorage.googleapis.com/v0/b/captainapp-crew-2024.appspot.com/';

    String fileUrl = '$baseURL/$entityId-${file.name}';
    try {
      await FirebaseFirestore.instance
          .collection('entities')
          .doc(entityId)
          .collection('documents')
          .add({
        'name': baseName,
        'catagory': catagory,
        'size': file.size,
        'fileUrl': fileUrl, // Add the file URL to the document
      });

      print('File data added to Firestore');
    } catch (e) {
      print('Error adding file data to Firestore: $e');
    }
  }

  // Function to upload files

  Future<void> uploadFiles(String entityId) async {
    // access token
    var token =
        'Bearer ya29.a0Ad52N3-gYWZEH8mSuVJnkv-T5st0zBzRxYR4fUsNxO5tkIz7fG8vFpMyZUreKLDMOfyhnl7k6ZtNGBafq574ANprXj98qtZF3GvE_pndaFvQrk2_tUjuMrvPzm_cCtbDnUog2SVe9Wb7AlRpQwO9utBYettnxCiTHwaCgYKATwSARMSFQHGX2MiPJMfRZYkiiNAklCPMndZTw0169';
    var headers = {
      'Authorization': token,
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://europe-west1-captainapp-crew-2024.cloudfunctions.net/save_pdf',
      ),
    );

    for (var file in files) {
      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'pdf',
            file.bytes!,
            filename: '$entityId-${file.name}',
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }
    }

    request.headers.addAll(headers);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print("Upload successful: $responseBody");
      } else {
        print("Upload failed with status ${response.statusCode}");
      }
    } catch (e) {
      print("Error during upload: $e");
    }
  }
}
