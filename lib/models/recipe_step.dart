class RecipeStep {
  int stepNumber;
  String instruction;
  String notes;

  RecipeStep({
    required this.stepNumber,
    required this.instruction,
    this.notes = '',
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      stepNumber: json['stepNumber'],
      instruction: json['instruction'],
      notes: json['notes'] ?? '', // returns an empty string if notes is null
    );
  }
}