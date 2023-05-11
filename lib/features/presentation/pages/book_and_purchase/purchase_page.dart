import 'package:cinema_app/features/presentation/blocs/purchase/purchase_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/purchase/purchase_state.dart';
import 'package:cinema_app/features/presentation/pages/movie/movies_page.dart';
import 'package:cinema_app/features/presentation/widgets/custom_appbar_with_timer.dart';
import 'package:cinema_app/features/presentation/widgets/purchase_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchasePage extends StatelessWidget {
  final List<int> seatIds;
  final int sessionId;
  final num totalPrice;

  PurchasePage({required this.seatIds, required this.sessionId, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseBloc(),
      child: Scaffold(
        appBar: const CustomAppBarTimer(
          title: "Оплата",
        ),
        body: BlocBuilder<PurchaseBloc, PurchaseState>(
          builder: (context, state) {
            if (state is PurchaseInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PurchaseSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MoviesPage()),
                      (route) => false,
                );
              });
              return const SizedBox();
            } else if (state is PurchaseFailure) {
              return Center(child: Text('Ошибка: ${state.error}'));
            } else {
              return PurchaseForm(seatIds: seatIds, sessionId: sessionId, totalPrice: totalPrice,);
            }
          },
        ),
      ),
    );
  }
}


