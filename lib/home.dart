import 'package:flutter/material.dart';
import 'recipe.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';
import 'dart:convert';
import 'recipe_page.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  Map<String, Recipe> _recipes = {};


  Future<void> _addRecipe(String title) async {
    Wakelock.enable();
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
      throw Exception('Failed to load recipe');
    }
  }

void _showAddRecipeDialog(BuildContext context) {
  final TextEditingController textEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add a Recipe'),
        content: TextField(
          controller: textEditingController,
          decoration: InputDecoration(hintText: "Enter recipe name"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('ADD'),
            onPressed: () {
              String recipeName = textEditingController.text;
              Navigator.pop(context);
              _addRecipe(recipeName);
            },
          ),
        ],
      );
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Generating new recipe - this can take up to 2 minutes!"),
                ],
              ),
            ) : 
          ListView.builder(
            itemCount: _recipes.values.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_recipes.values.toList()[index].title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipePage(recipe: _recipes.values.toList()[index]),
                    ),
                  );
                },
              );
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