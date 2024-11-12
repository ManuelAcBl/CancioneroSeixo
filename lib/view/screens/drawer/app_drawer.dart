import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/providers.dart';
import 'package:cancionero_seixo/view/screens/drawer/authentication_header.dart';
import 'package:cancionero_seixo/view/widgets/bottom_sheet_menu.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/bottom_sheet_selector.dart';

class AppDrawer extends ConsumerWidget {
  final StatefulNavigationShell shell;
  static const _staticDestinations = 4;

  const AppDrawer({super.key, required this.shell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Iterable<Folder>? folders = ref.watch(DatabaseProviders.folders.select((folders) => folders?.values));
    int? navigationIndex = ref.watch(Providers.navigationIndex);

    return NavigationDrawer(
      selectedIndex: navigationIndex ?? shell.currentIndex,
      onDestinationSelected: (index) {
        if (index < _staticDestinations) {
          ref.read(Providers.navigationIndex.notifier).state = null;
          shell.goBranch(index);
          Navigator.pop(context);
        } else {
          ref.read(Providers.navigationIndex.notifier).state = index;
          context.goNamed('book', extra: folders!.elementAt(index - _staticDestinations).id);
          Navigator.pop(context);
        }
      },
      children: [
        const AuthenticationHeader(),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text("Inicio"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.cast_outlined),
          selectedIcon: Icon(Icons.cast_connected),
          label: Text("Presentación"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: Text("Administración"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text("Ajustes"),
        ),
        const DrawerFolderSectionTile(text: "Canciones"),
        ...(folders?.map((folder) => NavigationDrawerDestination(
                  icon: Icon(folder.type != FolderType.other ? Icons.folder_outlined : Icons.description_outlined),
                  selectedIcon: Icon(folder.type != FolderType.other ? Icons.folder : Icons.description),
                  label: Text(folder.title),
                )) ??
            [const Text("Cargando...")]),
      ],
    );
  }
}

class DrawerFolderSectionTile extends StatelessWidget {
  final String text;

  const DrawerFolderSectionTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheetElementList(
                      title: "Añadir:",
                      elements: [
                        BottomSheetElement(
                          name: "Nueva Canción",
                          icon: Icons.description,
                          onTap: () async {
                            await context.pushNamed("editor");
                            if (context.mounted) context.pop();
                          },
                        ),
                        BottomSheetElement(
                          name: "Nueva Carpeta",
                          icon: Icons.folder,
                          onTap: () async {
                            await context.pushNamed("folder_editor");
                            if (context.mounted) context.pop();
                          },
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      );
}
