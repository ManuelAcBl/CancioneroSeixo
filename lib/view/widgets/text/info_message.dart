import 'package:flutter/material.dart';

class InfoMessage extends StatelessWidget {
  final String title, text;

  const InfoMessage({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 16,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
