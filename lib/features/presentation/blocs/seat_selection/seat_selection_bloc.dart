import 'package:cinema_app/features/data/models/seat.dart';
import 'package:cinema_app/features/domain/repositories/booking_service.dart';
import 'package:cinema_app/features/presentation/blocs/seat_selection/seat_selection_event.dart';
import 'package:cinema_app/features/presentation/blocs/seat_selection/seat_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeatSelectionBloc extends Bloc<SeatSelectionEvent, SeatSelectionState> {
  final BookingService bookingService;

  SeatSelectionBloc({required this.bookingService})
      : super(SeatSelectionInitial()) {
    on<SeatTappedEvent>(seatTappedEvent);
    on<BookSeatsEvent>(bookSeatsEvent);
  }

  Future<void> seatTappedEvent(SeatTappedEvent event, Emitter<SeatSelectionState> emit) async {
    if (bookingService.selectedSeatIds.contains(event.seat.id)) {
      bookingService.deselectSeat(event.seat.id);
    } else {
      bookingService.selectSeat(event.seat);
    }
    List<Seat> selectedSeats = bookingService.getSelectedSeats();
    emit(SeatSelectionChanged(selectedSeats: bookingService.selectedSeats));
  }

  Future<void> bookSeatsEvent(BookSeatsEvent event, Emitter<SeatSelectionState> emit) async {
    final success = await bookingService.bookSeats(event.session);
    if (success) {
      emit(SeatsBookedSuccess(selectedSeats: bookingService.getSelectedSeats()));
    } else {
      emit(SeatsBookingFailed(message: 'Failed to book seats'));
    }
  }
}
