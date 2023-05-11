import 'package:cinema_app/features/data/models/movie.dart';
import 'package:cinema_app/features/presentation/blocs/search/search_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/search/search_event.dart';
import 'package:cinema_app/features/presentation/blocs/search/search_state.dart';
import 'package:cinema_app/features/presentation/pages/movie/movie_detail_page.dart';
import 'package:cinema_app/features/presentation/widgets/custom_appbar_with_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBloc _searchBloc;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
  }

  @override
  void dispose() {
    _searchBloc.add(ClearSearchResultsEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarInput(
        searchController: _searchController,
        searchBloc: _searchBloc,
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitialState) {
            return const Center(
              child: Text(
                'Введіть назву фільму',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else if (state is SearchLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoadedState) {
            if (state.movies.isEmpty) {
              return const Center(
                child: Text(
                  'Нічого не знайдено',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                Movie movie = state.movies[index];
                return ListTile(
                  leading: Image.network(movie.smallImage!),
                  title: Text(movie.name!),
                  subtitle: Text('${movie.year} · ${movie.genre}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            movie: movie,
                          ),
                        )
                    );
                  },
                );
              },
            );
          } else if (state is SearchErrorState) {
            return const Center(
              child: Text(
                'Помилка при пошуку фільмів',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}