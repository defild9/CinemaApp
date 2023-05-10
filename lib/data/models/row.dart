import 'package:cinema_app/data/models/seat.dart';

class Row {
  final int id;
  final int index;
  final List<Seat> seats;

  Row({required this.id, required this.index, required this.seats});

  factory Row.fromJson(Map<String, dynamic> json) {
    return Row(
      id: json['id'],
      index: json['index'],
      seats:
      (json['seats'] as List).map((seat) => Seat.fromJson(seat)).toList(),
    );
  }
}