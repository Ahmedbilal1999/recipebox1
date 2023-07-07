import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class splashScreeen extends StatefulWidget {
  const splashScreeen({Key? key}) : super(key: key);

  @override
  State<splashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<splashScreeen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/Beige Modern Food Logo.gif')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _isVideoInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            Container(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'Recipe Box',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    backgroundColor: Colors.deepOrange,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
