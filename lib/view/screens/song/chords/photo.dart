import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class DocumentCapture extends StatefulWidget {
  const DocumentCapture({super.key});

  @override
  DocumentCaptureState createState() => DocumentCaptureState();
}

class DocumentCaptureState extends State<DocumentCapture> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Recortar la imagen
      await _cropImage(imageFile);

      // Comprimir la imagen después del recorte
      if (_imageFile != null) {
        File compressedImage = await _compressImage(_imageFile!);

        // Subir al servidor
        await _uploadToServer(compressedImage);
      }
    }
  }

  Future<void> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1.414),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 30,
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = File(croppedFile.path);
      });

      Future(() async {
        int? length = await _imageFile?.length();
        print("File size: $length");
      });
    }
  }

  Future<File> _compressImage(File imageFile) async {
    // Leer la imagen original
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());

    // Redimensionar la imagen (ajusta el tamaño según lo necesites)
    final resizedImage = img.copyResize(originalImage!, width: 800);

    // Comprimir la imagen con calidad reducida
    final compressedImageBytes = img.encodeJpg(resizedImage, quality: 75);

    // Guardar la imagen comprimida en un nuevo archivo temporal
    final compressedImageFile = await File(imageFile.path).writeAsBytes(compressedImageBytes);

    return compressedImageFile;
  }

  Future<void> _uploadToServer(File imageFile) async {
    final uri = Uri.parse('https://example.com/upload');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Imagen subida con éxito');
    } else {
      print('Error al subir la imagen: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tomar Foto del Documento')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null ? Image.file(_imageFile!) : Text('No hay imagen capturada'),
            ElevatedButton(
              onPressed: _takePhoto,
              child: Text('Tomar Foto'),
            ),
          ],
        ),
      ),
    );
  }
}
