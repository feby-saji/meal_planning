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
    const apiKey = 'AIzaSyCyft66lGbFjron4cPJy7kwo4VzN1hV-uE';

    final generationConfig = GenerationConfig(
      maxOutputTokens: 2000,
      temperature: 0.8,
      topP: 0.1,
      topK: 16,
    );
    model = GenerativeModel(
      // triedd uing gemini pro
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

* **Cuisine:** $cuisines or you choose
* **Dietary Restrictions:** $dietaryRestrictions or you choose
* **Ingredients I'd Love to Use (optional):** $ingredients or you choose
* **Anything Else:** $additionalText or you choose

Please consider the following:

- The recipe should only use real, edible ingredients.
- Adhere to food safety guidelines (e.g., ensure poultry is fully cooked).
- Avoid repeating any ingredients.

 Return the recipe as JSON using the following structure:

```json
        {
          "title": "Recipe Title",
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
        ```
''';
}
// const String format = '''
// {
//   "title": "Recipe Title",
//   "reference_image": "",
//   "servings": "4",
//   "carbohydrates": "25g",
//   "protein": "30g",
//   "fat": "15g",
//   "calorie": "15kcal",
//   "preparation_time": "20 minutes",
//   "cook_time": "15 minutes",
//   "total_cook_and_preparation_time": "35 minutes",
//   "instructions": [
//     "Instruction 1",
//     "Instruction 2",
//     "Instruction 3"
//   ],
//   "ingredients": [
//     "Ingredient 1",
//     "Ingredient 2",
//     "Ingredient 3"
//   ]
// }

// uniqueId should be unique and of type String.
// title, reference_image, servings, protein,carbohydrates,fat ,calorie ,preparation_time ,cook_time,total_cook_and_preparation_time should be of String type.
// ingredients and instructions should be of type List<String>.
// ''';
