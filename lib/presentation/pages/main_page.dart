import 'package:cinema_app/data/datasources/api_client.dart';
import 'package:cinema_app/presentation/blocs/authentication/auth_bloc.dart';
import 'package:cinema_app/presentation/blocs/search/search_bloc.dart';
import 'package:cinema_app/presentation/blocs/user_profile/user_profile_bloc.dart';
import 'package:cinema_app/presentation/navigators/movie_navigator.dart';
import 'package:cinema_app/presentation/navigators/profile_navigator.dart';
import 'package:cinema_app/presentation/navigators/tickets_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: "Фільми",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: "Квитки",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Профіль",
            )
          ],
          selectedItemColor: Colors.deepPurple[400],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      body:SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            BlocProvider(
              create: (BuildContext context) => SearchBloc(apiClient: ApiClient()),
              child: const MoviesNavigator(),
            ),
            //Зробленно для того щоб ця сторінка завжи обновлялась
            KeyedSubtree(
              key: ValueKey<int>(_selectedIndex),
              child: const TicketsNavigator(),
            ),
            MultiBlocProvider(
              providers: [
                BlocProvider<UserProfileBloc>(
                  create: (context) => UserProfileBloc(apiClient: ApiClient()),
                ),
                BlocProvider<AuthBloc>(
                  create: (context) => AuthBloc(apiClient: ApiClient()),
                ),
              ],
              child: const ProfileNavigator(),
            )
          ],
        ),
      ),
    );
  }
}
