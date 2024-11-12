import 'package:flutter/material.dart';
import 'package:cancionero_seixo/model/providers/screens/screen_list_notifier.dart';

class DisplayTile extends StatelessWidget {
  final Display display;
  final bool selected;
  final Function(int id) onTap;
  final IconData icon, selectedIcon;

  const DisplayTile({
    super.key,
    required this.display,
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) => ListTile(
      selected: selected,
      onTap: () => onTap(display.id),
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      trailing: selected ? const Icon(Icons.check) : null,
      leading: Icon(selected ? selectedIcon : icon),
      subtitle: Text(
        'Pantalla inalámbrica\n${display.width}x${display.height} ${display.refreshRate}Hz',
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      title: Text(
        display.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
}

// class WindowDisplayTile extends StatelessWidget {
//   final Display display;
//   final bool selected;
//   final Function(int id) onTap;
//
//   const WindowDisplayTile({super.key, required this.display, required this.selected, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => DisplayTile(
//         display: display,
//         selected: selected,
//         onTap: onTap,
//         iconData: Icons.desktop_windows_outlined,
//       );
// }

class WirelessDisplayTile extends StatelessWidget {
  final Display display;
  final bool selected;
  final Function(int id) onTap;

  const WirelessDisplayTile({super.key, required this.display, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => DisplayTile(
        display: display,
        selected: selected,
        onTap: onTap,
        icon: Icons.cast_connected_outlined,
        selectedIcon: Icons.cast_connected,
      );
}

// class DisplayTile extends StatelessWidget {
//   final Display display;
//   final bool selected;
//   final Function(int id) onTap;
//
//   const DisplayTile({super.key, required this.display, required this.onTap, required this.selected});
//
//   @override
//   Widget build(BuildContext context) => ListTile(
//       selected: selected,
//       onTap: () => onTap(display.displayId!),
//       trailing: selected ? const Icon(Icons.check) : null,
//       leading: const Icon(Icons.screenshot_monitor),
//       subtitle: Text('Id: ${display.displayId} | Flag: ${display.flag} | Rotation: ${display.rotation}'),
//       title: Text('${display.name}'));
// }
