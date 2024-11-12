import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/view/screens/presentation/floating_controlls/toogle_floating_button.dart';

class VisibilityFloatingActionButton extends ConsumerWidget {
  const VisibilityFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool visibility = ref.watch(PresentationProviders.controls.select((controls) => controls.visibility));

    return ToggleFloatingButton(
      icon: Icons.visibility,
      selectedIcon: Icons.visibility_off,
      selected: !visibility,
      onTap: () => ref.read(PresentationProviders.controls.notifier).visibility(!visibility),
    );
  }
}
