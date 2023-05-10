import 'package:cinema_app/data/models/movie.dart';
import 'package:cinema_app/data/models/session.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_bloc.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_event.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_state.dart';
import 'package:cinema_app/presentation/pages/seat_selection_page.dart';
import 'package:cinema_app/presentation/widgets/custom_appbar.dart';
import 'package:cinema_app/presentation/widgets/movie_image.dart';
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

class TextLineTimeWidget extends StatelessWidget {
  final Movie movie;
  final Session session;

  const TextLineTimeWidget({super.key, required this.session, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(
             session.room.name,
             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
           ),
           Text(
             session.type,
             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
           ),
         ],
       ),
        const Divider(
          color: Color(0xFFD0D0D0),
          thickness: 2,
        ),
        InkWell(
          child: Text(
            DateFormat('HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                    session.date * 1000)),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) =>
                SeatSelectionPage(
                  session: session,
                  movie: movie,
                ),
            ),
            );
          },
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}

class DayNumberWidget extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPressed;

  const DayNumberWidget({
    Key? key,
    required this.date,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEE', 'uk').format(date);
    int dayNumber = date.day;

    return InkWell(
      onTap: onPressed,
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
              dayName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayNumber.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
