import 'dart:ui';

import 'package:cinema_app/features/data/models/movie.dart';
import 'package:cinema_app/features/presentation/blocs/movie_sessions/movie_sessions_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/movie_sessions/movie_sessions_event.dart';
import 'package:cinema_app/features/presentation/blocs/movie_sessions/movie_sessions_state.dart';
import 'package:cinema_app/features/presentation/pages/movie/movie_sessions_page.dart';
import 'package:cinema_app/features/presentation/widgets/comments_section.dart';
import 'package:cinema_app/features/presentation/widgets/expandable_text.dart';
import 'package:cinema_app/features/presentation/widgets/movie_image_with_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';


class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Future<void> share() async {
    await Share.share(
      'https://fs-mt.qwerty123.tech/movies/${widget.movie.id}',
      subject: widget.movie.name!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MovieSessionsBloc()
        ..add(
          LoadMovieSessionsEvent(
              movie: widget.movie, selectedDate: DateTime.now()),
        )
        ..add(
          LoadMovieCommentsEvent(movie: widget.movie),
        ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.movie.name ?? 'Не визначено',
          onTap: () => share(),
        ),
        body: Stack(
          children: [
            BlocBuilder<MovieSessionsBloc, MovieSessionsState>(
              builder: (context, state) {
                if (state is MovieSessionsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieSessionsError) {
                  return Center(child: Text(state.message));
                } else if (state is MovieSessionsLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        MovieImage(
                          image: widget.movie.image!,
                          videoUrl: widget.movie.trailer!,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.movie.name!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 24.0,
                                      height: 36.0 / 24.0,
                                      fontWeight: FontWeight.bold
                                      // fontFamily: 'Poppins',
                                      ),
                                ),
                              ),
                              ExpandableText(
                                text: widget.movie.plot!,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Орігнальна назва",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.originalName!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Рік",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${widget.movie.year}",
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Режисер",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.director!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Мова",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.language!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Орігнальна назва",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.originalName!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Вік",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${widget.movie.year}+",
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Виробництво",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.country!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Сценарій",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.screenwriter!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Режисер",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.director!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "У головних ролях",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            height: 28.0 / 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.movie.starring!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF8F8585),
                                          height: 21.0 / 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CommentsSection(
                          comments: state.comments,
                          movie: widget.movie,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).bottomNavigationBarTheme.backgroundColor : Colors.white,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurple[400]!)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieSessionsPage(
                            movie: widget.movie,
                          ),
                        ));
                  },
                  child: const Text("Сеанси"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function() onTap;

  const CustomAppBar({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: FittedBox(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.ios_share, color: Colors.white),
          onPressed: onTap,
        ),
      ],
      backgroundColor: Colors.deepPurple[400],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
