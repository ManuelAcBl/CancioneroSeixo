import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? error;
  final TextInputType type;
  final bool? obscureText;

  const AuthTextField({super.key, required this.controller, required this.label, this.error, required this.type, this.obscureText});

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          error: error != null ? Text(error!, style: const TextStyle(color: Colors.red)) : null,
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      );
}

class AuthEmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? error;

  const AuthEmailTextField({super.key, required this.controller, required this.label, this.error});

  @override
  Widget build(BuildContext context) => AuthTextField(controller: controller, label: label, error: error, type: TextInputType.emailAddress);
}

class AuthPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? error;

  const AuthPasswordTextField({super.key, required this.controller, required this.label, this.error});

  @override
  Widget build(BuildContext context) => AuthTextField(
        controller: controller,
        label: label,
        error: error,
        type: TextInputType.visiblePassword,
        obscureText: true,
      );
}

class AuthUsernameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? error;

  const AuthUsernameTextField({super.key, required this.controller, required this.label, this.error});

  @override
  Widget build(BuildContext context) => AuthTextField(controller: controller, label: label, error: error, type: TextInputType.text);
}

class AuthCodeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? error;

  const AuthCodeTextField({super.key, required this.controller, required this.label, this.error});

  @override
  Widget build(BuildContext context) => AuthTextField(controller: controller, label: label, error: error, type: TextInputType.number);
}
