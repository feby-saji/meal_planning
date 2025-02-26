import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meal_planning/screens/generate_recipe.dart/functions/prompt_function.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

// Full process function
Future<String> downloadCompressAndConvertToWebP(String imageUrl) async {
  try {
    String imageName = imageUrl.split('/').last.split('.').first;

    Uint8List imageData = await downloadImage(imageUrl);
    logger.d('Image downloaded');

    Uint8List compressedImageData = await compute(compressAndConvertToWebP, imageData);
    // Uint8List compressedImageData = await compressAndConvertToWebP(imageData);
    logger.d('Image compressed and converted to WebP');

    return await saveImage(compressedImageData, imageName);
  } catch (e) {
    print('Error: $e');
    return '';
  }
}

Future<Uint8List> downloadImage(String imageUrl) async {
  var response = await http.get(Uri.parse(imageUrl));
  return response.bodyBytes;
}

Future<Uint8List> compressAndConvertToWebP(Uint8List imageData) async {
  return await Isolate.run(() {
    // Decode the image
    img.Image? image = img.decodeImage(imageData);
    if (image == null) throw Exception("Invalid image data");

    // Encode to WebP format with compression
    return Uint8List.fromList(img.encodeJpg(image, quality: 30));
  });
}

Future<String> saveImage(Uint8List imageData, String imageName) async {
  final appDirectory = await getApplicationDocumentsDirectory();
  final imagePath = '${appDirectory.path}/$imageName.webp';
  await File(imagePath).writeAsBytes(imageData);
  return imagePath;
}
