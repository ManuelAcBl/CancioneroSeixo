import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/view/widgets/text/section_title.dart';

class BottomSheetMenu extends StatelessWidget {
  final String title;
  final Widget child;

  const BottomSheetMenu({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SectionTitle(text: title),
                ),
                const Gap(10),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}

class BottomSheetElementList extends StatelessWidget {
  final String title;
  final List<BottomSheetElement> elements;

  const BottomSheetElementList({super.key, required this.title, required this.elements});

  @override
  Widget build(BuildContext context) {
    return BottomSheetMenu(
      title: title,
      child: Column(
        children: elements,
      ),
    );
  }
}

class BottomSheetElement extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const BottomSheetElement({super.key, required this.name, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: onTap,
    );
  }
}
