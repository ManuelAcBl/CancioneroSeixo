import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/view/screens/presentation/floating_controlls/presentation_preview.dart';
import 'package:cancionero_seixo/view/screens/presentation/floating_controlls/preview_button.dart';
import 'package:cancionero_seixo/view/screens/presentation/floating_controlls/search_button.dart';
import 'package:cancionero_seixo/view/screens/presentation/floating_controlls/visibility_button.dart';

class PresentationControls extends ConsumerWidget {
  const PresentationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(child: PresentationPreview()),
        const Gap(15),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const PreviewFloatingActionButton(),
            const Gap(16),
            const VisibilityFloatingActionButton(),
            const Gap(16),
            FloatingActionButton.small(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              heroTag: null,
              onPressed: () => {
                if(!ref.read(PresentationProviders.index.notifier).up()) HapticFeedback.vibrate()
              },
              child: const Icon(Icons.arrow_upward),
            ),
            const Gap(16),
            FloatingActionButton.small(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              heroTag: null,
              onPressed: () => {
                if(!ref.read(PresentationProviders.index.notifier).down()) HapticFeedback.vibrate()
              },
              child: const Icon(Icons.arrow_downward),
            ),
            const Gap(24),
            const SearchFloatingActionButton()
          ],
        ),
      ],
    );
  }
}
