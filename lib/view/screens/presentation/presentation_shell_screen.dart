import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/screens/screen_providers.dart';
import 'package:cancionero_seixo/view/screens/presentation/floating_controlls/presentation_controlls.dart';
import 'package:cancionero_seixo/view/screens/presentation/slide_list/presentation_slide_list.dart';
import 'package:cancionero_seixo/view/widgets/screens/shell_screen.dart';

class PresentationShellScreen extends ConsumerStatefulWidget {
  const PresentationShellScreen({super.key});

  @override
  ConsumerState<PresentationShellScreen> createState() => _PresentationShellScreenState();
}

class _PresentationShellScreenState extends ConsumerState<PresentationShellScreen> with ShellScreen {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading(context),
        title: const Text("Presentación"),
        actions: [
          const CastIconButton(),
          PopupMenuButton(
            offset: const Offset(0, 60),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: ref.read(PresentationProviders.songs.notifier).clear,
                child: const Text("Vaciar"),
              ),
              PopupMenuItem(
                onTap: () {},
                child: const Text("Configuración"),
              ),
            ],
          )
        ],
      ),
      body: const PresentationSlideList(),
      floatingActionButton: const PresentationControls(),
    );
  }
}

class CastIconButton extends ConsumerWidget {
  const CastIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int? length = ref.watch(ScreenProviders.list.select((displays) => displays?.where((display) => display.selected).length));

    return IconButton(
      icon: Badge.count(
        backgroundColor: Theme.of(context).primaryColor,
        count: length ?? 0,
        child: const Icon(Icons.cast_connected),
      ),
      onPressed: () => context.pushNamed('cast_settings'),
    );
  }
}
