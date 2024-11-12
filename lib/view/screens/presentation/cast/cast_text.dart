import 'package:flutter/material.dart';
import 'package:cancionero_seixo/view/widgets/text/stroke_text.dart';

class CastText extends StatelessWidget {
  final Text text;
  final double? strokeWidth;

  const CastText({super.key, required this.text, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    if (text.data?.isEmpty == true) return const SizedBox();

    return StrokeText(
      stroke: Stroke(
        color: Colors.black,
        width: strokeWidth ?? 3,
      ),
      text: text,
    );
  }
}
