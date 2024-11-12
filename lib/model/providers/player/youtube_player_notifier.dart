import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubePlayerNotifier extends Notifier<PlayerData?> {
  late final YoutubePlayerController _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      interfaceLanguage: 'es',
      enableCaption: false,
      showFullscreenButton: false,
    ),
  );

  @override
  PlayerData? build() => null;

  void play(String videoId) {
    _controller.cueVideoById(videoId: videoId);

    _controller.listen((data) {
      CustomPlayerState playerState = switch (data.playerState) {
        PlayerState.playing => CustomPlayerState.playing,
        PlayerState.paused => CustomPlayerState.paused,
        PlayerState.ended => CustomPlayerState.ended,
        _ => CustomPlayerState.loading,
      };

      state = state!.copyWith(state: playerState);
    });

    state = PlayerData(
      state: CustomPlayerState.loading,
      controller: _controller,
    );
  }

  void pause() => state?.controller.pauseVideo();

  void resume() => state?.controller.playVideo();

  void stop() {
    state?.controller.stopVideo();

    state = null;
  }

  void replay() => state?.controller.seekTo(seconds: 0);
}

class PlayerData {
  final CustomPlayerState state;
  final YoutubePlayerController controller;

  PlayerData({required this.state, required this.controller});

  PlayerData copyWith({CustomPlayerState? state, PlayerProgress? progress}) => PlayerData(
        state: state ?? this.state,
        controller: controller,
      );
}

class PlayerProgress {
  final Duration end, actual;

  PlayerProgress({required this.end, required this.actual});
}

enum CustomPlayerState {
  playing,
  paused,
  loading,
  ended,
}
