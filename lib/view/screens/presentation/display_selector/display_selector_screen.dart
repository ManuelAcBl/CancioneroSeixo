import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/screens/screen_list_notifier.dart';
import 'package:cancionero_seixo/model/providers/screens/screen_providers.dart';
import 'package:cancionero_seixo/view/screens/presentation/display_selector/display_tile.dart';
import 'package:cancionero_seixo/view/widgets/floating_button/custom_extended_floating_button.dart';
import 'package:cancionero_seixo/view/widgets/text/centered_text.dart';
import 'package:cancionero_seixo/view/widgets/text/info_message.dart';

class DisplaySelectorScreen extends ConsumerWidget {
  const DisplaySelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pantallas"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.cast_connected_outlined),
        //     onPressed: ref.read(ScreenProviders.list.notifier).openSettings,
        //   ),
        //   PopupMenuButton(
        //     offset: const Offset(0, 60),
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         onTap: () => {},
        //         child: const Text("Recargar"),
        //       ),
        //     ],
        //   ),
        // ],
      ),
      floatingActionButton: CustomExtendedFloatingButton(
        text: "Configuración",
        icon: Icons.app_settings_alt,
        onTap: ref.read(ScreenProviders.list.notifier).openSettings,
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
      ),
      body: const ScreenList(),
    );
  }
}

class ScreenList extends ConsumerWidget {
  const ScreenList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Display>? displays = ref.watch(ScreenProviders.list);

    if (displays == null) return const CenteredText(text: "Error al obtener las pantallas");
    if (displays.isEmpty) {
      return const InfoMessage(
        title: "No hay pantallas conectadas",
        text: "Añádelas desde la configuracion de tu dispositivo",
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: displays
            .map((display) => WirelessDisplayTile(
                  display: display,
                  selected: display.selected,
                  onTap: (id) => ref.read(ScreenProviders.list.notifier).toggle(id),
                ))
            .toList(),
      ),
    );
  }
}
