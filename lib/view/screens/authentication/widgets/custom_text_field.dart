import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/controller/utils/validation.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextInputType type;
  final String? value, hint;
  final bool? multiline, required;
  final TextCapitalization? capitalization;
  final Widget? suffix;

  const CustomTextField({
    super.key,
    required this.label,
    required this.type,
    this.value,
    this.multiline,
    this.capitalization,
    this.suffix,
    this.required,
    this.hint,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  TextEditingController? controller;

  bool visible = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    controller ??= TextEditingController(text: widget.value ?? "");

    bool isPassword = widget.type == TextInputType.visiblePassword;

    return TextField(
      textCapitalization: widget.capitalization ?? TextCapitalization.none,
      maxLines: widget.multiline == true ? null : 1,
      controller: controller,
      keyboardType: widget.type,
      obscureText: visible && isPassword,
      decoration: InputDecoration(
        error: _error != null ? Text(_error!, style: const TextStyle(color: Colors.red)) : null,
        labelText: widget.label,
        suffix: widget.suffix,
        hintText: widget.hint,
        suffixIcon: isPassword
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => setState(() => visible = !visible),
                    icon: Icon(
                      visible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  const Gap(5),
                ],
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  bool validate() {
    String text = controller!.text;

    if (text.isEmpty && widget.required != true) return true;

    String? error = switch (widget.type) {
      TextInputType.name => Validation.usernameValidation(text),
      TextInputType.emailAddress => Validation.emailValidation(text),
      TextInputType.multiline => Validation.textValidation(text),
      TextInputType.text => Validation.textValidation(text),
      TextInputType.number => Validation.textValidation(text),
      TextInputType.visiblePassword => Validation.passwordValidation(text),
      _ => null,
    };

    setState(() => _error = error);

    return error == null;
  }

  void reset() => setState(() {
        controller?.text = widget.value ?? "";
        _error = null;
      });

  void setError(String error) => setState(() => _error = error);

  String text() => controller!.text;
}

class PasswordConfirmationTextField extends StatelessWidget {
  final GlobalKey<CustomTextFieldState> passwordState = GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> repeatPasswordState = GlobalKey<CustomTextFieldState>();

  PasswordConfirmationTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          key: passwordState,
          label: "Contraseña",
          type: TextInputType.visiblePassword,
        ),
        const Gap(15),
        CustomTextField(
          label: "Repetir Contraseña",
          type: TextInputType.visiblePassword,
          key: repeatPasswordState,
        ),
      ],
    );
  }

  String text1() => passwordState.currentState!.text();

  String text2() => repeatPasswordState.currentState!.text();

  bool validate() {
    CustomTextFieldState password = passwordState.currentState!;
    CustomTextFieldState repeatPassword = repeatPasswordState.currentState!;

    if (!password.validate() || !repeatPassword.validate()) return false;

    if (password.text() != repeatPassword.text()) {
      String error = "Las contraseñas no coinciden";
      password.setError(error);
      repeatPassword.setError(error);
      return false;
    }

    return true;
  }
}
