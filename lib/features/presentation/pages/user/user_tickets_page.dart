import 'package:cinema_app/features/presentation/blocs/purchase/purchase_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/purchase/purchase_state.dart';
import 'package:cinema_app/features/presentation/blocs/user_tickets/user_tickets_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/user_tickets/user_tickets_event.dart';
import 'package:cinema_app/features/presentation/widgets/custom_appbar.dart';
import 'package:cinema_app/features/presentation/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTicketsPage extends StatelessWidget {
  const UserTicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserTicketsBloc()..add(FetchTicketsEvent())),
        BlocProvider(create: (context) => PurchaseBloc())
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PurchaseBloc, PurchaseState>(
            listener: (context, state) {
              if (state is PurchaseSuccess) {
                BlocProvider.of<UserTicketsBloc>(context).add(FetchTicketsEvent());
              }
            },
          ),
        ],
        child: BlocBuilder<UserTicketsBloc, UserTicketsState>(
          builder: (context, state) {
            if (state is UserTicketsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserTicketsError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is UserTicketsLoaded) {
              final tickets = state.ticketList.tickets;
              tickets.sort((a, b) => b.date.compareTo(a.date));
              return Scaffold(
                appBar: const CustomAppBar(
                  title: "Мої квитки",
                ),
                body: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: TicketCard(
                        ticket: tickets[index],
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}



