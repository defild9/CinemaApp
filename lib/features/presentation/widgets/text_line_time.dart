import 'package:cinema_app/features/data/models/movie.dart';
import 'package:cinema_app/features/data/models/session.dart';
import 'package:cinema_app/features/presentation/pages/book_and_purchase/seat_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextLineTimeWidget extends StatelessWidget {
  final Movie movie;
  final Session session;

  const TextLineTimeWidget({super.key, required this.session, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              session.room.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              session.type,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Divider(
          color: Color(0xFFD0D0D0),
          thickness: 2,
        ),
        InkWell(
          child: Text(
            DateFormat('HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                    session.date * 1000)),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SeatSelectionPage(
                      session: session,
                      movie: movie,
                    ),
              ),
            );
          },
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}