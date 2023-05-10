import 'package:cinema_app/data/datasources/api_client.dart';
import 'package:cinema_app/data/datasources/storage.dart';
import 'package:cinema_app/data/models/comment.dart';
import 'package:cinema_app/data/models/session.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_event.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MovieSessionsBloc extends Bloc<MovieSessionsEvent, MovieSessionsState> {
  List<Session> _sessions = [];
  List<Comment> _comments = [];

  MovieSessionsBloc() : super(MovieSessionsLoading()) {
    on<LoadMovieSessionsEvent>(_loadMovieSessions);
    on<LoadMovieCommentsEvent>(_loadMovieComments);
  }

  Future<void> _loadMovieSessions(
      LoadMovieSessionsEvent event, Emitter<MovieSessionsState> emit) async {
    emit(MovieSessionsLoading());
    try {
      final accessToken = await Storage.getAccessToken();
      final formatter = DateFormat('yyyy-MM-dd');
      final formattedDate = formatter.format(event.selectedDate);
      final sessions = await ApiClient()
          .getMovieSessions(accessToken!, event.movie.id!, formattedDate);
      sessions.sort((a, b) => a.date.compareTo(b.date));
      _sessions = sessions;
      emit(MovieSessionsLoaded(sessions: _sessions, comments: _comments));
    } catch (e) {
      emit(MovieSessionsError(message: e.toString()));
    }
  }

  Future<void> _loadMovieComments(
      LoadMovieCommentsEvent event, Emitter<MovieSessionsState> emit) async {
    emit(MovieSessionsLoading());
    try {
      final accessToken = await Storage.getAccessToken();
      final comments =
      await ApiClient().getMovieComments(accessToken!, event.movie.id!);
      _comments = comments;
      emit(MovieSessionsLoaded(sessions: _sessions, comments: _comments));
    } catch (e) {
      emit(MovieSessionsError(message: e.toString()));
    }
  }
}

