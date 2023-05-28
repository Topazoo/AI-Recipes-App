import 'package:flutter/material.dart';

import '../../../models/recipe_step.dart';

import '../../../utilities/timer.dart';

class StepDetail extends StatelessWidget {
  final bool isChecked;
  final RecipeStep step;
  final ValueChanged<bool?> onChanged;

  const StepDetail({super.key, required this.step, required this.isChecked, required this.onChanged});

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: onChanged,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${step.stepNumber}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(step.instruction),
                  ],
                ),
              ),
            ],
          ),
          if (extractDuration(step.instruction) > 0) 
            TimerWidget(duration: extractDuration(step.instruction)),
        ],
      ),
    );
  }
}
