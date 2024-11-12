import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CropImageScreen extends StatefulWidget {
  final File image;

  const CropImageScreen({super.key, required this.image});

  @override
  CropImageScreenState createState() => CropImageScreenState();
}

class CropImageScreenState extends State<CropImageScreen> {
  File? _croppedImage;

  double _rotation = 0, _scale = 1;
  double _startRotation = 0, _startScale = 0;
  Offset _position = Offset.zero, _startPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    print("Position: ${_position}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Imagen"),
        actions: [
          TextButton(
            onPressed: () => {},
            child: const Text("Recortar"),
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          _startRotation = _rotation;
          _startScale = _scale;
          _startPosition = details.focalPoint;
        },
        onScaleUpdate: (details) {

          setState(() {
            _scale = _startScale * details.scale;
            _rotation = _startRotation + details.rotation;
            _position += details.focalPoint - _startPosition;
            _startPosition = details.focalPoint;
          });
        },
        child: Container(
          color: Colors.black,
          child: Center(
            child: Stack(
              children: [
                Transform.translate(
                  offset: _position,
                  child: Transform.scale(
                    scale: _scale,
                    child: Transform.rotate(
                      angle: _rotation,
                      child: Image.file(widget.image),
                    ),
                  ),
                ),
                // Marco de recorte
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const AspectRatio(
                    aspectRatio: 1 / 1.414,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Imagen"),
        actions: [
          TextButton(
            onPressed: () => context.pop(_croppedImage),
            child: const Text("Recortar"),
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          _startRotation = _rotation;
          _startScale = _scale;
          _startPosition = _position;
        },
        onScaleUpdate: (details) {
          switch (details.pointerCount) {
            case 0:
            case 1:
              {
                setState(() {
                  _position = details.localFocalPoint - _startPosition;
                });
              }
            case 2:
              {
                setState(() {
                  _scale = _startScale * details.scale;
                  _rotation = _startRotation + details.rotation;
                });
              }
          }
        },
        onScaleEnd: (details) {},
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Transform.translate(
                offset: _position,
                child: Transform.scale(
                  scale: _scale,
                  child: Transform.rotate(
                    angle: _rotation,
                    child: Image.file(widget.image),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const AspectRatio(
                    aspectRatio: 1 / 1.414,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
