import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/view/widgets/text/info_message.dart';

class ErrorScreen extends StatelessWidget {
  final String? message;

  const ErrorScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => context.goNamed('home'));

    return InfoMessage(
      title: message ?? "Ha ocurrido un error :(",
      text: "Serás redirigido al menú de Inicio",
    );
  }
}
