import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final List<PopupMenuEntry<Object?>> Function(BuildContext) itemBuilder;

  const CustomPopupMenuButton({super.key, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 60),
      itemBuilder: itemBuilder,
    );
  }
}
