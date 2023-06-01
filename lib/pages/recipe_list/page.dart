import 'package:flutter/material.dart';
import 'dart:async';

import '../../utilities/recipe_http_client.dart';

import '../../models/recipe.dart';
import '../../models/loading_recipe.dart';

import 'components/add_or_search_recipe.dart';
import 'components/loading_recipe_list.dart';
import 'components/recipe_list.dart';

import '../../styles/theme.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> with SingleTickerProviderStateMixin {
  Map<String, Recipe> _recipes = {};
  final Map<String, Recipe> _favoriteRecipes = {};
  final List<LoadingRecipe> _loadingRecipes = [];

  late TabController _tabController;

  // Used for the search bar
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });

    // Add defaults
    if (_recipes.isEmpty) {
      _addRecipe("steak");
      _addRecipe("vegan chorizo");
      _addRecipe("apple pie");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(Recipe recipe) {
      setState(() {
          recipe.isFavorite = !recipe.isFavorite;
          if (recipe.isFavorite) {
              _favoriteRecipes[recipe.title] = recipe;
          } else {
              _favoriteRecipes.remove(recipe.title);
          }
      });
      _sortRecipes();
  }

  void _sortRecipes() {
      List<Recipe> sortedRecipes = _recipes.values.toList();
      sortedRecipes.sort((a, b) {
          if (a.isFavorite == b.isFavorite) {
              return a.title.compareTo(b.title);
          } else {
              return a.isFavorite ? -1 : 1;
          }
      });
      setState(() {
          _recipes = sortedRecipes.asMap().map((index, value) => MapEntry(value.title, value));
      });
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

    // Switch to the "Loading" tab
    _tabController.animateTo(1);

    // Try fetching the recipe immediately
    httpClient.fetchRecipe();
    if (await httpClient.recipeExists()) {
      final recipe = await httpClient.fetchRecipe();
      if (recipe != null) {
        setState(() {
            _loadingRecipes.removeWhere((r) => r.title == title);
            _recipes[recipe.title] = recipe;
        });
        _sortRecipes();

        // Switch to the "Recipes" tab
        _tabController.animateTo(0);
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
          _sortRecipes();

          // Switch to the "Recipes" tab
          _tabController.animateTo(0);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor, // Adding primary color as AppBar background
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: AppTheme.primaryFont,
            color: AppTheme.tabColor, // Set the AppBar title color to tab color
          )
        ),
        elevation: 5, 
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.tabColor, 
          labelColor: AppTheme.tabColor,
          unselectedLabelColor: AppTheme.unselectedTabColor,
          tabs: const [
            Tab(icon: Icon(Icons.check_box), text: 'Recipes'),
            Tab(icon: Icon(Icons.hourglass_empty), text: 'Loading Recipes'),
          ],
        ),
      ),
      body: Container(
        color: AppTheme.lightBackgroundColor,
        child: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                AddOrSearchRecipe(searchController: _searchController, onAddRecipe: _addRecipe),
                Flexible(
                  child: RecipeList(
                    _searchTerm == ""
                        ? _recipes.values.toList()
                        : _recipes.values
                            .where((recipe) =>
                                recipe.title.toLowerCase().contains(_searchTerm.toLowerCase()))
                            .toList(),
                    _toggleFavorite,
                  ),
                ),
              ],
            ),
            LoadingRecipeList(_loadingRecipes, retryLoadingRecipe: _addRecipe),
          ],
        ),
      )
    );
  }
}