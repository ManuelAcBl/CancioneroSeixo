import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FolderRemoveAlert extends StatelessWidget {
  final String folderId;

  const FolderRemoveAlert({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete),
      title: const Text("¿Eliminar Carpeta?"),
      content: const Text(
        "Esta operación es irreversible.\nLas canciones contenidas NO serán borradas",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: const Text("Eliminar"),
        ),
      ],
    );
  }
}
