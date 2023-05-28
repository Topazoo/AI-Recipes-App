import 'package:flutter/material.dart';

class AddRecipeDialog extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String) onRecipeAdded;

  AddRecipeDialog(this.textEditingController, this.onRecipeAdded);

  @override
  Widget build(BuildContext context) {
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
            onRecipeAdded(recipeName);
          },
        ),
      ],
    );
  }
}
