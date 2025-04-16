import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  final String googleDriveUrl;

  const VideoPlayerPage({super.key, required this.googleDriveUrl});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  String extractVideoId(String url) {
    final regex = RegExp(r'd/([^/]+)');
    final match = regex.firstMatch(url);
    return match != null ? match.group(1)! : '';
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final videoId = extractVideoId(widget.googleDriveUrl);
    final streamableUrl =
        'https://drive.google.com/uc?export=download&id=$videoId';

    _videoPlayerController = VideoPlayerController.network(streamableUrl);
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControlsOnInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      autoInitialize: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prayashee Player")),
      body: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chewie(controller: _chewieController!),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
