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
