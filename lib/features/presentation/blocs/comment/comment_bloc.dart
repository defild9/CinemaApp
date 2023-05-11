import 'package:cinema_app/features/data/datasources/api_client.dart';
import 'package:cinema_app/features/data/datasources/storage.dart';
import 'package:cinema_app/features/presentation/blocs/comment/comment_event.dart';
import 'package:cinema_app/features/presentation/blocs/comment/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentInitial()) {
    on<PostCommentEvent>(postCommentEvent);
    on<DeleteCommentEvent>(deleteCommentEvent);
  }

  Future<void> postCommentEvent(PostCommentEvent event, Emitter<CommentState> emit) async {
    emit(CommentPosting());
    try {
      final accessToken = await Storage.getAccessToken();
      final result = await ApiClient().postMovieComment(
        accessToken!,
        event.movie.id!,
        event.comment,
        event.rating,
      );
      if (result) {
        emit(CommentPosted());
      } else {
        emit(CommentError(message: 'Failed to post comment'));
      }
    } catch (e) {
      emit(CommentError(message: e.toString()));
    }
  }

  Future<void> deleteCommentEvent(DeleteCommentEvent event, Emitter<CommentState> emit) async {
    emit(CommentDeleting());
    try {
      final accessToken = await Storage.getAccessToken();
      final result = await ApiClient().deleteMovieComment(
        accessToken!,
        event.commentId,
      );
      if (result) {
        emit(CommentDeleted());
      } else {
        emit(CommentError(message: 'Failed to delete comment'));
      }
    } catch (e) {
      emit(CommentError(message: e.toString()));
    }
  }
}
