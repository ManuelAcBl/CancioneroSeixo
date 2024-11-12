import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cancionero_seixo/view/widgets/bottom_sheet_menu.dart';
import 'package:cancionero_seixo/view/widgets/floating_button/custom_extended_floating_button.dart';
import 'package:image/image.dart' as img;

class SongChordsScreen extends StatelessWidget {
  const SongChordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomExtendedFloatingButton(
        text: "Añadir",
        icon: Icons.add,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const InputSelector(),
          );
        },
      ),
    );
  }
}

class InputSelector extends StatelessWidget {
  const InputSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetElementList(
      title: "Añadir desde:",
      elements: [
        BottomSheetElement(
          name: "Cámara",
          icon: Icons.camera_alt,
          onTap: () => _getImage(Theme.of(context), ImageSource.camera),
        ),
        BottomSheetElement(
          name: "Galería",
          icon: Icons.image,
          onTap: () async {
            Image? image = await _getImage(Theme.of(context), ImageSource.gallery);

            if (!context.mounted || image == null) return;

            //await context.pushNamed("chord_crop", extra: File(image.path));

            showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomSheet(
                  onClosing: () {},
                  builder: (context) => image,
                  enableDrag: false,
                );
              },
            );
          },
        ),
        BottomSheetElement(
          name: "Archivo PDF",
          icon: Icons.description,
          onTap: () {},
        ),
      ],
    );
  }

  Future<Uint8List?> _pickImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(
      source: source,
      requestFullMetadata: false,
    );

    return image?.readAsBytes();
  }

  Future<Image?> _getImage(ThemeData theme, ImageSource source) async {
    Uint8List? bytes = await _pickImage(source);

    if (bytes == null) return null;

    print(1);
    img.Image? image = img.decodeJpg(bytes);
    if (image == null) return null;

    print(2);
    image = img.grayscale(image);

    // Guarda como PNG
    File file = await File("image.jpg").writeAsBytes(bytes);

    print(5);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1.414),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 10,
      maxWidth: 1500,
      maxHeight: 1500,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Recortar",
          toolbarColor: theme.appBarTheme.backgroundColor,
          backgroundColor: theme.scaffoldBackgroundColor,
          statusBarColor: theme.appBarTheme.backgroundColor,
          toolbarWidgetColor: theme.iconTheme.color,
        ),
      ],
    );

    print(6);

    if (croppedFile == null) return null;

    print("File size: ${file.lengthSync() / 1024} KB");

    return Image.file(file);
  }

// Future<Image?> _getImage(ThemeData theme, ImageSource source) async {
//   // Captura la imagen
//   final XFile? image = await ImagePicker().pickImage(source: source);
//
//   if (image == null) return null;
//
//   // Recorta la imagen
//   final CroppedFile? cropped = await ImageCropper().cropImage(
//     sourcePath: image.path,
//     aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1.414),
//     compressFormat: ImageCompressFormat.png,
//     compressQuality: 10,
//     maxWidth: 1500,
//     maxHeight: 1500,
//     uiSettings: [
//       AndroidUiSettings(
//         toolbarTitle: "Recortar",
//         toolbarColor: theme.appBarTheme.backgroundColor,
//         backgroundColor: theme.scaffoldBackgroundColor,
//         statusBarColor: theme.appBarTheme.backgroundColor,
//         toolbarWidgetColor: theme.iconTheme.color,
//       ),
//     ],
//   );
//
//   if (cropped == null) return null;
//
//   // Lee la imagen como bytes
//   final Uint8List bytes = await cropped.readAsBytes();
//
//   // Decodifica la imagen
//   img.Image? decodedImage = img.decodeImage(bytes);
//   if (decodedImage == null) return null;
//
//   // Convierte la imagen a escala de grises
//   img.Image grayscaleImage = img.grayscale(decodedImage);
//
//   // Guarda como PNG
//   final png = File('${image.path}.png');
//   await png.writeAsBytes(img.encodePng(grayscaleImage));
//
//   // Imprime el tamaño del archivo
//   print("File size: ${await png.length() / 1024} KB");
//
//   // Devuelve la imagen en formato PNG
//   return Image.file(png);
// }
}
