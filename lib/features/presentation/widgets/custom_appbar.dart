import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: const [
      ],
      backgroundColor: Colors.deepPurple[400],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

