import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_planning/models/hive_models/recipe_model.dart';
import 'package:meal_planning/models/prompt.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class Gemini {
  var model;
  initGemini() async {
    const apiKey = 'AIzaSyByF-5W_VPix7y2RDQi-c_I3xvHAvELSV8';
    final generationConfig = GenerationConfig(
      maxOutputTokens: 3000,
      temperature: 0.7,
      topP: 0.1,
      topK: 16,
    );
    model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: apiKey,
        generationConfig: generationConfig,
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        ]);
  }

  Future<void> generateRecipe(PromptModel prompt) async {
    initGemini();

    final content = prompt.images.isNotEmpty
        ? await _buildMultiPartContent(prompt)
        : await _buildTextContent(prompt);

    try {
      final result = await model.generateContent(content);
      final jsonString = result.text;
      final startIndex = jsonString.indexOf('{'); // Find the first '{'
      final endIndex = jsonString.lastIndexOf('}'); // Find the last '}'

      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        final extractedJsonString =
            jsonString.substring(startIndex, endIndex + 1).trim();
        final jsonResponse = jsonDecode(extractedJsonString);
        // logger.d('response JSON: $jsonResponse');
        final recipe = RecipeModel.fromJsonGemini(jsonResponse);
      } else {
        logger.e('Valid JSON object not found in response.');
        // Handle the case where a valid JSON object wasn't found
        return;
      }
    } catch (e) {
      // ... handle other errors
    }
  }

  RecipeModel? createRecipeModelFromJson(json) {
    try {
      final jsonData = json.decode(json);
      final recipe = RecipeModel.fromJsonGemini(jsonData);
      print('recipe instructions: ${recipe.steps}');
      return recipe;
    } catch (e) {
      logger.e('JSON Parsing Error: $e\nJSON String: $json');
      // Handle JSON parsing error
      return null;
    }
  }

// Helper function to build multipart content (with images)
  Future<List<Content>> _buildMultiPartContent(PromptModel prompt) async {
    List<DataPart> imageDataParts = [];

    // Read each user-selected image file and convert to Uint8List
    for (XFile imageFile in prompt.images) {
      Uint8List imageBytes = await imageFile.readAsBytes();
      imageDataParts.add(
          DataPart('image/jpeg', imageBytes)); // Use 'image/jpeg' if applicable
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

  String promptForGeneratingRecipe(
      {cuisines, dietaryRestrictions, ingredients, additionalText}) {
    return '''
Imagine you are a talented chef with a passion for creating delicious and unique dishes.  You've been inspired by the movie Ratatouille to infuse creativity and passion into every recipe.

I need your help crafting an amazing recipe! 

Here's what I have in mind:

* **Cuisine:** $cuisines
* **Dietary Restrictions:** $dietaryRestrictions 
* **Ingredients I'd Love to Use (optional):** $ingredients
* **Anything Else:** $additionalText 

Please consider the following:

- The recipe should only use real, edible ingredients.
- Adhere to food safety guidelines (e.g., ensure poultry is fully cooked).
- Avoid repeating any ingredients.

Once you've designed the perfect dish, provide the recipe in the following JSON format ONLY.  Don't include any extra text or descriptions outside of this JSON structure. 


{
  "title": "Recipe Title",
  "reference_image": "https://example.com/image.png", 
  "servings": "4",
  "carbohydrates": "25g",
  "protein": "30g",
  "fat": "15g",
  "calorie": "15kcal",
  "preparation_time": "20 minutes",
  "cook_time": "15 minutes",
  "total_cook_and_preparation_time": "35 minutes",
  "instructions": [
    "Instruction 1",
    "Instruction 2", 
    "Instruction 3" 
  ],
  "ingredients": [
    "Ingredient 1",
    "Ingredient 2",
    "Ingredient 3" 
  ]
}

''';
  }
}
