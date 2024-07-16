import 'package:image_picker/image_picker.dart';

class PromptModel {
  List<XFile> images = [];
  List dietaryRestrictions = [];
  List stapleIngredients = [];
  String cuisine = '';
  String additionalContext = '';

  PromptModel({
    required this.images,
    required this.dietaryRestrictions,
    required this.stapleIngredients,
    this.cuisine = '',
    this.additionalContext = '',
  });
}
