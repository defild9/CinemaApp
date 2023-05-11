import 'package:cinema_app/features/data/models/movie.dart';

abstract class MovieSessionsEvent {}

class LoadMovieSessionsEvent extends MovieSessionsEvent {
  final Movie movie;
  final DateTime selectedDate;

  LoadMovieSessionsEvent({required this.movie, required this.selectedDate});
}

class LoadMovieCommentsEvent extends MovieSessionsEvent {
  final Movie movie;

  LoadMovieCommentsEvent({required this.movie});
}