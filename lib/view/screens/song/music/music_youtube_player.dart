import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MusicYoutubePlayer extends StatelessWidget {
  final YoutubePlayerController controller;

  const MusicYoutubePlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.playerState,
        builder: (context, snapshot) {
          print("PLAYER STATEEEEE!!!!!!!!!: ${snapshot.data}");

          switch (snapshot.data) {
            case null:
            case PlayerState.unknown:
            case PlayerState.unStarted:
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(
                  child: Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        "Selecciona un video",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );

            case PlayerState.ended:
            case PlayerState.playing:
            case PlayerState.paused:
            case PlayerState.buffering:
            case PlayerState.cued:
              return YoutubePlayer(controller: controller);
          }
        });
  }
}
