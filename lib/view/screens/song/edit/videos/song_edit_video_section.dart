import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/view/screens/song/edit/song_edit_screen.dart';
import 'package:cancionero_seixo/view/widgets/text/centered_text.dart';
import 'package:cancionero_seixo/view/widgets/text/section_title.dart';

class SongEditVideoSection extends StatelessWidget {
  final Reference reference;

  const SongEditVideoSection({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(
              text: "Videos",
            ),
            TextButton(
              onPressed: () async {
                String? youtubeId = await showDialog(
                  context: context,
                  builder: (context) => const SongEditVideoAddAlert(),
                );

                // Add video
              },
              child: const Text("Añadir"),
            ),
          ],
        ),
        const Gap(15),
        EditorVideoList(reference: reference),
      ],
    );
  }
}

class EditorVideoList extends StatelessWidget {
  final Reference reference;

  const EditorVideoList({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    List<Video>? videos = reference.song.videos;

    if (videos == null && videos!.isEmpty) return const CenteredText(text: "No hay videos");

    return Column(
      children: getElements(videos),
    );
  }

  List<SongEditVideosElement> getElements(List<Video> videos) {
    return videos
        .map(
          (video) => SongEditVideosElement(
            reference: reference,
            video: video,
          ),
        )
        .toList();
  }
}
