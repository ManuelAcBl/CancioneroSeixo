import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/search/search_metrics_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';
import 'package:cancionero_seixo/model/providers/search/search_result_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/selection_providers.dart';
import 'package:cancionero_seixo/view/screens/search/metrics/search_metrics.dart';
import 'package:cancionero_seixo/view/screens/search/result_list/search_result.dart';
import 'package:cancionero_seixo/view/screens/selection/song_selection_appbar.dart';
import 'package:cancionero_seixo/view/screens/song/share/song_share.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final bool presentation;

  const SearchScreen({super.key, required this.presentation});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final SearchMetricsNotifier metrics;
  late final TextEditingController controller;
  late final SongSearchResultNotifier results;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: "");

    results = ref.read(SearchProviders.result.notifier);
    controller.addListener(() => results.search(controller.text));

    metrics = ref.read(SearchProviders.metrics.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: null,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Buscar canción",
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.text = "",
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            onPressed: () => context.pushNamed("filter"),
            icon: const Icon(Icons.filter_alt),
          ),
          //const SearchSelectionIconButton(),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: SearchMetricsWidget(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SearchResultWidget(presentation: widget.presentation),
          ),
          SearchBottomSongSelectionAppBar(
            presentation: widget.presentation,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //Future(() => metrics.clear());
    Future(() => results.search(""));
    super.dispose();
  }
}

class SearchBottomSongSelectionAppBar extends ConsumerWidget {
  final bool presentation;

  const SearchBottomSongSelectionAppBar({super.key, required this.presentation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSongSelectionAppBar(
      presentation: presentation,
      action: presentation
          ? TextButton(
              onPressed: () {
                List<Reference> selection = ref.read(SelectionProviders.selection);

                ref.read(PresentationProviders.songs.notifier).addAll(selection.map((reference) => reference.id));
              },
              child: const Text(
                "Presentar",
                style: TextStyle(color: Colors.white),
              ),
            )
          : IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => SongShareOptions(references: ref.read(SelectionProviders.selection)),
              ),
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
    );
  }
}
