import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/authentication/app_user_notifier.dart';
import 'package:cancionero_seixo/model/providers/authentication/auth_providers.dart';
import 'package:cancionero_seixo/model/providers/authentication/user_notifier.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_logged.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_login.dart';

class AuthenticationScreen extends ConsumerWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AuthenticationNotifier notifier = ref.read(AuthProviders.user.notifier);
    // User? user = ref.watch(AuthProviders.user);
    //
    // TextEditingController usernameCtrl = TextEditingController(text: "ManuelAc");
    // TextEditingController emailCtrl = TextEditingController(text: "manuelacbl2@gmail.com");
    // TextEditingController passwordCtrl = TextEditingController(text: "Warcraft5.");
    // TextEditingController repeatPasswordCtrl = TextEditingController(text: "Warcraft5.");
    // TextEditingController verificationCtrl = TextEditingController(text: "");
    //
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Test"),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         Center(
    //           child: Text("User ${user?.username ?? "none"}"),
    //         ),
    //         const Text("Username:"),
    //         TextField(controller: usernameCtrl),
    //         const Text("Email:"),
    //         TextField(controller: emailCtrl),
    //         const Text("Password:"),
    //         TextField(controller: passwordCtrl),
    //         const Text("Repeat Password:"),
    //         TextField(controller: repeatPasswordCtrl),
    //         const Text("Verification:"),
    //         TextField(controller: verificationCtrl),
    //         TextButton(
    //           onPressed: () => notifier.login(emailCtrl.text, passwordCtrl.text),
    //           child: const Text("LogIn"),
    //         ),
    //         TextButton(
    //           onPressed: notifier.logout,
    //           child: const Text("LogOut"),
    //         ),
    //         TextButton(
    //           onPressed: () => notifier.register(usernameCtrl.text, emailCtrl.text, passwordCtrl.text),
    //           child: const Text("Register"),
    //         ),
    //         TextButton(
    //           onPressed: () => notifier.verification(emailCtrl.text, verificationCtrl.text),
    //           child: const Text("Verification"),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    bool logged = ref.watch(AuthProviders.user).rank != Rank.anonymous;

    return logged ? const AuthenticationLogged() : const AuthenticationLogin();
  }
}
