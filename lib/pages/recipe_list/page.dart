import 'package:flutter/material.dart';
import 'dart:async';

import '../../utilities/recipe_http_client.dart';

import '../../models/recipe.dart';
import '../../models/loading_recipe.dart';

import 'components/add_recipe_dialogue.dart';
import 'components/loading_recipe_list.dart';
import 'components/recipe_list.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> with SingleTickerProviderStateMixin {
  final Map<String, Recipe> _recipes = {};
  final List<LoadingRecipe> _loadingRecipes = [];

  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _addRecipe(String title) async {
    RecipeHTTPClient httpClient = RecipeHTTPClient(recipeTitle: title);

    LoadingRecipe recipe = _loadingRecipes.firstWhere((r) => r.title == title, orElse: () => LoadingRecipe(title: title, startTime: DateTime.now()));
    recipe.status = LoadingStatus.loading;

    // Add to loading recipes
    setState(() {
      _loadingRecipes.remove(recipe);
      _loadingRecipes.add(recipe);
    });

    // Try fetching the recipe immediately
    httpClient.fetchRecipe();
    if (await httpClient.recipeExists()) {
      final recipe = await httpClient.fetchRecipe();
      if (recipe != null) {
        setState(() {
          _loadingRecipes.removeWhere((r) => r.title == title);
          _recipes[recipe.title] = recipe;
        });
      }
      return;
    }

    // Retry every 20 seconds for up to 5 minutes
    int totalSeconds = 300;
    int delaySeconds = 20; 
    for (int i = 0; i < totalSeconds/delaySeconds; i++) {
      await Future.delayed(Duration(seconds: delaySeconds));
      if (await httpClient.recipeExists()) {
        final recipe = await httpClient.fetchRecipe();
        if (recipe != null) {
          setState(() {
            _loadingRecipes.removeWhere((r) => r.title == title);
            _recipes[recipe.title] = recipe;
          });
        }
        return;
      }
    }

    // If the recipe still doesn't exist after 5 minutes, mark it as failed
    setState(() {
      _loadingRecipes.removeWhere((r) => r.title == title);
      _loadingRecipes.add(LoadingRecipe(title: title, startTime: DateTime.now(), status: LoadingStatus.failure));
    });
  }

  void _showAddRecipeDialog(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddRecipeDialog(textEditingController, _addRecipe);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.check_box), text: 'Recipes'),
            Tab(icon: Icon(Icons.hourglass_empty), text: 'Loading Recipes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RecipeList(_recipes.values.toList()),
          LoadingRecipeList(_loadingRecipes, retryLoadingRecipe: _addRecipe),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRecipeDialog(context);
        },
        tooltip: 'Add Recipe',
        child: const Icon(Icons.add),
      ),
    );
  }
}