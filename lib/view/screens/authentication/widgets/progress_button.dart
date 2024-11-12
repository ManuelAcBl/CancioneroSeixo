import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProgressCustomButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color color, dataColor;
  final Future<String?> Function() onTap;

  const ProgressCustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.dataColor,
    required this.onTap,
  });

  @override
  State<ProgressCustomButton> createState() => _ProgressCustomButtonState();
}

class _ProgressCustomButtonState extends State<ProgressCustomButton> {
  bool progress = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          error ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent),
        ),
        const Gap(10),
        CustomButton(
          text: widget.text,
          icon: widget.icon,
          color: widget.color,
          dataColor: widget.dataColor,
          onTap: () async {
            if (progress) return;
            this.error = null;

            setState(() => progress = true);
            String? error = await widget.onTap();
            setState(() {
              progress = false;
              this.error = error;
            });
          },
          child: progress
              ? Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: widget.dataColor,
                    ),
                  ),
                )
              : null,
        )
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color, dataColor;
  final Widget? child;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.dataColor,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: SizedBox(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: dataColor),
                  Expanded(
                    child: child == null
                        ? Text(text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: dataColor,
                            ))
                        : child!,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
