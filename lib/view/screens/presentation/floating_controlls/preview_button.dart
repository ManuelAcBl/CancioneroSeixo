import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/view/screens/presentation/floating_controlls/toogle_floating_button.dart';

class PreviewFloatingActionButton extends ConsumerWidget {
  const PreviewFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preview = ref.watch(PresentationProviders.controls.select((controls) => controls.preview));


    return ToggleFloatingButton(
      icon: Icons.picture_in_picture_outlined,
      selectedIcon: Icons.picture_in_picture,
      selected: preview,
      onTap: () => ref.read(PresentationProviders.controls.notifier).preview(!preview),
    );
  }
}
