import 'package:flutter/material.dart';

import '../../../models/loading_recipe.dart';

class LoadingRecipeList extends StatelessWidget {
  final List<LoadingRecipe> loadingRecipes;
  final Function(String) retryLoadingRecipe;
  
  LoadingRecipeList(this.loadingRecipes, {Key? key, required this.retryLoadingRecipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loadingRecipes.length,
      itemBuilder: (context, index) {
        final loadingRecipe = loadingRecipes[index];
        return ListTile(
          title: Text(loadingRecipe.title),
          subtitle: loadingRecipe.status == LoadingStatus.loading
              ? Text('Loading... (this can take up to 5 minutes)')
              : Text('Failed to load (tap to retry)'),
                          onTap: loadingRecipe.status == LoadingStatus.failure
                  ? () {
                      // Retry loading the recipe.
                      retryLoadingRecipe(loadingRecipe.title);
                    }
                  : null,
          trailing: Icon(loadingRecipe.status == LoadingStatus.loading
              ? Icons.hourglass_empty
              : Icons.error_outline,
              color: loadingRecipe.status == LoadingStatus.loading
              ? Colors.blue
              : Colors.red),
        );
      },
    );
  }
}
