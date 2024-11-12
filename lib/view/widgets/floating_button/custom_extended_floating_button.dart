import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomExtendedFloatingButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color, backgroundColor;
  final bool? reversed;

  const CustomExtendedFloatingButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.reversed,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      Text(
        text,
        style: TextStyle(color: color),
      ),
      const Gap(10),
      Icon(
        icon,
        color: color,
      ),
    ];

    if (reversed == true) content = content.reversed.toList();

    return FloatingActionButton.extended(
      heroTag: GlobalKey(),
      onPressed: onTap,
      backgroundColor: backgroundColor,
      label: Row(
        children: content,
      ),
    );
  }
}
