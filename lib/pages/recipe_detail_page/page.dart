import 'package:flutter/material.dart';

import '../../models/recipe.dart';

import 'components/ingredient_detail.dart';
import 'components/step_detail.dart';
import 'components/section_title.dart';

import '../../styles/theme.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  RecipeDetailPageState createState() => RecipeDetailPageState();
}

class RecipeDetailPageState extends State<RecipeDetailPage> {
  List<bool> _stepChecklist = [];
  List<bool> _ingredientChecklist = [];

  @override
  void initState() {
    super.initState();
    _stepChecklist = List<bool>.filled(widget.recipe.steps.length, false);
    _ingredientChecklist = List<bool>.filled(widget.recipe.ingredients.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SectionTitle('Description:', icon: Icons.description_outlined),
            Text(
              widget.recipe.description,
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
            const Divider(color: Colors.transparent),
            Text(
              'Servings: ${widget.recipe.servings}',
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
            const Divider(),
            const SectionTitle('Time:', icon: Icons.timer_outlined),
            Text(
              'Preparation time: ${widget.recipe.prepTime}',
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
              ),
            const Divider(color: Colors.transparent),
            Text(
              'Cooking time: ${widget.recipe.cookTime}',
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
              ),
            const Divider(),
            const SectionTitle('Notes:', icon: Icons.notes),
            Text(
              widget.recipe.notes,
              style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
            ),
            const Divider(),
            const SectionTitle('Ingredients:', icon: Icons.inventory_2_outlined),
            for (int i = 0; i < widget.recipe.ingredients.length; i++)
              IngredientDetail(
                ingredient: widget.recipe.ingredients[i], 
                isChecked: _ingredientChecklist[i], 
                onChanged: (bool? value) {
                  setState(() {
                    _ingredientChecklist[i] = value!;
                  });
                },
              ),
            const Divider(),
            const SectionTitle('Steps:', icon: Icons.check),
            for (int i = 0; i < widget.recipe.steps.length; i++)
              StepDetail(
                step: widget.recipe.steps[i],
                isChecked: _stepChecklist[i],
                onChanged: (bool? value) {
                  setState(() {
                    _stepChecklist[i] = value!;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
