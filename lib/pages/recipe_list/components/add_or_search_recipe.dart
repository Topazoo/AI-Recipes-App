import 'package:flutter/material.dart';

import '../../../styles/theme.dart';

class AddOrSearchRecipe extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onAddRecipe;

  const AddOrSearchRecipe({Key? key, required this.searchController, required this.onAddRecipe}) : super(key: key);

  @override
  _AddOrSearchRecipeState createState() => _AddOrSearchRecipeState();
}

class _AddOrSearchRecipeState extends State<AddOrSearchRecipe> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:25.0, horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.searchController,
              onChanged: (text) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Enter a recipe",
                fillColor: AppTheme.tabColor,
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.primaryIconColor,
                ),
                hintStyle: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  color: AppTheme.accentTextColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // Set border radius to be less rounded
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor, // Adds a thin border to the search bar
                  ),
                ),
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  widget.onAddRecipe(text);
                  widget.searchController.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: AppTheme.primaryIconColor,
            ),
            onPressed: widget.searchController.text.isNotEmpty
                ? () {
                    widget.onAddRecipe(widget.searchController.text);
                    widget.searchController.clear();
                  }
                : null, // disabled when there's no text
          ),
        ],
      ),
    );
  }
}
