import 'package:cinema_app/features/data/models/seat.dart';
import 'package:flutter/material.dart';

class SelectedSeatsInfo extends StatelessWidget {
  final List<Seat> selectedSeats;
  final Function onTap;

  const SelectedSeatsInfo(
      {Key? key, required this.selectedSeats, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num totalPrice =
    selectedSeats.fold<num>(0, (sum, seat) => sum + seat.price);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).backgroundColor : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${selectedSeats.length} ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                      child: Icon(
                        Icons.confirmation_num,
                        color: Colors.deepPurple[400] ?? Colors.deepPurple,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$totalPrice грн',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onTap(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[400],
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Продовжити',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
