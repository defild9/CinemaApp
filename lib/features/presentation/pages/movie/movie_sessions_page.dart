import 'package:cinema_app/features/data/models/movie.dart';
import 'package:cinema_app/features/data/models/session.dart';
import 'package:cinema_app/features/presentation/blocs/movie_sessions/movie_sessions_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/movie_sessions/movie_sessions_event.dart';
import 'package:cinema_app/features/presentation/blocs/movie_sessions/movie_sessions_state.dart';
import 'package:cinema_app/features/presentation/pages/book_and_purchase/seat_selection_page.dart';
import 'package:cinema_app/features/presentation/widgets/custom_appbar.dart';
import 'package:cinema_app/features/presentation/widgets/movie_image.dart';
import 'package:cinema_app/features/presentation/widgets/text_line_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MovieSessionsPage extends StatefulWidget {
  final Movie movie;

  const MovieSessionsPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieSessionsPage> createState() => _MovieSessionsPageState();
}

class _MovieSessionsPageState extends State<MovieSessionsPage> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _availableDates = [];

  @override
  void initState() {
    super.initState();
    _selectedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    _availableDates =
        List<DateTime>.generate(9, (i) => _selectedDate.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MovieSessionsBloc()
        ..add(
          LoadMovieSessionsEvent(
              movie: widget.movie, selectedDate: _selectedDate),
        ),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Розклад сеансів",
        ),
        body: BlocBuilder<MovieSessionsBloc, MovieSessionsState>(
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
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.movie.name!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                itemCount: _availableDates.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  DateTime date = _availableDates[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedDate = date;
                                        });
                                        context.read<MovieSessionsBloc>().add(LoadMovieSessionsEvent(
                                            movie: widget.movie, selectedDate: _selectedDate));
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('EEE', 'uk').format(date),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              date.day.toString(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 40,),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.sessions.length,
                              itemBuilder: (context, index) {
                                final session = state.sessions[index];
                                return TextLineTimeWidget(
                                  session: session,
                                  movie: widget.movie,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}


