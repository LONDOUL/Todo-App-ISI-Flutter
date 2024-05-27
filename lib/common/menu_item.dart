import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuItem({super.key, required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 50.0,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
