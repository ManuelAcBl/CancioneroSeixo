import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/search_selection_notifier.dart';

abstract class SelectionProviders {
  static final selection = NotifierProvider<SearchSelectionNotifier, List<Reference>>(SearchSelectionNotifier.new);
}