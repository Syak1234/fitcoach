import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerWrapper extends StatefulWidget {
  final String url;

  const VideoPlayerWrapper({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlayerWrapper> createState() => _VideoPlayerWrapperState();
}

class _VideoPlayerWrapperState extends State<VideoPlayerWrapper> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    player.open(Media(widget.url), play: false);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Video(
        controller: controller,
        controls: (state) {
          return Stack(
            children: [
              // Centered Play/Pause button
              Center(
                child: IconButton(
                  onPressed: () {
                    state.widget.controller.player.playOrPause();
                  },
                  icon: StreamBuilder<bool>(
                    stream: state.widget.controller.player.stream.playing,
                    builder: (context, playing) {
                      bool isPlaying = playing.data ?? false;
                      return Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.backgroundLight,
                        size: 48,
                      );
                    },
                  ),
                ),
              ),

              // Fullscreen button positioned bottom right
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    state.widget.controller.player.pause();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(
                          documentUrl: widget.url,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    color: AppColors.backgroundLight,
                    size: 30,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String documentUrl;

  const VideoPlayerScreen({Key? key, required this.documentUrl})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final Player _player;
  late final VideoController _videoController;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _videoController = VideoController(_player);

    _player.open(Media(widget.documentUrl));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: AppColors.backgroundDark,
          iconTheme: IconThemeData(color: AppColors.textLight),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined)),
          ),
        ),
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Video(controller: _videoController),
          ),
        ),
      ),
    );
  }
}
