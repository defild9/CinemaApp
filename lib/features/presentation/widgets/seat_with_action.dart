import 'package:cinema_app/features/data/models/seat.dart';
import 'package:flutter/material.dart';

class SeatActionWidget extends StatelessWidget {
  final Seat seat;
  final Function onTap;
  final bool isSelected;

  SeatActionWidget({required this.seat, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (!seat.isAvailable) {
      return Container(
        width: 20,
        height: 20,
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onTap(seat),
        child: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.red : (seat.type == 0 ? Colors.deepPurple[400] : (seat.type == 1 ? Colors.blueAccent : Colors.orange)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
    }
  }
}