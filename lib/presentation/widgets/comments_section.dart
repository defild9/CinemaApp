import 'package:cinema_app/data/models/comment.dart';
import 'package:cinema_app/data/models/movie.dart';
import 'package:cinema_app/presentation/blocs/comment/comment_bloc.dart';
import 'package:cinema_app/presentation/blocs/comment/comment_event.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_bloc.dart';
import 'package:cinema_app/presentation/blocs/movie_sessions/movie_sessions_event.dart';
import 'package:cinema_app/presentation/pages/add_comment_page.dart';
import 'package:cinema_app/presentation/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsSection extends StatefulWidget {
  final List<Comment> comments;
  final Movie movie;

  CommentsSection({Key? key, required this.comments, required this.movie})
      : super(key: key);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  int _numCommentsToShow = 5;

  Future<void> _showDeleteDialog(BuildContext context, int commentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Видалити коментар'),
          content: const Text('Ви дійсно хочете видалити цей коментар?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ні'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Так'),
              onPressed: () {
                context.read<CommentBloc>().add(DeleteCommentEvent(commentId: commentId));
                Navigator.of(context).pop();
                setState(() {
                  widget.comments.removeWhere((comment) => comment.id == commentId);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> commentsToShow =
    widget.comments.take(_numCommentsToShow).toList();

    return Container(
      color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Colors.grey[200],
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Коментарі",
              style: TextStyle(
                fontSize: 24.0,
                height: 36.0 / 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.comments.isEmpty)
            const Text("Поки нихто не написав про цей фільм"),
          ...commentsToShow
              .map((comment) => ListTile(
            leading: CircleAvatar(
              child: Text(comment.author?.substring(0, 1) ?? 'A'),
            ),
            title: Text(
              comment.author ?? "Анонім",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableText(
                  text: comment.content,
                  maxLines: 3,
                ),
                Text(
                  "Оцінка: ${comment.rating}",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            trailing: comment.isMy
                ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteDialog(context, comment.id);
              },
            )
                : null,
          ))
              .toList(),
          if (widget.comments.length > _numCommentsToShow)
            TextButton(
              onPressed: () {
                setState(() {
                  _numCommentsToShow += 5;
                });
              },
              child: const Text('Завантажити ще'),
            ),
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCommentPage(movie: widget.movie),
                ),
              );

              if (result == true) {
                context.read<MovieSessionsBloc>().add(
                  LoadMovieCommentsEvent(movie: widget.movie),
                );
              }
            },
            child: const Text('Написати коментарій'),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}