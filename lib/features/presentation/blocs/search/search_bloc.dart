import 'package:cinema_app/features/data/datasources/api_client.dart';
import 'package:cinema_app/features/data/datasources/storage.dart';
import 'package:cinema_app/features/data/models/movie.dart';
import 'package:cinema_app/features/presentation/blocs/search/search_event.dart';
import 'package:cinema_app/features/presentation/blocs/search/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiClient apiClient;

  SearchBloc({required this.apiClient}) : super(SearchInitialState()) {
    on<SearchMoviesEvent>(searchMoviesEvent);
    on<ClearSearchResultsEvent>(clearSearchResultsEvent);
  }

  Future<void> searchMoviesEvent(SearchMoviesEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());

    try {
      final accessToken = await Storage.getAccessToken();
      List<Movie> movies = await apiClient.searchMovies(event.query, accessToken!);
      emit(SearchLoadedState(movies));
    } catch (e) {
      emit(SearchErrorState());
    }
  }

  void clearSearchResultsEvent(ClearSearchResultsEvent event, Emitter<SearchState> emit) {
    emit(SearchInitialState());
  }
}