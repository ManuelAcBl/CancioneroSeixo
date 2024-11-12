import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/screens/screen_list_notifier.dart';
import 'package:cancionero_seixo/model/providers/screens/screen_providers.dart';
import 'package:cancionero_seixo/view/screens/presentation/cast/cast_screen.dart';

class PresentationPreview extends ConsumerWidget {
  const PresentationPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Display? display = ref.watch(ScreenProviders.list.select((screens) => screens?.where((screen) => screen.selected).firstOrNull));

    bool preview = ref.watch(PresentationProviders.controls.select((controls) => controls.preview));

    if (!preview) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(left: 30),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border.all(
              width: 4,
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                ),
                child: Text(
                  display?.name ?? "Previsualización",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              AspectRatio(
                aspectRatio: display != null ? display.width / display.height : 4 / 3,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: CastScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
