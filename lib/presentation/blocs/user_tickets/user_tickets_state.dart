import 'package:cinema_app/domain/entities/ticket_list.dart';

abstract class UserTicketsState {}

class UserTicketsInitial extends UserTicketsState {}

class UserTicketsLoading extends UserTicketsState {}

class UserTicketsLoaded extends UserTicketsState {
  final TicketList ticketList;

  UserTicketsLoaded(this.ticketList);
}

class UserTicketsError extends UserTicketsState {
  final String error;

  UserTicketsError(this.error);
}
