import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial"),
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final String name, oldValue, newValue;
  final IconData icon;

  const HistoryTile({super.key, required this.icon, required this.name, required this.oldValue, required this.newValue});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: Icon(icon),
      title: Text(name),
      subtitle: Text.rich(TextSpan(children: [
        TextSpan(text: newValue, style: const TextStyle(color: Colors.lightGreen)),
        const TextSpan(text: "\n"),
        TextSpan(text: oldValue, style: const TextStyle(color: Colors.redAccent)),
      ])),
    );
  }
}

enum HistoryTileType {
  book(Icons.folder),
  song(Icons.queue_music),
  reference(Icons.numbers);

  final IconData icon;

  const HistoryTileType(this.icon);
}
