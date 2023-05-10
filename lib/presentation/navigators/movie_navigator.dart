import 'package:cinema_app/presentation/pages/movies_page.dart';
import 'package:flutter/material.dart';

class MoviesNavigator extends StatelessWidget {
  const MoviesNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
            builder: (BuildContext context) {
              return MoviesPage();
            }
        );
      },
    );
  }
}
