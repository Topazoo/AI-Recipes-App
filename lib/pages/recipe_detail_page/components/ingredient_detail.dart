import 'package:flutter/material.dart';

import '../../../models/ingredient.dart';

class IngredientDetail extends StatelessWidget {
  final bool isChecked;
  final Ingredient ingredient;
  final ValueChanged<bool?> onChanged;

  IngredientDetail({required this.ingredient, required this.isChecked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
          Expanded(
            child: Text(
              '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
            ),
          ),
        ],
      ),
    );
  }
}
