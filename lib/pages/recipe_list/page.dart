import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';
import 'dart:convert';

import '../../models/recipe.dart';
import '../../main.dart';

import 'components/add_recipe_dialogue.dart';
import 'components/loading_spinner.dart';
import 'components/recipe_list.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  bool _isLoading = false;
  final Map<String, Recipe> _recipes = {};

  Future<void> _addRecipe(String title) async {
    Wakelock.enable(); // TODO - Change to background task

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          '${env['CONJURE_API_URL']}/recipes?recipe=$title'),
      headers: {
        'accept': 'application/json',
        'CONJURE-API-APPLICATION-ID': env['CONJURE_API_APPLICATION_ID'] ?? '',
        'CONJURE-API-ACCESS-TOKEN': env['CONJURE_API_ACCESS_TOKEN'] ?? '',
      },
    );

    setState(() {
      _isLoading = false;
    });

    Wakelock.disable();

    if (response.statusCode == 200) {
      setState(() {
        var recipe = Recipe.fromJson(jsonDecode(response.body));
        _recipes[recipe.title] = recipe;
      });
    } else {
      throw Exception('Failed to load recipe'); // TODO - Show alert when failure
    }
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
      ),
      body: _isLoading ? const LoadingSpinner() : RecipeList(_recipes.values.toList()),
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