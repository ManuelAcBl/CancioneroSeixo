import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/view/screens/settings/settings_section_scaffold.dart';
import 'package:cancionero_seixo/view/widgets/screens/shell_screen.dart';

class SettingsShellScreen extends StatelessWidget with ShellScreen {
  const SettingsShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajustes"),
        leading: leading(context),
      ),
      body: Column(
        children: [
          SettingsSectionElement(
            title: "Personalización",
            subtitle: "Colores, tamaño de letra...",
            icon: Icons.color_lens,
            onTap: () => context.push("/settings/personalization"),
          ),
          SettingsSectionElement(
            title: "Presentación",
            subtitle: "Ajustes de la presentación",
            icon: Icons.cast_connected,
            onTap: () => context.push("/settings/presentation"),
          ),
          SettingsSectionElement(
            title: "Información",
            subtitle: "Información de la aplicación",
            icon: Icons.info,
            onTap: () => context.push("/settings/info"),
          ),
        ],
      ),
    );
  }
}

// class SettingsShellScreen extends ConsumerWidget with ShellScreen {
//   final ConfigurationSection? section;
//
//   const SettingsShellScreen({super.key, this.section});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Iterable<ConfigurationItem>? items = section?.items ?? _defaultItems(ref);
//
//     bool main = section == null;
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: main ? leading(context) : IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
//         title: Text(main ? "Ajustes" : section!.title),
//       ),
//       body: ListView.builder(
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             ConfigurationItem item = items.elementAt(index);
//             ConfigurationSection? section = item is ConfigurationSection ? item : null;
//
//             return ListTile(
//               title: Text(item.title),
//               subtitle: Text(item.description, style: const TextStyle(fontStyle: FontStyle.italic)),
//               leading: Icon(item.icon),
//               onTap: () => item.onTap(context, section),
//             );
//           }),
//     );
//   }
//
//   Iterable<ConfigurationItem> _defaultItems(WidgetRef ref) => [
//         // ConfigurationSection(
//         //   icon: Icons.person,
//         //   title: "Cuenta",
//         //   description: "Gestiona la información de tu cuenta",
//         //   items: [
//         //     ConfigurationItem(
//         //       icon: Icons.person,
//         //       title: "Nombre de usuario",
//         //       description: "Manuel Acuña",
//         //       onTap: (context, _) => {},
//         //     ),
//         //     ConfigurationItem(
//         //       icon: Icons.person,
//         //       title: "Correo electrónico",
//         //       description: "manuelacbl@gmail.com",
//         //       onTap: (context, _) => {},
//         //     )
//         //   ],
//         // ),
//         ConfigurationSection(
//           icon: Icons.style,
//           title: "Personalización",
//           description: "Modifica tamaño de letra, colores y otros ajustes",
//           items: [
//             ConfigurationItem(
//               icon: Icons.color_lens,
//               title: "Color",
//               description: switch (ref.watch(Providers.settings.select((settings) => settings?.personalization.themeMode))) {
//                 ThemeMode.system => "Sistema",
//                 ThemeMode.light => "Modo Claro",
//                 ThemeMode.dark => "Modo Oscuro",
//                 null => "Cargando...",
//               },
//               onTap: (context, _) async {
//                 ThemeMode? themeMode = await showModalBottomSheet(
//                   context: context,
//                   builder: (context) => BottomSheetSelector(
//                     title: "Color",
//                     options: [
//                       BottomSheetSelectorOption(
//                         icon: Icons.wallpaper,
//                         text: "Modo Oscuro",
//                         onTap: () => context.pop(ThemeMode.dark),
//                       ),
//                       BottomSheetSelectorOption(
//                         icon: Icons.image,
//                         text: "Modo Claro",
//                         onTap: () => context.pop(ThemeMode.light),
//                       ),
//                     ],
//                   ),
//                 );
//
//                 if(themeMode == null) return;
//
//                 Settings? settings = ref.read(Providers.settings);
//
//                 ref.read(Providers.settings.notifier).set(
//                       settings!.copyWith(
//                         personalization: settings.personalization.copyWith(
//                           themeMode: themeMode,
//                         ),
//                       ),
//                     );
//               },
//             ),
//           ],
//         ),
//         ConfigurationSection(
//           icon: Icons.cast,
//           title: "Presentación",
//           description: "Modifica la función de presentación",
//           items: [
//             ConfigurationItem(
//               icon: Icons.image,
//               title: "Fondo de pantalla",
//               description: "Por defecto",
//               onTap: (context, _) async {
//                 String path = await showModalBottomSheet(
//                   context: context,
//                   builder: (context) => BottomSheetSelector(
//                     title: "Fondo de Pantalla",
//                     options: [
//                       BottomSheetSelectorOption(
//                         icon: Icons.wallpaper,
//                         text: "Imagen por defecto",
//                         onTap: () => context.pop("url"),
//                       ),
//                       BottomSheetSelectorOption(
//                         icon: Icons.image,
//                         text: "Importar de galería",
//                         onTap: () => context.pop("url"),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             ConfigurationItem(
//               icon: Icons.aspect_ratio,
//               title: "Resolución Previsualización",
//               description: "Por defecto",
//               onTap: (context, _) async {
//                 double aspectRatio = await showModalBottomSheet(
//                   context: context,
//                   builder: (context) => BottomSheetSelector(
//                     title: "Resolución",
//                     options: [
//                       BottomSheetSelectorOption(
//                         icon: Icons.aspect_ratio,
//                         text: "4/3",
//                         onTap: () => context.pop(4 / 3),
//                       ),
//                       BottomSheetSelectorOption(
//                         icon: Icons.aspect_ratio,
//                         text: "16/9",
//                         onTap: () => context.pop(16 / 9),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ];
// }
//
// class ConfigurationItem {
//   final String title, description;
//   final IconData icon;
//   final Function(BuildContext context, ConfigurationSection? section) onTap;
//
//   ConfigurationItem({required this.icon, required this.title, required this.description, required this.onTap});
// }
//
// class ConfigurationSection extends ConfigurationItem {
//   final Iterable<ConfigurationItem> items;
//
//   ConfigurationSection({required super.icon, required super.title, required super.description, required this.items})
//       : super(onTap: (context, section) => context.push('/settings/page', extra: section));
// }
