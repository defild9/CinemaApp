import 'package:cinema_app/features/data/models/seat.dart';

abstract class SeatSelectionState {}

class SeatSelectionInitial extends SeatSelectionState {}

class SeatSelectionChanged extends SeatSelectionState {
  final List<Seat> selectedSeats;

  SeatSelectionChanged({required this.selectedSeats});
}

class SeatsBookedSuccess extends SeatSelectionState {
  final List<Seat> selectedSeats;

  SeatsBookedSuccess({required this.selectedSeats});
}

class SeatsBookingFailed extends SeatSelectionState {
  final String message;

  SeatsBookingFailed({required this.message});
}
