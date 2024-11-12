import 'package:flutter/material.dart';

mixin ShellScreen {
  Widget leading(BuildContext context) => IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu));
}
