import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/view/widgets/appbar/custom_popup_menu_button.dart';

class CustomFormScreen extends StatelessWidget {
  final String title, saveText;
  final VoidCallback onSubmit, showHelp;
  final List<Widget> children;
  final List<PopupMenuEntry<dynamic>>? popupElements;

  const CustomFormScreen({
    super.key,
    required this.title,
    required this.saveText,
    required this.onSubmit,
    required this.children,
    this.popupElements,
    required this.showHelp,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.close),
        ),
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) onSubmit();
            },
            child: Text(saveText),
          ),
          CustomPopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: showHelp,
                child: const Text("Ayuda"),
              ),
              PopupMenuItem(
                onTap: formKey.currentState?.reset,
                child: const Text("Deshacer"),
              ),
            ],
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
