import 'package:flutter/material.dart';

import '../../../models/ingredient.dart';
import '../../../styles/theme.dart';

class IngredientDetail extends StatelessWidget {
  final bool isChecked;
  final Ingredient ingredient;
  final ValueChanged<bool?> onChanged;

  const IngredientDetail({Key? key, required this.ingredient, required this.isChecked, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
          Expanded(
            child: Text(
              '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
          ),
        ],
      ),
    );
  }
}
