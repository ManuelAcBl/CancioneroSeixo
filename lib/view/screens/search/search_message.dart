import 'package:flutter/material.dart';

class SearchMessage extends StatelessWidget {
  const SearchMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 50),
      child: const Text(
        "Escribe en el cuadro de búsqueda\npara encontrar la canción que buscas.\nSe puede buscar por: número, título y letra.",
        textAlign: TextAlign.center,
      ),
    );
  }
}
