import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';

class AppUserNotifier extends Notifier<AppUser> {
  static final AppUser _default = AppUser(rank: Rank.anonymous, username: "Anónimo");

  @override
  AppUser build() {
    User? user = ref.watch(AuthProviders.firebase);

    if (user == null) return _default;

    Future(() async {
      String? url = user.photoURL;

      if(url == null) return;

      Uint8List? profileImage = await _getProfileImage(url);

      _update(profileImage: profileImage);
    });

    AppUser appUser = AppUser(rank: Rank.user, username: user.displayName ?? "Sin Nombre", email: user.email);

    print("Usuario: ${appUser.username} || Correo: ${appUser.email}");

    return appUser;
  }

  Future<Uint8List?> _getProfileImage(String url) async {
    try {
      Response response = await get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {}

    return null;
  }

  void _update({Uint8List? profileImage}) => state = AppUser(
        rank: state.rank,
        username: state.username,
        email: state.email,
        profileImage: profileImage,
      );
}

class AppUser {
  final Rank rank;
  final String username;
  final String? email;
  final Uint8List? profileImage;

  AppUser({required this.rank, required this.username, this.email, this.profileImage});
}

enum Rank {
  anonymous,
  user,
  editor,
  admin;
}
