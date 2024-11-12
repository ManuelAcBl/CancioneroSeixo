import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/view/widgets/text/centered_text.dart';

class AdministrationScreen extends ConsumerWidget {
  const AdministrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu)),
        title: const Text("Administración"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Editores"),
            leading: const Icon(Icons.person),
            subtitle: const Text("Comprueba, añade y elimina editores."),
            onTap: () => context.pushNamed('editors'),
          ),
          ListTile(
            title: const Text("Historial"),
            leading: const Icon(Icons.edit_calendar),
            subtitle: const Text("Comprueba las últimas modificaciones."),
            onTap: () => context.pushNamed('history'),
          ),
        ],
      ),
    );
  }
}
