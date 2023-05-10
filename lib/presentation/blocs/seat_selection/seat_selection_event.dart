import 'package:cinema_app/data/models/seat.dart';
import 'package:cinema_app/data/models/session.dart';

abstract class SeatSelectionEvent {}

class SeatTappedEvent extends SeatSelectionEvent {
  final Seat seat;

  SeatTappedEvent(this.seat);
}

class BookSeatsEvent extends SeatSelectionEvent {
  final Session session;

  BookSeatsEvent(this.session);
}