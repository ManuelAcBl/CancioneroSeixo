import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  final String text;

  const CenteredText({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      );
}
