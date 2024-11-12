import 'package:flutter/material.dart';

class AppBarTitleWithSubtitle extends StatelessWidget {
  final Color? textColor;
  final String title, subtitle;

  const AppBarTitleWithSubtitle({super.key, required this.title, required this.subtitle, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            title,
            style: TextStyle(fontSize: 19, color: textColor),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 17, color: textColor ?? Colors.grey, fontStyle: FontStyle.italic),
        )
      ],
    );
  }
}
