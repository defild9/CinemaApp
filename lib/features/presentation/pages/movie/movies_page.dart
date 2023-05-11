import 'package:cinema_app/features/data/datasources/api_client.dart';
import 'package:cinema_app/features/presentation/blocs/movie_sessions/movie_sessions_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/movies/movie_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/movies/movie_event.dart';
import 'package:cinema_app/features/presentation/blocs/movies/movie_state.dart';
import 'package:cinema_app/features/presentation/pages/main/search_page.dart';
import 'package:cinema_app/features/presentation/pages/movie/movie_detail_page.dart';
import 'package:cinema_app/features/presentation/widgets/custom_appbar_with_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class MoviesPage extends StatelessWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider<MoviesBloc>(
          create: (context) => MoviesBloc(apiClient: ApiClient())..add(LoadMovies()),
        ),
        BlocProvider<MovieSessionsBloc>(
          create: (context) => MovieSessionsBloc(),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBarAction(
          title: 'Фільми',
          onProfileTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchPage(),
            ));
          },
        ),
        body: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state){
            if (state is MoviesLoading){
              return const Center(child: CircularProgressIndicator());
            }
            else if (state is MoviesError){
              return Center(child: Text(state.message));
            }
            else if (state is MoviesLoaded){
              final movies = state.movies;
              return PageView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index){
                  return InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                movie: movies[index],
                              ),
                            )
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              movies[index].image!,
                              fit: BoxFit.fill,
                            ),
                          ),
                      )
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}







