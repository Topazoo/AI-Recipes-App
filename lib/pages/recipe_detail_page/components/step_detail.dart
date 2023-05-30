import 'package:flutter/material.dart';

import '../../../models/recipe_step.dart';

import '../../../utilities/timer.dart';
import '../../../utilities/time_parser/time_parser.dart';
import '../../../styles/theme.dart';

class StepDetail extends StatelessWidget {
  final bool isChecked;
  final RecipeStep step;
  final ValueChanged<bool?> onChanged;

  const StepDetail({Key? key, required this.step, required this.isChecked, required this.onChanged}) : super(key: key);

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
                activeColor: AppTheme.primaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${step.stepNumber}:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentTextColor, fontFamily: AppTheme.primaryFont),
                    ),
                    Text(
                      step.instruction,
                      style: TextStyle(color: AppTheme.darkTextColor, fontFamily: AppTheme.primaryFont),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (TimeParser.extractDuration(step.instruction) > 0) 
            TimerWidget(duration: TimeParser.extractDuration(step.instruction)),
        ],
      ),
    );
  }
}
