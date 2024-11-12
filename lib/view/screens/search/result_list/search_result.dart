import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';
import 'package:cancionero_seixo/model/providers/search/search_metrics_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_result_notifier.dart';
import 'package:cancionero_seixo/view/screens/search/search_message.dart';
import 'package:cancionero_seixo/view/screens/search/result_list/result_song_list.dart';
import 'package:cancionero_seixo/view/widgets/text/info_message.dart';

class SearchResultWidget extends ConsumerWidget {
  final bool presentation;

  const SearchResultWidget({super.key, required this.presentation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Stopwatch stopwatch = Stopwatch()..start();

    Iterable<SongSearchResult>? results = ref.watch(SearchProviders.result);
    SearchMetricsNotifier metrics = ref.read(SearchProviders.metrics.notifier);

    if (results == null) {
      //Future(() => metrics.remove());
      return const SearchMessage();
    }

    if (results.isEmpty) {
      //Future(() => metrics.remove());
      return const InfoMessage(
        title: "Sin resultados",
        text: "Prueba a buscar otra cosa",
      );
    }

    SearchResultSongList widget = SearchResultSongList(
      results: results.toList(),
      presentation: presentation,
    );

    Future(() => metrics.set(ref.read(SearchProviders.metrics).copyWith(build: stopwatch.elapsedMilliseconds)));

    return widget;
  }
}
