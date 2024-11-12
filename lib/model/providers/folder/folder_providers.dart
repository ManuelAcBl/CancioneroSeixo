import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/folder/folder_current_number_notifier.dart';
import 'package:cancionero_seixo/model/providers/folder/folder_selection_notifier.dart';

abstract class FolderProviders {
  //static final current = NotifierProvider<FolderCurrentNumberNotifier, Map<String, String?>>(FolderCurrentNumberNotifier.new);
  static final selector = NotifierProvider<FolderSelectionNotifier, List<String>>(FolderSelectionNotifier.new);
}
