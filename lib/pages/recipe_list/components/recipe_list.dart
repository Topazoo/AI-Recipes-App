import 'package:flutter/material.dart';

import '../../../models/recipe.dart';

import '../../recipe_detail_page/page.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe recipe) onToggleFavorite;

  const RecipeList(this.recipes, this.onToggleFavorite, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final recipe = recipes[index];
        return ListTile(
          title: Text(recipe.title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(recipe: recipes[index]),
              ),
            );
          },
          // Here we add the favorite button
          trailing: IconButton(
            icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => onToggleFavorite(recipe),
            color: recipe.isFavorite ? Colors.red : null,
          ),
        );
      },
    );
  }
}
