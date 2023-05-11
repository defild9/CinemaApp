import 'package:cinema_app/features/data/datasources/api_client.dart';
import 'package:cinema_app/features/data/datasources/storage.dart';
import 'package:cinema_app/features/data/models/seat.dart';
import 'package:cinema_app/features/data/models/session.dart';

class BookingService {
  List<Seat> _selectedSeats = [];

  List<Seat> get selectedSeats => _selectedSeats;
  List<int> get selectedSeatIds => _selectedSeats.map((seat) => seat.id).toList();

  void selectSeat(Seat seat) {
    _selectedSeats.add(seat);
  }

  void deselectSeat(int seatId) {
    _selectedSeats.removeWhere((seat) => seat.id == seatId);
  }

  Future<bool> bookSeats(Session session) async {
    final accessToken = await Storage.getAccessToken();
    final success =
    await ApiClient().bookSeats(accessToken!, selectedSeatIds, session.id);
    return success;
  }

  List<Seat> getSelectedSeats() {
    return _selectedSeats;
  }
}
