import 'package:flutter/material.dart';
import 'package:online_training_template/models/video_model.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerSection extends StatefulWidget {
  final VideoModel video;

  const VideoPlayerSection({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  _VideoPlayerSectionState createState() => _VideoPlayerSectionState();
}

class _VideoPlayerSectionState extends State<VideoPlayerSection> {
  late VideoPlayerController _videoPlayerController;
  bool _isFullScreen = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final directUrl = _convertToDirectUrl(widget.video.youtube_url);

      _videoPlayerController = VideoPlayerController.network(directUrl)
        ..addListener(() {
          if (_videoPlayerController.value.hasError) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        })
        ..initialize().then((_) {
          setState(() {
            _isLoading = false;
          });
          _videoPlayerController.play();
        });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _convertToDirectUrl(String googleDriveUrl) {
    if (googleDriveUrl.contains('drive.google.com')) {
      final fileId = googleDriveUrl.split('/d/')[1].split('/')[0];
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
    return googleDriveUrl;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Text(widget.video.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
      body: _isFullScreen ? _buildFullScreenPlayer() : _buildPortraitLayout(),
    );
  }

  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildVideoPlayerContent(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                if (widget.video.description.isNotEmpty)
                  Text(
                    widget.video.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                const SizedBox(height: 16),
                _buildMetadataSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerContent() {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              const Text(
                'Failed to load video',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: initializePlayer,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        VideoPlayer(_videoPlayerController),
        VideoProgressIndicator(
          _videoPlayerController,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.blueAccent,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.black12,
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: FloatingActionButton.small(
            backgroundColor: Colors.black.withOpacity(0.5),
            onPressed: () {
              setState(() {
                _videoPlayerController.value.isPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
              });
            },
            child: Icon(
              _videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataSection() {
    return Column(
      children: [
        _buildMetadataRow(Icons.info_outline, widget.video.description),
      ],
    );
  }

  Widget _buildMetadataRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return WillPopScope(
      onWillPop: () async {
        _toggleFullScreen();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(child: _buildVideoPlayerContent()),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _toggleFullScreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
