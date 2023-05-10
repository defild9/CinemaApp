abstract class SearchEvent {}

class SearchMoviesEvent extends SearchEvent {
  final String query;

  SearchMoviesEvent(this.query);
}
class ClearSearchResultsEvent extends SearchEvent {}