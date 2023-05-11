import 'package:cinema_app/features/presentation/pages/user/user_profile_page.dart';
import 'package:flutter/material.dart';

class ProfileNavigator extends StatelessWidget {
  const ProfileNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return UserProfilePage();
            }
        );
      },
    );
  }
}