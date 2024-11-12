import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/data/song_edit_data.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/view/widgets/form/custom_form_screen.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/custom_text_form_fiel.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/folder_dropdown_form_field.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/reference_number_form_field.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/song_lyrics_form_field.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/song_order_form_field.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/youtube_video_form_field.dart';
import 'package:cancionero_seixo/view/widgets/text/section_title.dart';

class SongEditScreen extends ConsumerStatefulWidget {
  final SongEditData? data;

  const SongEditScreen({super.key, required this.data});

  @override
  ConsumerState<SongEditScreen> createState() => _SongEditScreenState();
}

class _SongEditScreenState extends ConsumerState<SongEditScreen> {
  Reference? reference;
  Folder? folder;

  Folder? selectedFolder;
  String? number, title, authors, order, lyrics;

  @override
  void initState() {
    super.initState();
    SongEditData? data = widget.data;

    if (data != null) {
      reference = ref.read(DatabaseProviders.references.select((references) => references?[data.referenceId]));
      folder = ref.read(DatabaseProviders.folders.select((folders) => folders?[data.folderId])) ?? reference?.folder;

      selectedFolder = folder!;
      number = reference?.data.number;
      title = reference?.song.title;
      authors = reference?.song.authors;
      order = reference?.song.order;
      lyrics = reference?.song.lyrics;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool newSong = reference == null;

    return CustomFormScreen(
      title: newSong ? "Nueva Canción" : "Editar Canción",
      saveText: newSong ? "Crear" : "Guardar",
      showHelp: () {},
      onSubmit: () {},
      children: [
        SongEditFolder(
          folder: folder,
          number: number,
          onSelectFolder: (folder) => selectedFolder = folder,
          onSelectNumber: (number) => this.number = number,
        ),
        const Gap(15),
        const Divider(),
        const Gap(15),
        const SectionTitle(text: "Datos Canción"),
        const Gap(15),
        CustomTextFormField(
          label: "Título",
          capitalization: TextCapitalization.sentences,
          value: title,
          required: true,
          icon: Icons.title,
          onEdit: (title) => this.title = title,
        ),
        const Gap(15),
        CustomTextFormField(
          label: "Autor/es",
          capitalization: TextCapitalization.sentences,
          value: authors,
          icon: Icons.person,
          onEdit: (authors) => this.authors = authors,
        ),
        const Gap(15),
        SongOrderFormField(
          value: order,
          getLyrics: () => lyrics,
        ),
        const Gap(15),
        SongLyricsFormField(
          value: lyrics,
          onEdit: (lyrics) => this.lyrics = lyrics,
        ),
        const Gap(15),
        const Divider(),
        const Gap(15),
        SongEditVideos(
          reference: reference,
        ),
      ],
    );
  }
}

class SongEditVideos extends ConsumerWidget {
  final Reference? reference;

  const SongEditVideos({super.key, required this.reference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reference == null) return const SizedBox();

    List<Video>? videos = reference!.song.videos;

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

                print(youtubeId);
              },
              child: const Text("Añadir"),
            ),
          ],
        ),
        const Gap(15),
        ...(videos ?? []).map(
              (video) => SongEditVideosElement(reference: reference!, video: video),
        ),
      ],
    );
  }
}

class SongEditVideosElement extends StatelessWidget {
  final Reference reference;
  final Video video;

  const SongEditVideosElement({super.key, required this.reference, required this.video});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.drawer,
      title: Text(
        switch (video.type) {
          VideoType.music => "Música",
          VideoType.voice => "Voz",
          VideoType.both => "Voz y Música",
        },
      ),
      subtitle: Row(
        children: [
          const Icon(Icons.person),
          Text(video.author),
        ],
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.close),
      ),
    );
  }
}

class SongEditVideoAddAlert extends StatelessWidget {
  const SongEditVideoAddAlert({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> form = GlobalKey<FormState>();

    String? youtubeId;

    return AlertDialog(
      title: const Text("Añadir Vídeo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Introduce una URL o el ID de un video de YouTube."),
          const Gap(15),
          Form(
            key: form,
            child: YouTubeVideoFormField(
              onEdit: (value) => youtubeId = value,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (form.currentState?.validate() != true) return;

            context.pop(youtubeId);
          },
          child: const Text("Añadir"),
        ),
      ],
    );
  }
}

class SongEditFolder extends StatefulWidget {
  final Folder? folder;
  final String? number;

  final Function(String number) onSelectNumber;
  final Function(Folder folder) onSelectFolder;

  const SongEditFolder({super.key, required this.folder, this.number, required this.onSelectNumber, required this.onSelectFolder});

  @override
  State<SongEditFolder> createState() => _SongEditFolderState();
}

class _SongEditFolderState extends State<SongEditFolder> {
  late Folder? selectedFolder;
  late String? selectedNumber;

  @override
  void initState() {
    super.initState();

    selectedFolder = widget.folder;
    selectedNumber = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(text: "Datos Carpeta"),
        const Gap(15),
        widget.number == null
            ? FolderDropdownFormField(
          value: widget.folder,
          onSelect: (folder) {
            if (folder != null && selectedFolder != folder) {
              widget.onSelectFolder(folder);
              setState(() => selectedFolder = folder);
            }
          },
        )
            : const SizedBox(),
        selectedFolder != null && selectedFolder?.id != "-1"
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(15),
            ReferenceNumberFormField(
              value: selectedNumber,
              reservedValue: selectedFolder == widget.folder ? widget.number : null,
              folder: selectedFolder!,
              focus: true,
              onEdit: (number) {
                selectedNumber = number;
                widget.onSelectNumber(number);
              },
            ),
          ],
        )
            : const SizedBox(),
      ],
    );
  }
}
