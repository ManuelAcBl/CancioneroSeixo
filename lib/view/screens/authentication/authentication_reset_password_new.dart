import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/controller/utils/validation.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';
import 'package:cancionero_seixo/model/providers/authentication/firebase_authentication_notifier.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/auth_text_field.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/authentication_screen_template.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/progress_button.dart';

class AuthenticationPasswordResetNew extends ConsumerStatefulWidget {
  final String email;

  const AuthenticationPasswordResetNew({super.key, required this.email});

  @override
  ConsumerState<AuthenticationPasswordResetNew> createState() => _AuthenticationPasswordResetState();
}

class _AuthenticationPasswordResetState extends ConsumerState<AuthenticationPasswordResetNew> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  String? codeError, passwordError, repeatPasswordError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationScreenTemplate(
      appBarTitle: "Restablecer Contraseña",
      children: [
        Text(
          "Se ha enviado un código de verificación al correo electrónico: ${widget.email}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        const Gap(30),
        AuthCodeTextField(
          controller: codeController,
          label: "Código",
          error: codeError,
        ),
        const Gap(15),
        AuthPasswordTextField(
          controller: passwordController,
          label: "Nueva contraseña",
          error: passwordError,
        ),
        const Gap(15),
        AuthPasswordTextField(
          controller: repeatPasswordController,
          label: "Repetir contraseña",
          error: repeatPasswordError,
        ),
        const Gap(30),
        ProgressCustomButton(
            text: "Restablecer Contraseña",
            icon: BootstrapIcons.person_fill_lock,
            color: Theme.of(context).primaryColor,
            dataColor: Colors.white,
            onTap: () async {
              String code = codeController.value.text;
              String password = passwordController.value.text;
              String repeatPassword = repeatPasswordController.value.text;

              if (!_inputsValidation(code, password, repeatPassword)) return;

              ConfirmPasswordResetError? error = await ref.read(AuthProviders.firebase.notifier).confirmResetPassword(code, password);

              String? message = switch (error) {
                ConfirmPasswordResetError.network => "No tienes conexión a Internet",
                ConfirmPasswordResetError.error => "Error del servidor. Inténtalo más tarde.",
                _ => null,
              };

              if (message != null) {
                setState(() => codeError = message);
                return;
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contraseña restablecida")));
                context.pop(true);
              }
            }),
      ],
    );
  }

  bool _inputsValidation(String code, String password, String repeatPassword) {
    String? codeError = Validation.resetCodeValidation(code);
    String? passwordError = Validation.passwordValidation(password);
    String? repeatPasswordError = Validation.passwordValidation(repeatPassword);

    if (passwordError == null) {
      if (password != repeatPassword) {
        passwordError = repeatPasswordError = "Las contraseñas no coinciden.";
      }
    }

    setState(() {
      this.codeError = codeError;
      this.passwordError = passwordError;
      this.repeatPasswordError = repeatPasswordError;
    });

    return codeError == null && passwordError == null && repeatPasswordError == null;
  }
}
