import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_watermark/presentation/widgets/better_overlay.dart';
import 'package:video_player_watermark/presentation/widgets/custom_video_controls.dart';
import 'package:video_player_watermark/presentation/widgets/full_screen_video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  final GlobalKey _videoKey = GlobalKey();
  Size playerSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlayerSize();
    });
  }

  void _initializePlayer() {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl), formatHint: VideoFormat.hls);

    _videoPlayerController
        .initialize()
        .then((_) {
          if (mounted) {
            setState(() {});
            debugPrint('VideoPlayer initialized: ${widget.videoUrl}');
          }
        })
        .catchError((error) {
          debugPrint('HLS initialization error: $error');
        });
  }

  void _updatePlayerSize() {
    if (!mounted) return;
    final RenderBox? renderBox = _videoKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      setState(() {
        playerSize = renderBox.size;
        debugPrint('Updated playerSize (normal): $playerSize');
      });
    }
  }

  void _enterFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullScreenVideoPlayer(videoPlayerController: _videoPlayerController)),
    ).then((_) {
      // Reset orientation when returning from fullscreen
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePlayerSize();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updatePlayerSize();
          });
          debugPrint('VideoPlayer build: constraints=$constraints');

          // Get the video's aspect ratio, fallback to 16:9 if not available
          double aspectRatio = 16 / 9; // Default fallback
          if (_videoPlayerController.value.isInitialized) {
            aspectRatio = _videoPlayerController.value.aspectRatio;
          }

          return Stack(
            children: [
              // Video player with proper aspect ratio fitting
              Center(
                child: _videoPlayerController.value.isInitialized
                    ? AspectRatio(key: _videoKey, aspectRatio: aspectRatio, child: VideoPlayer(_videoPlayerController))
                    : const CircularProgressIndicator.adaptive(),
              ),

              // Custom controls
              if (_videoPlayerController.value.isInitialized)
                CustomVideoControls(
                  controller: _videoPlayerController,
                  onFullScreen: _enterFullScreen,
                  showFullScreenButton: true,
                  isFullScreen: false,
                  iconSize: 16.sp,
                  fontSize: 10.sp,
                ),

              // Bouncing overlay
              if (playerSize.width > 0 && playerSize.height > 0)
                BouncingOverlay(playerWidth: playerSize.width, playerHeight: playerSize.height),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    debugPrint('VideoPlayerWidget disposed');
    super.dispose();
  }
}
