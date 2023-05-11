import 'package:cinema_app/features/data/models/user.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final User user;

  UserProfileLoaded({required this.user});
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError({required this.message});
}

class UserProfileUpdated extends UserProfileState {}