import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/view/screens/authentication/widgets/actual_account.dart';

class AuthenticationScreenTemplate extends StatelessWidget {
  final String appBarTitle;
  final bool? firstScreen;
  final List<Widget> children;

  const AuthenticationScreenTemplate({super.key, required this.appBarTitle, this.firstScreen, required this.children});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            onPressed: context.pop,
            icon: Icon(firstScreen == true ? Icons.close : Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ActualAccountWidget(),
                const Gap(40),
                ...children,
              ],
            ),
          ),
        ),
      );
}
