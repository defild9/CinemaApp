abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentPosting extends CommentState {}

class CommentPosted extends CommentState {}

class CommentDeleting extends CommentState {}

class CommentDeleted extends CommentState {}

class CommentError extends CommentState {
  final String message;

  CommentError({required this.message});
}