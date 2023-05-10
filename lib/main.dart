import 'package:cinema_app/data/datasources/api_client.dart';
import 'package:cinema_app/presentation/blocs/authentication/auth_state.dart';
import 'package:cinema_app/presentation/blocs/comment/comment_bloc.dart';
import 'package:cinema_app/presentation/blocs/theme/theme_bloc.dart';
import 'package:cinema_app/presentation/blocs/theme/theme_state.dart';
import 'package:cinema_app/presentation/pages/authentication_page.dart';
import 'package:cinema_app/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'presentation/blocs/authentication/auth_bloc.dart';
import 'presentation/blocs/authentication/auth_event.dart';
import 'presentation/blocs/movie_sessions/movie_sessions_bloc.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uk', null);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MovieSessionsBloc>(
          create: (context) => MovieSessionsBloc(),
          child: MyApp(),
        ),
        BlocProvider<CommentBloc>(
          create: (BuildContext context) => CommentBloc(),
        )
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            final authBloc = AuthBloc(apiClient: apiClient);
            authBloc.add(AuthEvent.checkForStoredToken);
            return authBloc;
          },
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeState is ThemeLoadSuccess ? themeState.themeData : ThemeData.light(),
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthAuthenticated) {
                  return MainPage();
                } else {
                  return AuthenticationPage();
                }
              },
            ),
          );
        },
      ),
    );
  }
}


