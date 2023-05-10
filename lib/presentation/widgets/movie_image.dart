import 'dart:ui';

import 'package:flutter/material.dart';

class MovieImage extends StatelessWidget {
  final String image;

  const MovieImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            image,
            fit: BoxFit.cover,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                alignment: Alignment.center,
                child: Image.network(image),
              ),
            ),
          )
        ],
      ),
    );
  }
}
