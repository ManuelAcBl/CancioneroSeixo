import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/model/providers/providers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';

class SongExport {
  // static exportAsPDF(Reference reference, WidgetRef ref) async {
  //
  //
  //   Database? database = ref.read(Providers.database);
  //
  //   if (database == null) return;
  //
  //   DatabaseSong song = database.getSong(reference.songId);
  //   Book book = database.getBook(reference.bookId);
  //
  //   Document document = Document();
  //
  //   document.addPage(
  //     Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (Context context) => ListView(
  //         children: [
  //           Text(song.title),
  //           Text("${reference.number} ${book.title}"),
  //           Text(song.lyrics),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   Directory directory = await getTemporaryDirectory();
  //   String path = "${directory.path}/${song.title} - ${reference.number} ${book.title}.pdf";
  //
  //   File file = File(path);
  //   await file.writeAsBytes(await document.save());
  //
  //   await Share.shareXFiles([XFile(path)]);
  // }
}
