import 'package:cinema_app/data/datasources/api_client.dart';
import 'package:cinema_app/presentation/blocs/purchase/purchase_event.dart';
import 'package:cinema_app/presentation/blocs/purchase/purchase_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final ApiClient _apiClient = ApiClient();

  PurchaseBloc() : super(PurchaseInitial()) {
    on<PurchaseInitiatedEvent>(purchaseInitiatedEvent);
  }

  Future<void> purchaseInitiatedEvent(PurchaseInitiatedEvent event, Emitter<PurchaseState> emit) async {
    emit(PurchaseInProgress());
    try {
      final success = await _apiClient.buyTickets(
        event.accessToken,
        event.seatIds,
        event.sessionId,
        event.email,
        event.cardNumber,
        event.expirationDate,
        event.cvv,
      );
      if (success) {
        emit(PurchaseSuccess());
      } else {
        emit(PurchaseFailure('Failed to purchase tickets'));
      }
    } catch (e) {
      emit(PurchaseFailure(e.toString()));
    }
  }
}

