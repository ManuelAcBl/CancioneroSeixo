import 'package:flutter/material.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';
import 'package:cancionero_seixo/view/screens/presentation/cast/cast_text.dart';

class CastFooter extends StatelessWidget {
  final SongData data;

  const CastFooter({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CastText(
              text: Text(
                data.title,
                style: const TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            CastText(
              text: Text(
                data.authors ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
