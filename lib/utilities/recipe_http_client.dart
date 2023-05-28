import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/recipe.dart';

class RecipeHTTPClient {
    static final env = dotenv.env;
    static final Map<String, String> headers = {
      'accept': 'application/json',
      'CONJURE-API-APPLICATION-ID': env['CONJURE_API_APPLICATION_ID'] ?? '',
      'CONJURE-API-ACCESS-TOKEN': env['CONJURE_API_ACCESS_TOKEN'] ?? '',
    };

    final String recipeTitle;
    const RecipeHTTPClient({required this.recipeTitle});

    // Helper function to check if recipe exists
    Future<bool> recipeExists() async {
      final response = await http.get(
        Uri.parse('${env['CONJURE_API_URL']}/recipes/exists?recipe=$recipeTitle'),
        headers: headers
      );
      return response.statusCode == 200;
    }

    // Helper function to fetch recipe
    Future<Recipe?> fetchRecipe() async {
      final response = await http.get(
        Uri.parse('${env['CONJURE_API_URL']}/recipes?recipe=$recipeTitle'),
        headers: headers
      );
      return response.statusCode == 200 ? Recipe.fromJson(jsonDecode(response.body)) : null;
    }
}