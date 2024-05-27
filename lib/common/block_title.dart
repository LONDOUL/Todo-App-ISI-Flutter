import 'package:flutter/material.dart';
import 'package:todo_app/common/commons.dart';

class BlockTitle extends StatelessWidget {
  final String title;
  const BlockTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingValue),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            color: iconColor,
            fontSize: 15.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5),
      ),
    );
  }
}
