import 'package:flutter/material.dart';
import 'pages/recipe_list/page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const RecipeListPage(title: 'Recipe App'),
    );
  }
}