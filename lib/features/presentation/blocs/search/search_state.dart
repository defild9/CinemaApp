import 'package:cinema_app/features/data/models/movie.dart';

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<Movie> movies;

  SearchLoadedState(this.movies);
}

class SearchErrorState extends SearchState {}