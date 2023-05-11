import 'package:flutter/material.dart';

class SeatWidget extends StatelessWidget {
  final int seatType;
  const SeatWidget({Key? key, required this.seatType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: seatType == 0 ? Colors.deepPurple[400] : (seatType == 1 ? Colors.blueAccent : Colors.orange),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
