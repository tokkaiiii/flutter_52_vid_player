import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: video != null
          ? _VideoPlayer(
              video: video!,
              onAnotherVideoPicked: onLogoTap,
            )
          : _VideoSelector(
              textTheme: textTheme,
              onLogoTap: onLogoTap,
            ),
    );
  }

  void onLogoTap() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    setState(() {
      this.video = video;
    });
  }
}

class _VideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onAnotherVideoPicked;

  const _VideoPlayer({
    required this.video,
    required this.onAnotherVideoPicked,
    super.key,
  });

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController videoPlayerController;
  bool showIcons = true;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  @override
  void didUpdateWidget(covariant _VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.video.path != widget.video.path){
      initializeController();
    }
  }

  initializeController() async {
    videoPlayerController = VideoPlayerController.file(
      File(
        widget.video.path,
      ),
    );
    await videoPlayerController.initialize();
    videoPlayerController.addListener(
      () {
        setState(() {});
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          showIcons = !showIcons;
        });
      },
      child: Center(
          child: AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(
                  videoPlayerController,
                ),
                if(showIcons)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withAlpha(128),
                ),
                if (showIcons)
                _PlayButton(
                  onReversePressed: onReversePressed,
                  onPlayPressed: onPlayPressed,
                  onForwardPressed: onForwardPressed,
                ),
                _Bottom(
                  position: videoPlayerController.value.position,
                  maxPosition: videoPlayerController.value.duration,
                  onSliderChanged: onSliderChanged,
                ),
                if(showIcons)
                _PickAnotherVideo(
                  onPressed: widget.onAnotherVideoPicked,
                ),
              ],
            ),
          ),
        ),
    );
  }

  void onSliderChanged(double val) {
    final position = Duration(seconds: val.toInt());
    videoPlayerController.seekTo(position);
  }

  void onReversePressed() {
    final currentPosition = videoPlayerController.value.position;

    Duration position = Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoPlayerController.seekTo(position);
  }

  void onPlayPressed() {
    setState(() {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
      } else {
        videoPlayerController.play();
      }
    });
  }

  void onForwardPressed() {
    final maxPosition = videoPlayerController.value.duration;
    final currentPosition = videoPlayerController.value.position;

    Duration position = maxPosition;
    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoPlayerController.seekTo(position);
  }
}

class _PickAnotherVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const _PickAnotherVideo({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          color: Colors.white,
          Icons.photo_camera_back,
        ),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final Duration position;
  final Duration maxPosition;
  final ValueChanged<double> onSliderChanged;

  const _Bottom({
    required this.position,
    required this.maxPosition,
    required this.onSliderChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: [
            Text(
              '${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
            Expanded(
              child: Slider(
                value: position.inSeconds.toDouble(),
                max: maxPosition.inSeconds.toDouble(),
                onChanged: onSliderChanged,
              ),
            ),
            Text(
              '${maxPosition.inMinutes.toString().padLeft(2, '0')}:${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onReversePressed;
  final VoidCallback onPlayPressed;
  final VoidCallback onForwardPressed;

  const _PlayButton({
    required this.onReversePressed,
    required this.onPlayPressed,
    required this.onForwardPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: onReversePressed,
            icon: Icon(Icons.rotate_left),
            color: Colors.white,
          ),
          IconButton(
            onPressed: onPlayPressed,
            icon: Icon(Icons.play_arrow),
            color: Colors.white,
          ),
          IconButton(
            onPressed: onForwardPressed,
            icon: Icon(Icons.rotate_right),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _VideoSelector extends StatelessWidget {
  final VoidCallback onLogoTap;
  final TextTheme textTheme;

  const _VideoSelector({
    required this.textTheme,
    required this.onLogoTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Logo(
          onTap: onLogoTap,
        ),
        SizedBox(
          height: 16.0,
        ),
        _Title(
          textTheme: textTheme,
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'asset/image/log.png',
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final TextTheme textTheme;

  const _Title({
    required this.textTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '52',
          style: textTheme.displayLarge,
        ),
        Text(
          'log',
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
