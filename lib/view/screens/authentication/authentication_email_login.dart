import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';
import 'package:cancionero_seixo/model/providers/authentication/firebase_authentication_notifier.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/authentication_screen_template.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/custom_text_field.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/progress_button.dart';

class AuthenticationEmailLogin extends ConsumerStatefulWidget {
  const AuthenticationEmailLogin({super.key});

  @override
  ConsumerState<AuthenticationEmailLogin> createState() => _AuthenticationEmailLoginState();
}

class _AuthenticationEmailLoginState extends ConsumerState<AuthenticationEmailLogin> {
  final GlobalKey<CustomTextFieldState> emailState = GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> passwordState = GlobalKey<CustomTextFieldState>();

  @override
  Widget build(BuildContext context) {
    return AuthenticationScreenTemplate(appBarTitle: 'Inicio de Sesión', children: [
      CustomTextField(
        key: emailState,
        label: "Correo",
        type: TextInputType.emailAddress,
      ),
      const Gap(15),
      CustomTextField(
        key: passwordState,
        label: "Contraseña",
        type: TextInputType.visiblePassword,
      ),
      const Gap(20),
      ProgressCustomButton(
        text: "Iniciar sesión",
        icon: BootstrapIcons.person_fill,
        color: Theme.of(context).primaryColor,
        dataColor: Colors.white,
        onTap: () async {
          CustomTextFieldState email = emailState.currentState!;
          CustomTextFieldState password = passwordState.currentState!;

          if (!email.validate() || !password.validate()) return null;

          LoginError? error = await ref.read(AuthProviders.firebase.notifier).login(email.text(), password.text());

          String? message = switch (error) {
            null => null,
            LoginError.error => "Error del servidor. Inténtalo más tarde.",
            LoginError.credentials => "Usuario o contraseña Incorrectos",
            LoginError.network => "No tienes conexión a Internet",
          };

          if (message == null && context.mounted) context.pop();

          return message;
        },
      ),
      const Gap(15),
      CustomButton(
        text: "Registrarse",
        icon: BootstrapIcons.person_plus_fill,
        color: Colors.white,
        dataColor: Colors.black,
        onTap: () async {
          bool? registered = (await context.push("/authentication/email/register")) as bool?;

          if (registered != null && registered && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email enviado. Revisa tu correo")));
          }
        },
      ),
      const Gap(20),
      TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () => context.push("/authentication/reset"),
          child: const Text(
            "He olvidado mi contraseña.",
            textAlign: TextAlign.start,
          )),
    ]);
  }
}
