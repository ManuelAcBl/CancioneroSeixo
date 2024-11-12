

// class OpenSongToSong {
//   final String order, verses;
//
//   late final Iterable<Verse> outVerses;
//   late final Iterable<int> outOrder;
//
//   OpenSongToSong({required this.order, required this.verses}) {
//     RegExp exp = RegExp(r'\[((\w)(\d*))\]\n\s*([\s\S]+?)(?=\n\[|\n\n|$)', dotAll: true);
//     Iterable<RegExpMatch> matches = exp.allMatches(verses);
//
//     outVerses = matches.map((e) {
//       VerseType type =
//           VerseType.values.firstWhere((type) => type.name == {'V': 'verse', 'C': 'chorus', 'P': 'preChorus', 'B': 'bridge'}[e.group(2)]);
//       return Verse(type: type, text: e.group(4)!.split("||"));
//     });
//
//     outOrder = order.split(" ").map((e) {
//       print("a: $e");
//       for(int i = 0; i < matches.length; i++) {
//         RegExpMatch match = matches.elementAt(i);
//
//         if(match.group(1) == e) {
//           return i;
//         }
//       }
//
//       return -1;
//     });
//   }
//
//   Iterable<Verse> getVerses() => outVerses;
//
//   Iterable<int> getOrder() => outOrder;
// }
