import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';

class PresentationSlide extends ConsumerWidget {
  final Widget child;
  final int index;
  final Color? color;

  const PresentationSlide({super.key, required this.index, required this.child, this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool selected = ref.watch(PresentationProviders.index.select((index) => index == this.index));

    if (selected) {
      Future(
        () => Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            alignment: 0.1,
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit),
      );
    }

    return GestureDetector(
      onTap: () => ref.read(PresentationProviders.index.notifier).set(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selected ? Theme.of(context).primaryColorLight.withOpacity(0.5) : color,
        ),
        child: child,
      ),
    );
  }
}
