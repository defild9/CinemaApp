abstract class PurchaseEvent {}

class PurchaseInitiatedEvent extends PurchaseEvent {
  final String accessToken;
  final List<int> seatIds;
  final int sessionId;
  final String email;
  final String cardNumber;
  final String expirationDate;
  final String cvv;

  PurchaseInitiatedEvent({
    required this.accessToken,
    required this.seatIds,
    required this.sessionId,
    required this.email,
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
  });
}