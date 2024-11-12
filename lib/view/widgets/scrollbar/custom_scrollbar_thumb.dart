import 'package:flutter/material.dart';

class CustomScrollbarThumb extends StatefulWidget {
  final ScrollController controller;

  const CustomScrollbarThumb({super.key, required this.controller});

  @override
  State<CustomScrollbarThumb> createState() => _CustomScrollbarThumb();
}

class _CustomScrollbarThumb extends State<CustomScrollbarThumb> {
  static const double thumbLength = 75, thumbWidth = 5;

  late final ScrollController controller = widget.controller;
  late double offset;

  @override
  void initState() {
    super.initState();

    offset = controller.offset;

    controller.addListener(() {
      setState(() => offset = controller.offset);
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constrains) {
        double height = constrains.maxHeight;

        double? position = (height - thumbLength) * offset / controller.position.maxScrollExtent;

        if (position.isNaN) return const SizedBox();

        return Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                color: Colors.grey.shade400,
                width: thumbWidth,
                height: height,
              ),
            ),
            Positioned(
              top: position,
              right: 0,
              child: Container(
                color: Theme.of(context).primaryColor,
                width: thumbWidth,
                height: thumbLength,
              ),
            ),
          ],
        );
      });
}
