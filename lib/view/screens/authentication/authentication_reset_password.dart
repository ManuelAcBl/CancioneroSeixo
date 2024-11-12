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

class AuthenticationPasswordReset extends ConsumerStatefulWidget {
  const AuthenticationPasswordReset({super.key});

  @override
  ConsumerState<AuthenticationPasswordReset> createState() => _AuthenticationPasswordResetState();
}

class _AuthenticationPasswordResetState extends ConsumerState<AuthenticationPasswordReset> {
  final GlobalKey<CustomTextFieldState> emailState = GlobalKey<CustomTextFieldState>();

  @override
  Widget build(BuildContext context) {
    return AuthenticationScreenTemplate(
      appBarTitle: "Restablecer Contraseña",
      children: [
        CustomTextField(
          key: emailState,
          label: "Correo",
          type: TextInputType.emailAddress,
        ),
        const Gap(30),
        ProgressCustomButton(
            text: "Restablecer",
            icon: BootstrapIcons.person_fill,
            color: Theme.of(context).primaryColor,
            dataColor: Colors.white,
            onTap: () async {
              CustomTextFieldState email = emailState.currentState!;

              if (!email.validate()) return null;

              SendPasswordResetError? error = await ref.read(AuthProviders.firebase.notifier).sendResetPassword(email.text());

              String? message = switch (error) {
                SendPasswordResetError.network => "No tienes conexión a Internet",
                SendPasswordResetError.error => "Error del servidor. Inténtalo más tarde.",
                _ => null,
              };

              if (error != null) {
                return message;
              }

              if (!context.mounted) return null;

              bool? exit = (await context.push("/authentication/reset/new", extra: email.text())) as bool?;

              if (exit == true && context.mounted) context.pop();

              return null;
            }),
      ],
    );
  }
}
