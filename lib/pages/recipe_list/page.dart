import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

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
  final _store = stringMapStoreFactory.store('recipes');
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = directory.path + 'recipes.db';
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<List<Recipe>> _fetchRecipes() async {
    final records = await _store.find(_database!);
    return records.map((snapshot) {
      var recipe = Recipe.fromJson(snapshot.value);
      return recipe;
    }).toList();
  }

  Future<void> _addRecipe(String title) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('${env['CONJURE_API_URL']}/recipes?recipe=$title'),
      headers: {
        'accept': 'application/json',
        'CONJURE-API-APPLICATION-ID': env['CONJURE_API_APPLICATION_ID'] ?? '',
        'CONJURE-API-ACCESS-TOKEN': env['CONJURE_API_ACCESS_TOKEN'] ?? '',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var recipe = Recipe.fromJson(body);
      await _store.record(recipe.title).put(_database!, body);
    } else {
      throw Exception('Failed to load recipe'); // TODO - Show alert when failure
    }

    setState(() {
      _isLoading = false;
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
      ),
      body: _isLoading
          ? const LoadingSpinner()
          : FutureBuilder(
              future: _database == null ? null : _store.find(_database!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<RecordSnapshot<String, Map<String, dynamic>>>>
                      snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  var recipes = snapshot.data!.map((snapshot) {
                    var recipe = Recipe.fromJson(snapshot.value);
                    return recipe;
                  }).toList();
                  return RecipeList(recipes);
                } else {
                  return const SizedBox();
                }
              },
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
