import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/folder/folder_selection_notifier.dart';

class Providers {
  //static final database = NotifierProvider<DatabaseNotifier, Database?>(DatabaseNotifier.new);
  //static final authentication = NotifierProvider<AuthenticationNotifier, AppUser?>(AuthenticationNotifier.new);
  //static final settings = NotifierProvider<SettingsNotifier, Settings?>(SettingsNotifier.new);
  static final selection = NotifierProvider<FolderSelectionNotifier, List<String>>(FolderSelectionNotifier.new);
  static final navigationIndex = StateProvider<int?>((ref) => null);
}
