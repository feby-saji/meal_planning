import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:meal_planning/models/hive_models/recipe_model.dart';

class RecipeRepository {
  Future<dynamic> getRecipeContent(String url) async {
      Map<String, dynamic> map = {};
      RecipeModel? recipe;

      try {
        http.Response response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var document = parser.parse(response.body);
          // Extract recipe data
          var scriptTags =
              document.querySelectorAll('script[type="application/ld+json"]');
          if (scriptTags.isNotEmpty) {
            var jsonText = scriptTags.first.text;
            var decJson = json.decode(jsonText);
            // check if decJson in valid
            if (decJson != null && decJson.isNotEmpty) {
              map = decJson[0];
              // Create RecipeModel
              recipe = RecipeModel.fromMap(map);
            } else {
              print('///// fetch failed try recipes from another websites');
              return 'try recipes from another websites';
            }
          } else {
            return 'Recipe data not found in the HTML';
          }
        } else if (response.statusCode == 400) {
          return 'Bad request: ${response.statusCode}';
        } else if (response.statusCode == 404) {
          return 'Not found: ${response.statusCode}';
        } else if (response.statusCode == 500) {
          return 'Server error: ${response.statusCode}';
        } else {
          return ' Unexpected error occured : ${response.statusCode}';
        }
      } catch (e) {
        // not working as expected
        return _handleError(e);
      }
      return recipe;

  }
}

String _handleError(dynamic error) {
  if (error is TypeError) {
    return 'Try recipes from different website';
  } else if (error is http.ClientException) {
    return 'Client error: ${error.message}';
  } else if (error is TimeoutException) {
    return 'Request timeout: The server took too long to respond.';
  } else if (error is SocketException) {
    return 'Network error: Please check your internet connection.';
  } else {
    print('An unexpected error occurred: ${error.toString()}');
    return 'Try a different recipe';
  }
}
