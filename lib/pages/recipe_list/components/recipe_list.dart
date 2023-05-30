import 'package:flutter/material.dart';

import '../../../models/recipe.dart';

import '../../recipe_detail_page/page.dart';

import '../../../styles/theme.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe recipe) onToggleFavorite;

  const RecipeList(this.recipes, this.onToggleFavorite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: recipes.length,
      separatorBuilder: (context, index) => Divider(
        color: AppTheme.darkTextColor, // This will create a line between each recipe
      ),
      itemBuilder: (BuildContext context, int index) {
        final recipe = recipes[index];
        return ListTile(
          leading: Icon(
            Icons.article_rounded, // Using article icon for recipe
            color: AppTheme.primaryIconColor,
          ),
          title: Text(
            recipe.title,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              color: AppTheme.darkTextColor,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(recipe: recipes[index]),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => onToggleFavorite(recipe),
            color: recipe.isFavorite ? Colors.red : AppTheme.secondaryIconColor,
          ),
        );
      },
    );
  }
}
