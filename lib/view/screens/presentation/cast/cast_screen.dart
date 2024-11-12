import 'package:flutter/material.dart';
import 'package:cancionero_seixo/controller/presentation/presentation_client.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_cast_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';
import 'package:cancionero_seixo/view/screens/presentation/cast/cast_footer.dart';
import 'package:cancionero_seixo/view/screens/presentation/cast/cast_verse.dart';

class CastScreen extends StatelessWidget {
  final int? displayId;

  const CastScreen({super.key, this.displayId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueAccent,
        child: SlidePresentation(displayId: displayId),
      ),
    );
  }
}

class SlidePresentation extends StatefulWidget {
  final int? displayId;

  const SlidePresentation({super.key, this.displayId});

  @override
  State<SlidePresentation> createState() => _SlidePresentationState();
}

class _SlidePresentationState extends State<SlidePresentation> {
  late final CastClient client;
  CastData? data;

  @override
  void initState() {
    client = CastClient()..start(widget.displayId ?? -1, (data) => setState(() => this.data = data as CastData?));

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();

    return CastBackground(
      decoration: data?.decoration,
      child: CastContent(data: data?.slide),
    );
  }

  @override
  void dispose() {
    client.stop();
    super.dispose();
  }
}

class CastBackground extends StatelessWidget {
  final CastDecoration? decoration;
  final Widget child;

  const CastBackground({super.key, required this.decoration, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: 1,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: decoration?.color,
        image: decoration?.background != null
            ? DecorationImage(
                image: AssetImage(decoration!.background!),
                fit: BoxFit.fill,
              )
            : null,
      ),
      child: child,
    );
  }
}

class CastContent extends StatelessWidget {
  final VerseSlide? data;

  const CastContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();

    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          flex: 7,
          child: CastVerse(
            data: data!.verse,
          ),
        ),
        Expanded(
          flex: 1,
          child: CastFooter(
            data: data!.song,
          ),
        ),
      ],
    );
  }
}
