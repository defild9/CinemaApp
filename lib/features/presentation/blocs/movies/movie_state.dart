import 'package:cinema_app/features/data/models/movie.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;

  MoviesLoaded({required this.movies});
}

class MoviesError extends MoviesState {
  final String message;

  MoviesError({required this.message});
}