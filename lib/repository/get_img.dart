import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> downloadCompressAndGetPath(String imageUrl) async {
  try {
    String imageName = imageUrl.split('/').last;
    // Download the image
    var response = await http.get(Uri.parse(imageUrl));
    Uint8List imageData = response.bodyBytes;

    // Compress the image
    List<int> compressedImageData = await FlutterImageCompress.compressWithList(
      imageData,
      minHeight: 300, // Adjust these parameters as needed
      minWidth: 300,
      quality: 30,
    );

    // Save the compressed image data to a file
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final compressedImagePath =
        '${appDocumentDirectory.path}/$imageName.jpg';
    File(compressedImagePath).writeAsBytesSync(compressedImageData);

    // Return the path of the compressed image
    return compressedImagePath;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
