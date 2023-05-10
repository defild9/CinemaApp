abstract class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseInProgress extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {}

class PurchaseFailure extends PurchaseState {
  final String error;

  PurchaseFailure(this.error);
}