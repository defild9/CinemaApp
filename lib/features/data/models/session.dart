import 'package:cinema_app/features/data/models/room.dart';

class Session {
  final int id;
  final int date;
  final String type;
  final double minPrice;
  final Room room;

  Session(
      {required this.id,
        required this.date,
        required this.type,
        required this.minPrice,
        required this.room});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      date: json['date'],
      type: json['type'],
      minPrice: json['minPrice'].toDouble(),
      room: Room.fromJson(json['room']),
    );
  }
}
