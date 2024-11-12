import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/authentication_screen_template.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/progress_button.dart';

class AuthenticationLogin extends ConsumerWidget {
  const AuthenticationLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthenticationScreenTemplate(
      appBarTitle: 'Inicio de Sesión',
      firstScreen: true,
      children: [
        CustomButton(
          text: "Inicia sesión con tu correo",
          icon: BootstrapIcons.envelope_at_fill,
          color: Colors.white,
          dataColor: Colors.black,
          onTap: () => context.push('/authentication/email'),
        ),
        const Gap(15),
        CustomButton(
          text: "Inicia sesión con Google",
          icon: BootstrapIcons.google,
          color: const Color.fromRGBO(66, 133, 244, 1),
          dataColor: Colors.white,
          onTap: ref.read(AuthProviders.firebase.notifier).loginWithGoogle,
        ),
        const Gap(15),
        CustomButton(
          text: "Inicia sesión con Apple",
          icon: BootstrapIcons.apple,
          color: Colors.black,
          dataColor: Colors.white,
          onTap: () => {},
        ),
      ],
    );
  }

// Future<void> _logInWithGoogle(BuildContext context, WidgetRef ref) async {
//   GoogleLogInResponse response = await ref.read(Providers.authentication.notifier).logInWithGoogle();
//
//   if ((response == GoogleLogInResponse.error || response == GoogleLogInResponse.timeout) && context.mounted) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: const Text("No tienes conexión"),
//       action: SnackBarAction(label: "Reintentar", onPressed: () => _logInWithGoogle(context, ref)),
//     ));
//   }
// }
}
