import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/search/search_metrics_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';

class SearchMetricsWidget extends ConsumerWidget {
  const SearchMetricsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SearchMetrics metrics = ref.watch(SearchProviders.metrics);

    if (metrics.search == null && metrics.build == null && metrics.results == null) return const SizedBox();

    TextStyle style = const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          metrics.results != 0
              ? Text(
                  textAlign: TextAlign.start,
                  "${metrics.results} resultados",
                  style: style,
                )
              : const SizedBox(),
          Text(
            textAlign: TextAlign.start,
            "${(metrics.search ?? 0) + (metrics.build ?? 0)}ms",
            style: style,
          ),
        ],
      ),
    );
  }
}
