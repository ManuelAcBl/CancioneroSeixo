import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/screens/screen_list_notifier.dart';

abstract class ScreenProviders {
  static final list = NotifierProvider<ScreenListNotifier, List<Display>?>(ScreenListNotifier.new);
}
