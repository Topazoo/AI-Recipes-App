class Recipe {
  String title;
  String description;
  int servings;
  String prepTime;
  String cookTime;
  List<Ingredient> ingredients;
  List<Step> steps;
  String notes;

  Recipe({
    required this.title,
    required this.description,
    required this.servings,
    required this.prepTime,
    required this.cookTime,
    required this.ingredients,
    required this.steps,
    required this.notes,
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
      steps: (json['steps'] as List).map((i) => Step.fromJson(i)).toList(),
      notes: json['notes'],
    );
  }
}

class Ingredient {
  String name;
  String quantity;
  String unit;
  String notes;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.notes = '',
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'] ?? '',
      notes: json['notes'] ?? '', // returns an empty string if notes is null
    );
  }
}

class Step {
  int stepNumber;
  String instruction;
  String notes;

  Step({
    required this.stepNumber,
    required this.instruction,
    this.notes = '',
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      stepNumber: json['stepNumber'],
      instruction: json['instruction'],
      notes: json['notes'] ?? '', // returns an empty string if notes is null
    );
  }
}