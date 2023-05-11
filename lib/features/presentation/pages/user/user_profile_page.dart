import 'package:cinema_app/features/presentation/blocs/authentication/auth_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/authentication/auth_event.dart';
import 'package:cinema_app/features/presentation/blocs/theme/theme_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/theme/theme_event.dart';
import 'package:cinema_app/features/presentation/blocs/theme/theme_state.dart';
import 'package:cinema_app/features/presentation/blocs/user_profile/user_profile_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/user_profile/user_profile_event.dart';
import 'package:cinema_app/features/presentation/blocs/user_profile/user_profile_state.dart';
import 'package:cinema_app/features/presentation/pages/user/user_settings_page.dart';
import 'package:cinema_app/features/presentation/pages/user/user_tickets_page.dart';
import 'package:cinema_app/features/presentation/widgets/custom_appbar.dart';
import 'package:cinema_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}


class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfileBloc _userProfileBloc;

  @override
  void initState() {
    super.initState();
    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _userProfileBloc.add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Профіль',
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is UserProfileUpdated) {
            context.read<UserProfileBloc>().add(LoadUserProfile());
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const CircularProgressIndicator();
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple[400],
                            radius: 50,
                            child: user.name == null
                                ? const Text(
                              'K',
                              style: TextStyle(fontSize: 24.0, color: Colors.white),
                            )
                                : Text(
                              user.name!.substring(0, 1).toUpperCase(),
                              style: const TextStyle(fontSize: 24.0, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 15),
                          FittedBox(
                            child: Text(
                              user.name ?? 'Користувач',
                              style: const TextStyle(fontSize: 24.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                            if (context.read<ThemeBloc>().state is ThemeLoadSuccess) {
                              bool currentTheme = (context.read<ThemeBloc>().state as ThemeLoadSuccess).isDarkTheme;
                              context.read<ThemeBloc>().add(ThemeChanged(isDarkTheme: !currentTheme));
                            }
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
                                child:  Row(
                                  children: [
                                    Icon(
                                      Icons.brightness_6,
                                      color: Colors.deepPurple[400],
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text(
                                      'Змінити тему',
                                      style: TextStyle(
                                          fontSize: 22.0
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                height: 2,
                                color: Colors.deepPurple[400],
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const UserTicketsPage(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
                                child:  Row(
                                  children: [
                                    Icon(
                                      Icons.confirmation_number,
                                      color: Colors.deepPurple[400],
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text(
                                      'Мої квитки',
                                      style: TextStyle(
                                          fontSize: 22.0
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                height: 2,
                                color: Colors.deepPurple[400],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserSettingPage(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
                                child:  Row(
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      color: Colors.deepPurple[400],
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text(
                                      'Налаштування',
                                      style: TextStyle(
                                          fontSize: 22.0
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                height: 2,
                                color: Colors.deepPurple[400],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            context.read<AuthBloc>().add(AuthEvent.logOut);
                            Navigator.of(context, rootNavigator: true).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
                                child:  Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.deepPurple[400],
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text(
                                      'Вихід',
                                      style: TextStyle(
                                          fontSize: 22.0
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                height: 2,
                                color: Colors.deepPurple[400],
                              ),
                            ],
                          ),
                        ),

                      ],
                    )
                  ],
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









