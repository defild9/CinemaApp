import 'package:cinema_app/data/datasources/storage.dart';
import 'package:cinema_app/presentation/blocs/purchase/purchase_bloc.dart';
import 'package:cinema_app/presentation/blocs/purchase/purchase_event.dart';
import 'package:cinema_app/presentation/pages/main_page.dart';
import 'package:cinema_app/presentation/pages/movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class PurchaseForm extends StatefulWidget {
//   final List<int> seatIds;
//   final int sessionId;
//   final num totalPrice;
//
//   PurchaseForm({required this.seatIds, required this.sessionId, required this.totalPrice});
//
//   @override
//   _PurchaseFormState createState() => _PurchaseFormState();
// }
//
// class _PurchaseFormState extends State<PurchaseForm> {
//   final _emailController = TextEditingController();
//   final _cardNumberController = TextEditingController();
//   final _expirationDateController = TextEditingController();
//   final _cvvController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     double totalAmount = widget.seatIds.length * 10.0; // Здесь установите цену билета
//
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Text('Seats: ${widget.seatIds.join(', ')}'),
//           Text('Session: ${widget.sessionId}'),
//           Text( // Добавьте этот виджет для отображения суммы к оплате
//             'Сумма к оплате: ${widget.totalPrice}',
//             style: Theme.of(context).textTheme.headline6,
//           ),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           TextField(
//             controller: _cardNumberController,
//             decoration: InputDecoration(labelText: 'Card Number'),
//           ),
//           TextField(
//             controller: _expirationDateController,
//             decoration: InputDecoration(labelText: 'Expiration Date'),
//           ),
//           TextField(
//             controller: _cvvController,
//             decoration: InputDecoration(labelText: 'CVV'),
//           ),
//           ElevatedButton(
//             onPressed: () => _purchaseTickets(context),
//             child: Text('Purchase'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _purchaseTickets(BuildContext context) async {
//     final email = _emailController.text;
//     final cardNumber = _cardNumberController.text;
//     final expirationDate = _expirationDateController.text;
//     final cvv = _cvvController.text;
//
//     final accessToken = await Storage.getAccessToken();
//
//     // Dispatch purchase initiated event
//     BlocProvider.of<PurchaseBloc>(context).add(
//       PurchaseInitiatedEvent(
//         accessToken: accessToken!,
//         seatIds: widget.seatIds,
//         sessionId: widget.sessionId,
//         email: email,
//         cardNumber: cardNumber,
//         expirationDate: expirationDate,
//         cvv: cvv,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _cardNumberController.dispose();
//     _expirationDateController.dispose();
//     _cvvController.dispose();
//     super.dispose();
//   }
// }
class PurchaseForm extends StatefulWidget {
  final List<int> seatIds;
  final int sessionId;
  final num totalPrice;

  PurchaseForm({required this.seatIds, required this.sessionId, required this.totalPrice});

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final _emailController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _cvvController = TextEditingController();

  int _secondsLeft = 15 * 60;

  void _updateTime(int secondsLeft) {
    setState(() {
      _secondsLeft = secondsLeft;
    });
    if (_secondsLeft <= 0) {
      _showPurchaseTimeoutDialog(context);
    }
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.deepPurple[400]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  void _showPurchaseTimeoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Час минув :(('),
          content: const Text('Час для купівлі закінчився.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Сума до сплати: ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.totalPrice} грн',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurple),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _cardNumberController,
                    decoration: _inputDecoration('Номер картки'),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _expirationDateController,
                          decoration: _inputDecoration('Термін дії'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: TextField(
                          controller: _cvvController,
                          decoration: _inputDecoration('CVV2'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.deepPurple[400]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _purchaseTickets(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Оплатити',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _purchaseTickets(BuildContext context) async {
    final email = _emailController.text;
    final cardNumber = _cardNumberController.text;
    final expirationDate = _expirationDateController.text;
    final cvv = _cvvController.text;

    final accessToken = await Storage.getAccessToken();

    // Dispatch purchase initiated event
    BlocProvider.of<PurchaseBloc>(context).add(
      PurchaseInitiatedEvent(
        accessToken: accessToken!,
        seatIds: widget.seatIds,
        sessionId: widget.sessionId,
        email: email,
        cardNumber: cardNumber,
        expirationDate: expirationDate,
        cvv: cvv,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _cardNumberController.dispose();
    _expirationDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}