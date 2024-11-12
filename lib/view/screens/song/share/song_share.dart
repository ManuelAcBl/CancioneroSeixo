import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/view/screens/song/export/song_export_widget.dart';
import 'package:cancionero_seixo/view/widgets/bottom_sheet_menu.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/bottom_sheet_selector.dart';

class SongShareOptions extends ConsumerWidget {
  final List<Reference> references;

  const SongShareOptions({super.key, required this.references});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetElementList(
      title: "Compartir como:",
      elements: [
        BottomSheetElement(
          name: "Documento PDF",
          icon: BootstrapIcons.filetype_pdf,
          onTap: () {},
        ),
        BottomSheetElement(
          name: "Imagen JPG",
          icon: BootstrapIcons.filetype_jpg,
          onTap: () {},
        ),
      ],
    );
  }

  Future<Uint8List> _getPNGImage() async {
    throw UnimplementedError();
    //SongExportWidget songExport = SongExportWidget(reference: references);

    // RenderRepaintBoundary boundary = songExport.createState().context.findRenderObject() as RenderRepaintBoundary;
    // ui.Image image = await boundary.toImage();
    // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // return byteData!.buffer.asUint8List();
  }

  void _shareJPGImage() async {
    Uint8List imageBytes = await _getPNGImage();
  }

  void _sharePDFDocument() {}
}
