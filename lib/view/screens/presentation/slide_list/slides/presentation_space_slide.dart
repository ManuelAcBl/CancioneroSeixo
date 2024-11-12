import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';
import 'package:cancionero_seixo/view/screens/presentation/slide_list/slides/presentation_slide.dart';

class PresentationSpaceSlide extends StatelessWidget {
  final SpaceSlide spaceSlide;

  const PresentationSpaceSlide({super.key, required this.spaceSlide});

  @override
  Widget build(BuildContext context) => PresentationSlide(index: spaceSlide.index, child: const Gap(40));
}
