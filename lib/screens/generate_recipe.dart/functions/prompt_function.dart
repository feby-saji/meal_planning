import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/models/prompt.dart';
import 'package:logger/logger.dart';
import 'package:meal_planning/screens/generate_recipe.dart/functions/prompt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Logger logger = Logger();

class Gemini {
  var model;
  initGemini() async {
    String apiKey = dotenv.env['GEMINIAPI'] ?? 'API key not found';

    final generationConfig = GenerationConfig(
      maxOutputTokens: 2000,
      temperature: 0.8,
      topP: 0.1,
      topK: 16,
    );
    model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: generationConfig,
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        ]);
  }

  Future generateRecipe(PromptModel prompt) async {
    initGemini();

    final content = prompt.images.isNotEmpty
        ? await _buildMultiPartContent(prompt)
        : await _buildTextContent(prompt);

    try {
      final response = await model.generateContent(content);
      final jsonString = cleanJson(response.text);
//
      // logger.d('response. ${response.text}');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      logger.d('response. ${jsonData['title']}');
      RecipeModel recipe = RecipeModel.fromJsonGemini(jsonData);
      return recipe;
    } catch (e) {
      logger.e('error found in response. $e');
      return e.toString();
    }
  }
}

String cleanJson(String maybeInvalidJson) {
  if (maybeInvalidJson.contains('```')) {
    final withoutLeading = maybeInvalidJson.split('```json').last;
    final withoutTrailing = withoutLeading.split('```').first;
    return withoutTrailing;
  }
  return maybeInvalidJson;
}

// Helper function to build multipart content (with images)
Future<List<Content>> _buildMultiPartContent(PromptModel prompt) async {
  List<DataPart> imageDataParts = [];

  // Read each user-selected image file and convert to Uint8List
  for (XFile imageFile in prompt.images) {
    Uint8List imageBytes = await imageFile.readAsBytes();
    imageDataParts.add(DataPart('image/jpeg', imageBytes));
  }

  return [
    Content.multi([
      TextPart(promptForGeneratingRecipe(
        cuisines: prompt.cuisine,
        dietaryRestrictions: prompt.dietaryRestrictions,
        ingredients: prompt.stapleIngredients,
        additionalText: prompt.additionalContext,
      )),
      ...imageDataParts, // Spread the image data parts
    ])
  ];
}

// Helper function to build text-only content
Future<List<Content>> _buildTextContent(PromptModel prompt) async {
  return [
    Content.text(promptForGeneratingRecipe(
      cuisines: prompt.cuisine,
      dietaryRestrictions: prompt.dietaryRestrictions,
      ingredients: prompt.stapleIngredients,
      additionalText: prompt.additionalContext,
    ))
  ];
}
