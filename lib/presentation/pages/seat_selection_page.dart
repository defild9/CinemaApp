import 'package:cinema_app/data/models/movie.dart';
import 'package:cinema_app/data/models/seat.dart';
import 'package:cinema_app/data/models/session.dart';
import 'package:cinema_app/domain/repositories/booking_service.dart';
import 'package:cinema_app/presentation/blocs/seat_selection/seat_selection_bloc.dart';
import 'package:cinema_app/presentation/blocs/seat_selection/seat_selection_event.dart';
import 'package:cinema_app/presentation/blocs/seat_selection/seat_selection_state.dart';
import 'package:cinema_app/presentation/pages/purchase_page.dart';
import 'package:cinema_app/presentation/widgets/custom_appbar.dart';
import 'package:cinema_app/presentation/widgets/screen.dart';
import 'package:cinema_app/presentation/widgets/seat.dart';
import 'package:cinema_app/presentation/widgets/seat_with_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeatSelectionPage extends StatelessWidget {
  final Movie movie;
  final Session session;

  const SeatSelectionPage(
      {Key? key, required this.session, required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<Seat> uniqueSeats = {};

    for (var row in session.room.rows) {
      for (var seat in row.seats) {
        Seat? existingSeat;
        try {
          existingSeat = uniqueSeats.firstWhere((s) => s.type == seat.type);
        } catch (e) {
          existingSeat = null;
        }
        if (existingSeat == null) {
          uniqueSeats.add(seat);
        }
      }
    }

    List<Seat> sortedUniqueSeats = uniqueSeats.toList()
      ..sort((a, b) => a.type.compareTo(b.type));

    return BlocProvider(
      create: (BuildContext context) =>
          SeatSelectionBloc(bookingService: BookingService()),
      child: BlocConsumer<SeatSelectionBloc, SeatSelectionState>(
        listener: (context, state) {
          if (state is SeatsBookedSuccess) {
            final selectedSeats = context.read<SeatSelectionBloc>().bookingService.getSelectedSeats();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => PurchasePage(
                  seatIds: selectedSeats.map((seat) => seat.id).toList(),
                  sessionId: session.id,
                  totalPrice: selectedSeats.fold<num>(0, (sum, seat) => sum + seat.price),
                ),
              ),
                  (route) => route.isFirst,
            );
          } else if (state is SeatsBookingFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SeatSelectionInitial || state is SeatSelectionChanged) {
            return Scaffold(
              appBar: const CustomAppBar(
                title: 'Вибір місця',
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    movie.image!,
                                    width: 140,
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.name!,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        movie.genre!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: sortedUniqueSeats.map((seat){
                              return Row(
                                children: [
                                  SeatWidget(seatType: seat.type),
                                  Text('${seat.price.toInt()} ₴')
                                ],
                              );
                            }).toList(),
                          ),
                          CustomPaint(
                            painter: Screen(),
                            child: const SizedBox(
                              width: double.infinity,
                              height: 100,
                            ),
                          ),
                          ListView.builder(
                            itemCount: session.room.rows.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final row = session.room.rows[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${row.index}'),
                                    Expanded(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: row.seats
                                            .map((seat) => SeatActionWidget(
                                                  seat: seat,
                                                  onTap: (seat) {
                                                    context
                                                        .read<
                                                            SeatSelectionBloc>()
                                                        .add(SeatTappedEvent(
                                                            seat as Seat));
                                                  },
                                                  isSelected: state
                                                          is SeatSelectionChanged &&
                                                      state.selectedSeats
                                                          .contains(seat),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (state is SeatSelectionChanged)
                    if (state.selectedSeats.isNotEmpty)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SelectedSeatsInfo(
                          selectedSeats: state.selectedSeats,
                          onTap: () {
                            context.read<SeatSelectionBloc>().add(BookSeatsEvent(session));
                          },
                        ),
                      ),

                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class SelectedSeatsInfo extends StatelessWidget {
  final List<Seat> selectedSeats;
  final Function onTap;

  const SelectedSeatsInfo(
      {Key? key, required this.selectedSeats, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num totalPrice =
        selectedSeats.fold<num>(0, (sum, seat) => sum + seat.price);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).backgroundColor : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${selectedSeats.length} ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    WidgetSpan(
                      child: Icon(
                        Icons.confirmation_num,
                        color: Colors.deepPurple[400] ?? Colors.deepPurple,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$totalPrice грн',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onTap(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[400],
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Продовжити',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

