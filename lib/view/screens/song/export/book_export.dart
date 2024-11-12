import 'package:flutter/material.dart';

const double a4VerticalAspectRatio = 1 / 1.414;
const double a4HorizontalAspectRatio = 1 / 1.414;

class BookExport extends StatelessWidget {
  final Orientation orientation;

  const BookExport({super.key, required this.orientation});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: orientation == Orientation.vertical ? a4VerticalAspectRatio : a4HorizontalAspectRatio,
      child: ListView(
        children: [],
      ),
    );
  }
}

enum Orientation { vertical, horizontal }
