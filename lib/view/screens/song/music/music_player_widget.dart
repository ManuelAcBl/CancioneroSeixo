import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/model/providers/player/player_providers.dart';
import 'package:cancionero_seixo/model/providers/player/youtube_player_notifier.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MusicPlayerWidget extends ConsumerWidget {
  const MusicPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PlayerData? player = ref.watch(PlayerProviders.player);

    if (player == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).primaryColor.withAlpha(100),
      child: Row(
        children: [
          const PlayerPlayPauseButton(),
          const Gap(20),
          Expanded(
            child: PlayerProgress(
              controller: player.controller,
            ),
          ),
          const Gap(20),
          IconButton(
            onPressed: ref.watch(PlayerProviders.player.notifier).stop,
            icon: Icon(
              Icons.close,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

class PlayerPlayPauseButton extends ConsumerWidget {
  const PlayerPlayPauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PlayerData? player = ref.watch(PlayerProviders.player);

    if (player == null) return const SizedBox();

    CustomPlayerState state = player.state;
    YouTubePlayerNotifier notifier = ref.watch(PlayerProviders.player.notifier);

    return IconButton(
      onPressed: () {
        switch (state) {
          case CustomPlayerState.playing:
            notifier.pause();
            break;

          case CustomPlayerState.paused:
            notifier.resume();
            break;

          case CustomPlayerState.loading:
            break;

          case CustomPlayerState.ended:
            notifier.replay();
            break;
        }
      },
      icon: Icon(
        switch (state) {
          CustomPlayerState.playing => Icons.pause,
          CustomPlayerState.paused => Icons.play_arrow,
          CustomPlayerState.loading => Icons.play_arrow,
          CustomPlayerState.ended => Icons.refresh,
        },
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class PlayerProgress extends ConsumerStatefulWidget {
  final YoutubePlayerController controller;

  const PlayerProgress({super.key, required this.controller});

  @override
  ConsumerState<PlayerProgress> createState() => _PlayerProgressState();
}

class _PlayerProgressState extends ConsumerState<PlayerProgress> {
  late double end = 1, current = 0;

  @override
  void initState() {
    super.initState();

    update();

    Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) => update(),
    );
  }

  void update() async {
    double end = await widget.controller.duration;
    double current = await widget.controller.currentTime;

    setState(
      () {
        this.end = end;
        this.current = current;
      },
    );
  }

  @override
  Widget build(BuildContext context) => LinearProgressIndicator(
        value: current / end,
      );
}
