import 'package:flutter/material.dart';

class InfoSettingsScreen extends StatelessWidget {
  const InfoSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información"),
      ),
      body: const Column(
        children: [
          ListTile(
            title: Text("Autor"),
            subtitle: Text("Manuel Acuña"),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text("Versión"),
            subtitle: Text("0.0.1"),
            leading: Icon(Icons.numbers),
          ),
          ListTile(
            title: Text("Fecha de la Versión"),
            subtitle: Text("08/11/2024"),
            leading: Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }
}
