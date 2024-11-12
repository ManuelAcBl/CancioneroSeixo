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

class AuthenticationEmailRegister extends ConsumerWidget {
  final GlobalKey<CustomTextFieldState> usernameState = GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> emailState = GlobalKey<CustomTextFieldState>();
  final PasswordConfirmationTextField password = PasswordConfirmationTextField();

  AuthenticationEmailRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthenticationScreenTemplate(
      appBarTitle: 'Registro',
      children: [
        CustomTextField(
          key: usernameState,
          label: "Nombre de usuario",
          type: TextInputType.text,
        ),
        const Gap(15),
        CustomTextField(
          key: emailState,
          label: "Correo",
          type: TextInputType.emailAddress,
        ),
        const Gap(15),
        password,
        const Gap(30),
        ProgressCustomButton(
          text: "Registrarse",
          icon: BootstrapIcons.person_fill,
          color: Theme.of(context).primaryColor,
          dataColor: Colors.white,
          onTap: () async {
            CustomTextFieldState username = usernameState.currentState!;
            CustomTextFieldState email = emailState.currentState!;

            if (!username.validate() || !email.validate() || !password.validate()) return null;

            RegisterError? error =
                await ref.read(AuthProviders.firebase.notifier).register(username.text(), email.text(), password.text1());

            String? message = switch (error) {
              RegisterError.network => "No tienes conexión a Internet",
              RegisterError.error => "Error del servidor. Inténtalo más tarde.",
              _ => null,
            };

            if (context.mounted) context.pop();

            return message;
          },
        ),
      ],
    );
  }
}
