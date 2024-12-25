import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
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
      ),
    );
  }

  void onLogoTap() {
    ImagePicker().pickVideo(
      source: ImageSource.gallery,
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
