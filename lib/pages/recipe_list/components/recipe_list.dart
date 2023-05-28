import 'package:flutter/material.dart';

import '../../../models/recipe.dart';

import '../../recipe_page.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  
  RecipeList(this.recipes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(recipes[index].title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipes[index]),
              ),
            );
          },
        );
      },
    );
  }
}
