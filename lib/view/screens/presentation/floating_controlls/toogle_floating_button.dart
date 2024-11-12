import 'package:flutter/material.dart';

class ToggleFloatingButton extends StatelessWidget {
  final IconData icon, selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  const ToggleFloatingButton({super.key, required this.icon, required this.selectedIcon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: null,
      onPressed: onTap,
      backgroundColor: selected ? Theme.of(context).primaryColor : null,
      child: Icon(
        selected ? selectedIcon : icon,
        color: selected ? Colors.white : null,
      ),
    );
  }
}
