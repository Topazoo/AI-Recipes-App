import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'dart:async';
import 'timer.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  RecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<bool> _stepChecklist = [];
  List<bool> _ingredientChecklist = [];

  Timer? _timer;
  int _currentCountdown = 0;

  @override
  void initState() {
    super.initState();
    _stepChecklist = List<bool>.filled(widget.recipe.steps.length, false);
    _ingredientChecklist = List<bool>.filled(widget.recipe.ingredients.length, false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer(int durationInSeconds, int index) {
    _currentCountdown = durationInSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentCountdown < 1) {
        timer.cancel();
        FlutterRingtonePlayer.playAlarm();
        setState(() {
          _stepChecklist[index] = false;
        });
      } else {
        setState(() {
          _currentCountdown -= 1;
        });
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  int extractDuration(String instruction) {
    final RegExp regExp = RegExp(r'\bfor\b ([0-9]+(-[0-9]+)?) (seconds|minutes|hours|days|weeks|months|years)', caseSensitive: false);
    final match = regExp.firstMatch(instruction);
    if (match != null && match.groupCount > 1) {
      var duration = 0;
      if (match.group(1)!.contains('-')) {
        List<String> range = match.group(1)!.split('-');
        // In the case of "3-4 minutes", we use the maximum value (4 in this case)
        duration = int.tryParse(range[1]) ?? 0;
      } else {
        duration = int.tryParse(match.group(1)!) ?? 0;
      }

      String unit = match.group(3)!;
      switch (unit) {
        case 'seconds':
          // Already in seconds
          break;
        case 'minutes':
          duration *= 60;
          break;
        case 'hours':
          duration *= 60 * 60;
          break;
        case 'days':
          duration *= 60 * 60 * 24;
          break;
        case 'weeks':
          duration *= 60 * 60 * 24 * 7;
          break;
        case 'months':
          duration *= 60 * 60 * 24 * 30; // Assuming 30 days in a month
          break;
        case 'years':
          duration *= 60 * 60 * 24 * 365; // Non-leap year
          break;
        default:
          return 0; // Unrecognizable unit, return 0
      }
      return duration;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            sectionTitle('Description:'),
            Text(widget.recipe.description),
            Divider(),
            Text('Servings: ${widget.recipe.servings}'),
            Divider(),
            Text('Preparation time: ${widget.recipe.prepTime}'),
            Divider(),
            Text('Cooking time: ${widget.recipe.cookTime}'),
            Divider(),
            sectionTitle('Notes:'),
            Text(widget.recipe.notes ?? "No notes available"),
            Divider(),
            sectionTitle('Ingredients:'),
            for (int i = 0; i < widget.recipe.ingredients.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _ingredientChecklist[i],
                      onChanged: (bool? value) {
                        setState(() {
                          _ingredientChecklist[i] = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        '${widget.recipe.ingredients[i].quantity} ${widget.recipe.ingredients[i].unit} ${widget.recipe.ingredients[i].name}',
                      ),
                    ),
                  ],
                ),
              ),
            Divider(),
            sectionTitle('Steps:'),
            for (int i = 0; i < widget.recipe.steps.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _stepChecklist[i],
                          onChanged: (bool? value) {
                            setState(() {
                              _stepChecklist[i] = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Step ${widget.recipe.steps[i].stepNumber}:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(widget.recipe.steps[i].instruction),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (extractDuration(widget.recipe.steps[i].instruction) > 0) 
                      TimerWidget(duration: extractDuration(widget.recipe.steps[i].instruction)!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
