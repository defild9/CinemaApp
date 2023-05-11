import 'package:cinema_app/features/data/datasources/api_client.dart';
import 'package:cinema_app/features/data/datasources/storage.dart';
import 'package:cinema_app/features/presentation/blocs/movies/movie_event.dart';
import 'package:cinema_app/features/presentation/blocs/movies/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final ApiClient apiClient;

  MoviesBloc({required this.apiClient}) : super(MoviesInitial()) {
    on<LoadMovies>(_loadMovies);
  }

  Future<void> _loadMovies(LoadMovies event, Emitter<MoviesState> emit) async {
    emit(MoviesLoading());
    try {
      final accessToken = await Storage.getAccessToken();
      final movies = await apiClient.getMovies(accessToken!);
      emit(MoviesLoaded(movies: movies));
    } catch (e) {
      emit(MoviesError(message: 'Помилка завантаження фільмів'));
    }
  }
}


