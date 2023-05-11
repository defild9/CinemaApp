import 'package:flutter/material.dart';

class CustomAppBarAction extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function() onProfileTap;

  CustomAppBarAction({required this.title, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: onProfileTap,
        ),
      ],
      backgroundColor: Colors.deepPurple[400],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}