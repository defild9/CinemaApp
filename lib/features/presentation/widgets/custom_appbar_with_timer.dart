import 'dart:async';

import 'package:cinema_app/features/presentation/pages/main/main_page.dart';
import 'package:flutter/material.dart';

class CustomAppBarTimer extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBarTimer({Key? key, required this.title}) : super(key: key);

  @override
  _CustomAppBarTimerState createState() => _CustomAppBarTimerState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _CustomAppBarTimerState extends State<CustomAppBarTimer> {
  late Timer _timer;
  int _secondsLeft = 15 * 60;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsLeft--;
      });
      if (_secondsLeft <= 0) {
        timer.cancel();
        _showPurchaseTimeoutDialog(context);
      }
    });
  }

  void _showPurchaseTimeoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Время истекло'),
          content: const Text('Время для покупки закончилось.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Text(
              '${_secondsLeft ~/ 60}:${_secondsLeft % 60}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
      backgroundColor: Colors.deepPurple[400],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
