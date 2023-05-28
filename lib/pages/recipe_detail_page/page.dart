import 'package:flutter/material.dart';

import '../../models/recipe.dart';

import 'components/ingredient_detail.dart';
import 'components/step_detail.dart';
import 'components/section_title.dart';

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
            const SectionTitle('Description:'),
            Text(widget.recipe.description),
            const Divider(),
            Text('Servings: ${widget.recipe.servings}'),
            const Divider(),
            Text('Preparation time: ${widget.recipe.prepTime}'),
            const Divider(),
            Text('Cooking time: ${widget.recipe.cookTime}'),
            const Divider(),
            const SectionTitle('Notes:'),
            Text(widget.recipe.notes),
            const Divider(),
            const SectionTitle('Ingredients:'),
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
            const SectionTitle('Steps:'),
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
