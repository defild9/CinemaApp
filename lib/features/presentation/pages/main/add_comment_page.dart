import 'package:cinema_app/features/data/models/movie.dart';
import 'package:cinema_app/features/presentation/blocs/comment/comment_bloc.dart';
import 'package:cinema_app/features/presentation/blocs/comment/comment_event.dart';
import 'package:cinema_app/features/presentation/blocs/comment/comment_state.dart';
import 'package:cinema_app/features/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentPage extends StatefulWidget {
  final Movie movie;

  const AddCommentPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  late TextEditingController _commentController;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _rating = 1;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentBloc(),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Написати коментар',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<CommentBloc, CommentState>(
            listener: (context, state) {
              if (state is CommentPosted) {
                Navigator.pop(context, true);
              } else if (state is CommentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                 Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.1),
                         spreadRadius: 1,
                         blurRadius: 3,
                         offset: const Offset(0, 2),
                       ),
                     ],
                   ),
                   child: TextField(
                     cursorColor: Colors.deepPurple[400] ?? Colors.deepPurple,
                     controller: _commentController,
                     decoration: InputDecoration(
                       labelText: 'Коментар',
                       labelStyle: TextStyle(color: Colors.deepPurple[400]),
                       border: OutlineInputBorder(
                         borderSide: BorderSide(
                             color: Colors.deepPurple[400] ?? Colors.deepPurple),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(
                             color: Colors.deepPurple[400] ?? Colors.deepPurple),
                       ),
                     ),
                     minLines: 3,
                     maxLines: 5,
                   ),
                 ),
                  const SizedBox(height: 10),
                  DropdownButton<int>(
                    value: _rating,
                    items: List.generate(5, (i) => i + 1).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _rating = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  state is CommentPosting
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            context.read<CommentBloc>().add(PostCommentEvent(
                                  movie: widget.movie,
                                  comment: _commentController.text,
                                  rating: _rating,
                                ));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.deepPurple[400]),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          child: Container(
                            width: 320,
                            height: 30,
                            alignment: Alignment.center,
                            child: const Text(
                              'Відправити',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
