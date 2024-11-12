import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

class MusicListTile extends StatelessWidget {
  final int index;
  final int? selectedIndex;
  final Function(int index, String videoId) onTap;
  final String name, videoId;
  final String? description;

  const MusicListTile({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.name,
    required this.videoId,
    this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = index == selectedIndex;

    return ListTile(
      leading: const Icon(BootstrapIcons.youtube),
      title: Text(name),
      subtitle: description != null ? Text(description!) : null,
      onTap: () => onTap(index, videoId),
      selected: selected,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      trailing: selected ? const Icon(Icons.check) : null,
    );
  }
}
