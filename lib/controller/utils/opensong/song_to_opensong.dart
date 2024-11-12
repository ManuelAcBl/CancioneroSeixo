

// class SongToOpenSong {
//   final Song song;
//   late final Iterable<String> ids;
//
//   SongToOpenSong({required this.song}) {
//     ids = getOpenSongIds(song.verses);
//   }
//
//   String getOpenSongVerses() {
//     Iterable<Verse> verses = song.verses;
//     Iterable<String> ids = getOpenSongIds(verses);
//     String text = '';
//
//     for (int i = 0; i < verses.length; i++) {
//       if (text.isNotEmpty) text += '\n\n';
//       text += "[${ids.elementAt(i)}]\n${verses.elementAt(i).text.reduce((value, element) => "$value\n||\n$element")}";
//     }
//
//     return text;
//   }
//
//   String getOpenSongOrder() {
//     return song.order.map((e) => getOpenSongIds(song.verses).elementAt(e)).reduce((value, element) => "$value $element");
//   }
//
//   Iterable<String> getOpenSongIds(Iterable<Verse> verses) {
//     List<String> ids = [];
//
//     for (int i = 0; i < verses.length; i++) {
//       Verse verse = verses.elementAt(i);
//
//       int? number = verses.toList().getRange(0, i).where((element) => element.type == verse.type).length + 1;
//       if (verses.where((element) => element.type == verse.type).length == 1) number = null;
//
//       String letter = {'verse': 'V', 'chorus': 'C', 'bridge': 'B', 'preChorus': 'P'}[verse.type.name]!;
//
//       ids.add("$letter${number ?? ''}");
//     }
//
//     return ids;
//   }
// }
