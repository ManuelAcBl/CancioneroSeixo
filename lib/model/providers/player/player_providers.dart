import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/player/youtube_player_notifier.dart';

abstract class PlayerProviders {
  static final player = NotifierProvider<YouTubePlayerNotifier, PlayerData?>(YouTubePlayerNotifier.new);
}
