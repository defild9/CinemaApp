import 'package:cinema_app/data/datasources/api_client.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_bloc.dart';
import 'package:cinema_app/presentation/blocs/movies/movie_bloc.dart';
import 'package:cinema_app/presentation/blocs/movies/movie_event.dart';
import 'package:cinema_app/presentation/blocs/movies/movie_state.dart';
import 'package:cinema_app/presentation/pages/movie_detail_page.dart';
import 'package:cinema_app/presentation/pages/movie_sessions_page.dart';
import 'package:cinema_app/presentation/pages/search_page.dart';
import 'package:cinema_app/presentation/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema_app/presentation/widgets/custom_appbar_with_action.dart';

// class MoviesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<MoviesBloc>(
//           create: (context) => MoviesBloc(apiClient: ApiClient())..add(LoadMovies()),
//         ),
//         BlocProvider<MovieSessionsBloc>(
//           create: (context) => MovieSessionsBloc(),
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Фільми'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.account_circle),
//               onPressed: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => UserProfilePage(),
//                 ));
//               },
//             ),
//           ],
//         ),
//         body: BlocBuilder<MoviesBloc, MoviesState>(
//           builder: (context, state) {
//             if (state is MoviesLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is MoviesError) {
//               return Center(child: Text(state.message));
//             } else if (state is MoviesLoaded) {
//               final movies = state.movies;
//               return ListView.builder(
//                 itemCount: movies.length,
//                 itemBuilder: (context, index) {
//                   final movie = movies[index];
//                   return ListTile(
//                     leading: Image.network(movie.image!),
//                     title: Text(movie.name!),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => MovieSessionsPage(
//                             movie: movie,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//     );
//   }
// }

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


// class MoviesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<MoviesBloc>(
//           create: (context) => MoviesBloc(apiClient: ApiClient())..add(LoadMovies()),
//         ),
//         BlocProvider<MovieSessionsBloc>(
//           create: (context) => MovieSessionsBloc(),
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Films"),
//         ),
//         body: BlocBuilder<MoviesBloc, MoviesState>(
//           builder: (context, state) {
//             if (state is MoviesLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is MoviesError) {
//               return Center(child: Text(state.message));
//             } else if (state is MoviesLoaded) {
//               final movies = state.movies;
//               return Padding(
//                 padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
//                 child: PageView.builder(
//                   itemCount: movies.length,
//                   itemBuilder: (context, index) {
//                     final movie = movies[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MovieSessionsPage(
//                               movie: movie,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Stack(
//                         children: [
//                           Material(
//                             elevation: 8.0,
//                             borderRadius: BorderRadius.circular(20.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(20.0),
//                               child: Image.network(
//                                 movie.image!,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//     );
//   }
// }






