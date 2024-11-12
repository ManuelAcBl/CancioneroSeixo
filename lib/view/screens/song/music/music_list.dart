import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/view/screens/song/music/music_list_tile.dart';

class MusicList extends ConsumerStatefulWidget {
  final Function(String id) onTap;
  final VoidCallback onPause;

  const MusicList({super.key, required this.onTap, required this.onPause});

  @override
  ConsumerState<MusicList> createState() => _MusicListState();
}

class _MusicListState extends ConsumerState<MusicList> {
  int? selected = 0;

  @override
  void initState() {
    //widget.onTap("TdITcVD64zI");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MusicListTile(
            index: 0,
            selectedIndex: selected,
            name: "Musica 1",
            description: "Esta es una descripción",
            videoId: "TdITcVD64zI",
            onTap: _onTap,
          ),
          MusicListTile(
            index: 1,
            selectedIndex: selected,
            name: "Musica 2",
            description: "Esta es una descripción",
            videoId: "MC90ItQ1IZo",
            onTap: _onTap,
          ),
          MusicListTile(
            index: 2,
            selectedIndex: selected,
            name: "Musica 3",
            description: "Esta es una descripción",
            videoId: "pyfutidzxDE",
            onTap: _onTap,
          ),
          MusicListTile(
            index: 3,
            selectedIndex: selected,
            name: "Musica 4",
            description: "Esta es una descripción",
            videoId: "L1ZD6o3FxZk",
            onTap: _onTap,
          )
        ],
      ),
    );
  }

  void _onTap(int index, String videoId) {
    widget.onTap(videoId);
    setState(() => selected = index);
  }
}
