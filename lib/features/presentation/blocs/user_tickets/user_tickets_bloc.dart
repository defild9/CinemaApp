import 'package:cinema_app/features/data/datasources/api_client.dart';
import 'package:cinema_app/features/data/datasources/storage.dart';
import 'package:cinema_app/features/presentation/blocs/user_tickets/user_tickets_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTicketsBloc extends Bloc<UserTicketsEvent, UserTicketsState> {
  UserTicketsBloc() : super(UserTicketsLoading()) {
    on<FetchTicketsEvent>((event, emit) async {
      try {
        final accessToken = await Storage.getAccessToken();
        final ticketList = await ApiClient().getTickets(accessToken!);
        emit(UserTicketsLoaded(ticketList));
      } catch (e) {
        emit(UserTicketsError(e.toString()));
      }
    });
  }
}