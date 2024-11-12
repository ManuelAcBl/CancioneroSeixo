import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchMetricsNotifier extends Notifier<SearchMetrics> {
  @override
  SearchMetrics build() => SearchMetrics();

  void set(SearchMetrics metrics) => state = metrics;

  void clear() => state = SearchMetrics();
}

class SearchMetrics {
  final int? results, search, build, sort, cache, filter;

  SearchMetrics({
    this.results,
    this.search,
    this.build,
    this.sort,
    this.cache,
    this.filter,
  });

  SearchMetrics copyWith({
    int? results,
    int? search,
    int? build,
    int? sort,
    int? cache,
    int? filter,
  }) =>
      SearchMetrics(
        results: results ?? this.results,
        search: search ?? this.search,
        build: build ?? this.build,
        sort: sort ?? this.sort,
        cache: cache ?? this.cache,
        filter: filter ?? this.filter,
      );
}
