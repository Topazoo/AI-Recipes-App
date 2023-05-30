import 'package:flutter/material.dart';

import '../../../styles/theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const SectionTitle(this.title, {this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: AppTheme.primaryIconColor),
          if (icon != null)
            const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.accentTextColor, fontFamily: AppTheme.primaryFont),
          ),
        ],
      ),
    );
  }
}
