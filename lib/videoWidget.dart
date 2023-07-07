import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class videoWidget extends StatefulWidget {
  // const videoWidget({Key? key}) : super(key: key);
  final File selectedFile;
  videoWidget(this.selectedFile);
  @override
  State<videoWidget> createState() => _videoWidgetState();
}

class _videoWidgetState extends State<videoWidget> {
  VideoPlayerController? _controller;
  // = VideoPlayerController.file(file)
  @override
  void initState() {
    // print("selectedFile :${widget.selectedFile}");
    _controller = VideoPlayerController.file(widget.selectedFile);
    print("_controller:${_controller!.value.isInitialized}");

    _controller?.addListener(() {
      setState(() {});
    });
    _controller?.initialize().then((_) => setState(() {}));
    _controller?.play();
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: Center(
        child: Container(
          height: mdSize.height * 0.3,
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller!),
                _ControlsOverlay(controller: _controller),
                VideoProgressIndicator(_controller as VideoPlayerController,
                    allowScrubbing: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  // const _ControlsOverlay({Key? key, required this.controller})
  //     : super(key: key);
  _ControlsOverlay({required this.controller});
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  VideoPlayerController? controller;

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller!.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller!.value.isPlaying
                ? controller!.pause()
                : controller!.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller!.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller!.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller!.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
