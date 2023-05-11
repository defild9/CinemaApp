import 'package:cinema_app/features/data/models/comment.dart';
import 'package:cinema_app/features/data/models/session.dart';

abstract class MovieSessionsState {}

class MovieSessionsLoading extends MovieSessionsState {}

class MovieSessionsLoaded extends MovieSessionsState {
  final List<Session> sessions;
  final List<Comment> comments;

  MovieSessionsLoaded({required this.sessions, required this.comments});
}

class MovieSessionsError extends MovieSessionsState {
  final String message;

  MovieSessionsError({required this.message});
}