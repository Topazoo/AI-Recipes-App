import 'package:flutter/material.dart';
import 'pages/recipe_list/page.dart';

import 'styles/theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Recipes',
      theme: ThemeData(
        primarySwatch: AppTheme.primarySwatch,
      ),
      home: const RecipeListPage(title: 'AI Recipes'),
    );
  }
}