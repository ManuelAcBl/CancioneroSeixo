import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/player/player_providers.dart';
import 'package:cancionero_seixo/view/screens/song/music/music_list.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({super.key});

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> with AutomaticKeepAliveClientMixin {
  //late final YoutubePlayerController _controller;

  @override
  void initState() {
    // _controller = YoutubePlayerController(
    //   params: const YoutubePlayerParams(
    //     interfaceLanguage: 'es',
    //     enableCaption: false,
    //     showFullscreenButton: false,
    //   ),
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    YoutubePlayerController? controller = ref.read(PlayerProviders.player.select((player) => player?.controller));

    return Scaffold(
      body: SingleChildScrollView(
        child: MusicList(
          onTap: (id) async {
            ref.read(PlayerProviders.player.notifier).play(id);
            //await _controller.cueVideoById(videoId: id);
            setState(() => {});
          },
          onPause: () async {
            ref.read(PlayerProviders.player.notifier).stop();
            //await _controller.close();
            setState(() => {});
          },
        ),
      ),
      bottomSheet: controller != null ? YoutubePlayer(controller: controller) : const SizedBox(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
