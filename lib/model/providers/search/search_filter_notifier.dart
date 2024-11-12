import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFilterNotifier extends Notifier<SearchFilter> {
  static SearchFilter _default() => SearchFilter(
        orderBy: OrderBy.number,
        searchIn: ["KzXD4k9hY8NzeoVYTNSR", "FwwJtH3LwZw7TFdugJPP"],
        searchFor: [...SearchFor.values]..remove(SearchFor.author),
      );

  @override
  SearchFilter build() {
    Future(() async {
      SearchFilter? searchFilter = await loadLocal();

      if (searchFilter == null) return;

      state = searchFilter;
    });

    return _default();
  }

  @override
  bool updateShouldNotify(SearchFilter previous, SearchFilter next) {
    //print("${previous.orderBy} -> ${next.orderBy}");
    saveLocal();
    return super.updateShouldNotify(previous, next);
  }

  Future<SearchFilter?> loadLocal() async {
    DateTime time = DateTime.now();
    print("Loading local search filter data...");
    SharedPreferences local = await SharedPreferences.getInstance();

    String? data = local.getString('search_filter');

    if (data == null) return null;

    late SearchFilter searchFilter;

    searchFilter = SearchFilter.fromJson(jsonDecode(data));

    try {
      searchFilter = SearchFilter.fromJson(jsonDecode(data));
    } catch (e) {
      print("Error on load local filter data! ($e)");
      return null;
    }

    print("Local search filter data loaded! (${DateTime.now().difference(time).inMilliseconds}ms)");
    return searchFilter;
  }

  Future<void> saveLocal() async {
    DateTime time = DateTime.now();
    print("Saving local search filter data...");
    SharedPreferences local = await SharedPreferences.getInstance();
    //print(jsonEncode(state.toJson()));
    local.setString('search_filter', jsonEncode(state.toJson()));
    print("Local search filter data saved! (${DateTime.now().difference(time).inMilliseconds}ms)");
  }

  void set({OrderBy? orderBy, List<String>? bookIds, List<SearchFor>? searchFor}) => state = state.copyWith(
        orderBy: orderBy,
        searchIn: bookIds,
        searchFor: searchFor,
      );

  void setOrderBy(OrderBy orderBy) => state = state.copyWith(orderBy: orderBy);

  void setBookIds(List<String> bookIds) => state = state.copyWith(searchIn: bookIds);

  void reset() => state = _default();
}

class SearchFilter {
  final OrderBy orderBy;
  final List<SearchFor> searchFor;
  final List<String> searchIn;

  SearchFilter({required this.orderBy, required this.searchIn, required this.searchFor});

  SearchFilter copyWith({OrderBy? orderBy, List<String>? searchIn, List<SearchFor>? searchFor}) => SearchFilter(
        orderBy: orderBy ?? this.orderBy,
        searchIn: searchIn ?? this.searchIn,
        searchFor: searchFor ?? this.searchFor,
      );

  factory SearchFilter.fromJson(Map<String, dynamic> json) => SearchFilter(
      orderBy: OrderBy.values.byName(json['orderBy']),
      searchIn: List<String>.from(json['bookIds']),
      searchFor: List<String>.from(json['searchFor']).map((name) => SearchFor.values.byName(name)).toList());

  Map<String, dynamic> toJson() => {
        'orderBy': orderBy.name,
        'bookIds': searchIn,
        'searchFor': searchFor.map((searchFor) => searchFor.name).toList(),
      };
}

enum OrderBy { number, title, book }

enum SearchFor { number, title, lyrics, author }
