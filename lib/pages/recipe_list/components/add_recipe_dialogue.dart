import 'package:flutter/material.dart';

class AddRecipeDialog extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String) onRecipeAdded;

  const AddRecipeDialog(this.textEditingController, this.onRecipeAdded, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a Recipe'),
      content: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(hintText: "Enter recipe name"),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('ADD'),
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
