import 'package:cinema_app/presentation/blocs/search/search_bloc.dart';
import 'package:cinema_app/presentation/blocs/search/search_event.dart';
import 'package:flutter/material.dart';

class CustomAppBarInput extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final SearchBloc searchBloc;

  const CustomAppBarInput({Key? key, required this.searchController, required this.searchBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Пошук фільмів',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          searchBloc.add(SearchMoviesEvent(value));
        },
      ),
      actions: const [],
      backgroundColor: Colors.deepPurple[400],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}