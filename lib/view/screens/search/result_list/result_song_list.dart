import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/search/search_result_notifier.dart';
import 'package:cancionero_seixo/view/screens/search/result_list/result_song_tile.dart';
import 'package:cancionero_seixo/view/widgets/scrollbar/custom_scrollbar.dart';

class SearchResultSongList extends ConsumerStatefulWidget {
  final List<SongSearchResult> results;
  final bool presentation;

  const SearchResultSongList({super.key, required this.results, required this.presentation});

  @override
  ConsumerState<SearchResultSongList> createState() => _SearchSongList2State();
}

class _SearchSongList2State extends ConsumerState<SearchResultSongList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle highlightStyle = TextStyle(backgroundColor: Theme.of(context).primaryColorLight);
    Color oddColor = Theme.of(context).primaryColorLight.withOpacity(0.2);

    return CustomScrollbar(
      controller: _controller,
      child: ListView.builder(
        controller: _controller,
        itemCount: widget.results.length,
        itemBuilder: (context, index) => Container(
          color: index.isOdd ? oddColor : null,
          child: SearchSongTile(
            result: widget.results.elementAt(index),
            highlightStyle: highlightStyle,
            presentation: widget.presentation,
          ),
        ),
      ),
    );
  }
}
