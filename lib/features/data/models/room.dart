import 'package:cinema_app/features/data/models/row.dart';

class Room {
  final int id;
  final String name;
  final List<Row> rows;

  Room({required this.id, required this.name, required this.rows});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      rows: (json['rows'] as List).map((row) => Row.fromJson(row)).toList(),
    );
  }
}