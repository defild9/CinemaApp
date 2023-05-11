class Ticket {
  final int id;
  final int movieId;
  final String name;
  final int date;
  final int seatIndex;
  final int rowIndex;
  final String roomName;
  final String image;
  final String smallImage;

  Ticket({
    required this.id,
    required this.movieId,
    required this.name,
    required this.date,
    required this.seatIndex,
    required this.rowIndex,
    required this.roomName,
    required this.image,
    required this.smallImage,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      movieId: json['movieId'],
      name: json['name'],
      date: json['date'],
      seatIndex: json['seatIndex'],
      rowIndex: json['rowIndex'],
      roomName: json['roomName'],
      image: json['image'],
      smallImage: json['smallImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'name': name,
      'date': date,
      'seatIndex': seatIndex,
      'rowIndex': rowIndex,
      'roomName': roomName,
      'image': image,
      'smallImage': smallImage,
    };
  }
}
