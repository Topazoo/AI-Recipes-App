import 'ingredient.dart';
import 'recipe_step.dart';

class Recipe {
  String title;
  String description;
  int servings;
  String prepTime;
  String cookTime;
  List<Ingredient> ingredients;
  List<RecipeStep> steps;
  String notes;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.description,
    required this.servings,
    required this.prepTime,
    required this.cookTime,
    required this.ingredients,
    required this.steps,
    required this.notes,
    this.isFavorite = false, // default value
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Parse the JSON into a Recipe
    return Recipe(
      title: json['title'],
      description: json['description'],
      servings: json['servings'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      ingredients: (json['ingredients'] as List).map((i) => Ingredient.fromJson(i)).toList(),
      steps: (json['steps'] as List).map((i) => RecipeStep.fromJson(i)).toList(),
      notes: json['notes'],
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  String get sortableTitle => isFavorite ? 'A$title' : 'B$title';
}
