class Seat {
  final int id;
  final int index;
  final int type;
  final double price;
  final bool isAvailable;

  Seat(
      {required this.id,
        required this.index,
        required this.type,
        required this.price,
        required this.isAvailable});

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      index: json['index'],
      type: json['type'],
      price: json['price'].toDouble(),
      isAvailable: json['isAvailable'],
    );
  }
}