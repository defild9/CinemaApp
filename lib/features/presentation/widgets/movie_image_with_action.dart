import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieImage extends StatelessWidget {
  final String image;
  final String videoUrl;

  const MovieImage({Key? key, required this.image, required this.videoUrl})
      : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          ),
          InkWell(
            onTap: () {
              _launchURL(videoUrl);
            },
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
        ],
      ),
    );
  }
}