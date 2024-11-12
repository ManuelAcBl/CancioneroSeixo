import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/search/search_data_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_filter_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_metrics_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_result_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/search_selection_notifier.dart';

abstract class SearchProviders {
  //static final selection = NotifierProvider<SearchSelectionNotifier, List<String>>(SearchSelectionNotifier.new);
  static final data = NotifierProvider<SongSearchDataNotifier, List<SongSearchData>?>(SongSearchDataNotifier.new);
  static final result = AutoDisposeNotifierProvider<SongSearchResultNotifier, Iterable<SongSearchResult>?>(SongSearchResultNotifier.new);
  static final filter = NotifierProvider<SearchFilterNotifier, SearchFilter>(SearchFilterNotifier.new);
  static final metrics = NotifierProvider<SearchMetricsNotifier, SearchMetrics>(SearchMetricsNotifier.new);
}
