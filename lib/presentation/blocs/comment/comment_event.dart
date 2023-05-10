import 'package:cinema_app/data/models/movie.dart';

abstract class CommentEvent {}

class PostCommentEvent extends CommentEvent {
  final Movie movie;
  final String comment;
  final int rating;

  PostCommentEvent({required this.movie, required this.comment, required this.rating});
}

class DeleteCommentEvent extends CommentEvent {
  final int commentId;

  DeleteCommentEvent({required this.commentId});
}

