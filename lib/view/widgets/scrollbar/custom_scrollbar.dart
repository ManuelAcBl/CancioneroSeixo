import 'package:flutter/material.dart';
import 'package:cancionero_seixo/view/widgets/scrollbar/custom_scrollbar_thumb.dart';

class CustomScrollbar extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  const CustomScrollbar({super.key, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RawScrollbar(
          minThumbLength: 75,
          thumbVisibility: true,
          thumbColor: Colors.transparent,
          thickness: 35,
          controller: controller,
          interactive: true,
          child: child,
        ),
        CustomScrollbarThumb(
          controller: controller,
        ),
      ],
    );
  }
}
