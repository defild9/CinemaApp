import 'package:cinema_app/data/models/ticket.dart';

class TicketList {
  final List<Ticket> tickets;

  TicketList({required this.tickets});

  factory TicketList.fromJson(Map<String, dynamic> json) {
    return TicketList(
      tickets: (json['data'] as List)
          .map((ticketJson) => Ticket.fromJson(ticketJson))
          .toList(),
    );
  }
}