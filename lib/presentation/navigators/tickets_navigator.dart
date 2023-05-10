import 'package:cinema_app/presentation/pages/user_tickets_page.dart';
import 'package:flutter/material.dart';

class TicketsNavigator extends StatelessWidget {
  const TicketsNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return UserTicketsPage();
            }
        );
      },
    );
  }
}