import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/authentication/app_user_notifier.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/authentication_screen_template.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/custom_text_field.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/progress_button.dart';

class AuthenticationProfile extends ConsumerWidget {
  const AuthenticationProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppUser user = ref.watch(AuthProviders.user)!;

    return AuthenticationScreenTemplate(
      appBarTitle: "Perfil",
      children: [
        ProfileItem(
          data: ProfileValueData(
            name: "Nombre de usuario",
            value: user.username,
            type: TextInputType.name,
          ),
          icon: BootstrapIcons.person_vcard_fill,
        ),
        ProfileItem(
          data: ProfileValueData(
            name: "Correo",
            value: user.email ?? "",
            type: TextInputType.emailAddress,
          ),
          icon: BootstrapIcons.envelope_at_fill,
        ),
        // ProfileItem(
        //   data: ProfileValueData(
        //     name: "Correo",
        //     value: user.email,
        //     type: TextInputType.emailAddress,
        //     attribute: AuthUserAttributeKey.email,
        //   ),
        //   icon: BootstrapIcons.envelope_at_fill,
        // ),
        // ProfileItem(
        //   name: "Contraseña",
        //   value: "********",
        //   onTap: () => {},
        //   icon: BootstrapIcons.person_fill_lock,
        // ),
      ],
    );
  }
}

class ProfileItem extends StatelessWidget {
  final ProfileValueData data;
  final IconData icon;

  const ProfileItem({super.key, required this.data, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //onTap: onTap,
      leading: Icon(icon),
      title: Text(
        data.name,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
      subtitle: Text(
        data.value,
        style: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }
}

class ProfileChange extends ConsumerWidget {
  final GlobalKey<CustomTextFieldState> emailState = GlobalKey<CustomTextFieldState>();
  final ProfileValueData data;

  ProfileChange({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthenticationScreenTemplate(
      appBarTitle: data.name,
      children: [
        CustomTextField(
          key: emailState,
          label: data.name,
          type: data.type,
          value: data.value,
        ),
        ProgressCustomButton(
          text: "Actualizar",
          icon: BootstrapIcons.floppy_fill,
          color: Colors.white,
          dataColor: Colors.black,
          onTap: () async {
            CustomTextFieldState email = emailState.currentState!;

            if (!email.validate()) return null;

            //String? error = await ref.read(AuthProviders.user.notifier).updateData(data.attribute, email.text());

            //if (error != null) return error;

            if (context.mounted) context.pop();

            return null;
          },
        )
      ],
    );
  }
}

class ProfileValueData {
  final String name, value;
  final TextInputType type;

  ProfileValueData({required this.name, required this.value, required this.type});
}
