import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/selector/selection_providers.dart';

class SongSelectionAppBar extends ConsumerWidget {
  final bool? isScreen;
  final bool? presentation;
  final List<Widget> actions;

  const SongSelectionAppBar({super.key, this.isScreen, required this.actions, this.presentation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool empty = ref.watch(SelectionProviders.selection.select((selection) => selection.isEmpty));

    if (empty) return const SizedBox();

    return AppBar(
      leading: IconButton(
        onPressed: () => isScreen == true ? context.pop() : context.push("/search/selection", extra: presentation),
        icon: Icon(
          isScreen == true ? Icons.expand_more : Icons.expand_less,
          color: Colors.white,
        ),
      ),
      title: const _SongSelectionAppBarTitle(),
      actions: actions,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

class _SongSelectionAppBarTitle extends ConsumerWidget {
  const _SongSelectionAppBarTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int length = ref.watch(SelectionProviders.selection.select((selection) => selection.length));

    return Text(
      "$length Canciones",
      style: const TextStyle(color: Colors.white),
    );
  }
}

class BottomSongSelectionAppBar extends ConsumerWidget {
  final Widget action;
  final bool? presentation;

  const BottomSongSelectionAppBar({super.key, required this.action, this.presentation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SongSelectionAppBar(
      presentation: presentation,
      actions: [
        action,
        // IconButton(
        //   onPressed: () => {},
        //   icon: const Icon(
        //     Icons.done_all,
        //     color: Colors.white,
        //   ),
        // ),
        IconButton(
          onPressed: ref.read(SelectionProviders.selection.notifier).clear,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ScreenSongSelectionAppbar extends ConsumerWidget {
  const ScreenSongSelectionAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SongSelectionAppBar(
      isScreen: true,
      actions: [
        TextButton(
          onPressed: () {
            ref.read(SelectionProviders.selection.notifier).clear();
            context.pop();
          },
          child: const Text(
            "Vaciar",
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuButton(
          iconColor: Colors.white,
          offset: const Offset(0, 60),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("Editar"),
              onTap: () => {},
            ),
          ],
        ),
      ],
    );
  }
}
