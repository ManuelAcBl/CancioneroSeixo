import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/authentication_screen_template.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/progress_button.dart';

class AuthenticationLogged extends ConsumerWidget {
  const AuthenticationLogged({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthenticationScreenTemplate(
      appBarTitle: 'Mi cuenta',
      firstScreen: true,
      children: [
        ProgressCustomButton(
          text: "Cerrar sesión",
          icon: BootstrapIcons.person_fill_slash,
          color: Colors.redAccent,
          dataColor: Colors.white,
          onTap: () async {
            await ref.read(AuthProviders.firebase.notifier).logout();
            return null;
          },
        ),
        const Gap(15),
        CustomButton(
          text: "Editar perfil",
          icon: BootstrapIcons.person_fill_gear,
          color: Colors.white,
          dataColor: Colors.black,
          onTap: () => context.push("/authentication/profile"),
        ),
        const Gap(15),
        TextButton(
            onPressed: () => {},
            child: const Text(
              "Borrar cuenta",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
  }
}
