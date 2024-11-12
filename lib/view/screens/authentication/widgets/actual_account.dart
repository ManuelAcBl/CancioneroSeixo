import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/model/providers/authentication/app_user_notifier.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';

class ActualAccountWidget extends ConsumerWidget {
  const ActualAccountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppUser? user = ref.watch(AuthProviders.user);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(20),
        Center(
          child: CircleAvatar(
              radius: 45,
              backgroundImage: user?.profileImage != null ? Image.memory(user!.profileImage!).image : null,
              child: user?.profileImage == null ? const Icon(Icons.person, size: 55) : null),
        ),
        const Gap(10),
        Text(
          user?.username ?? "Anónimo",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          textAlign: TextAlign.center,
        ),
        Text(
          user?.email ?? "No has iniciado sesión",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
