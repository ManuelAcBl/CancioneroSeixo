import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/view/widgets/floating_button/custom_extended_floating_button.dart';

class SearchFloatingActionButton extends ConsumerWidget {
  const SearchFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preview = ref.watch(PresentationProviders.controls.select((controls) => controls.preview));

    if (preview) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.manage_search,
          color: Colors.white,
        ),
        onPressed: () => context.pushNamed("search", extra: true),
      );
    }

    return CustomExtendedFloatingButton(
      color: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      text: "Añadir",
      icon: Icons.manage_search,
      onTap: () => context.pushNamed("search", extra: true),
    );
  }
}
