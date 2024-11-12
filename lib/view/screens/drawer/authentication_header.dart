import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/authentication/app_user_notifier.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';

class AuthenticationHeader extends ConsumerWidget {
  const AuthenticationHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppUser user = ref.watch(AuthProviders.user);

    return InkWell(
      onTap: () => context.pushNamed("authentication"),
      child: UserAccountsDrawerHeader(
          accountName: Text(user.username),
          accountEmail: Text(user.email ?? "Haz clic para iniciar sesión"),
          currentAccountPicture: CircleAvatar(
              backgroundImage: user.profileImage != null ? Image.memory(user.profileImage!).image : null,
              child: user.profileImage == null ? const Icon(Icons.person, size: 50) : null)),
    );
  }
}
