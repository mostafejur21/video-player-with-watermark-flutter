import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_watermark/presentation/widgets/better_overlay.dart';
import 'package:video_player_watermark/presentation/widgets/custom_video_controls.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideoPlayer({super.key, required this.videoPlayerController});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  Size playerSize = Size.zero;
  double offsetX = 0.0;
  double offsetY = 0.0;

  @override
  void initState() {
    super.initState();
    // Force landscape orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlayerSize();
    });
    debugPrint('FullScreenVideoPlayer initialized');
  }

  void _updatePlayerSize() {
    if (!mounted) return;
    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;

    // Use the video's actual aspect ratio
    double videoAspectRatio = 16 / 9; // Default fallback
    if (widget.videoPlayerController.value.isInitialized) {
      videoAspectRatio = widget.videoPlayerController.value.aspectRatio;
    }

    double width, height;
    if (screenAspectRatio > videoAspectRatio) {
      height = screenSize.height;
      width = height * videoAspectRatio;
      offsetX = (screenSize.width - width) / 2;
      offsetY = 0.0;
    } else {
      width = screenSize.width;
      height = width / videoAspectRatio;
      offsetX = 0.0;
      offsetY = (screenSize.height - height) / 2;
    }

    if (mounted) {
      setState(() {
        playerSize = Size(width, height);
        debugPrint(
          'FullScreen: playerSize=$playerSize, offsetX=$offsetX, offsetY=$offsetY, videoAspectRatio=$videoAspectRatio',
        );
      });
    }
  }

  void _exitFullScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updatePlayerSize();
          });
          debugPrint('FullScreen build: constraints=$constraints');

          // Get the video's aspect ratio
          double aspectRatio = 16 / 9; // Default fallback
          if (widget.videoPlayerController.value.isInitialized) {
            aspectRatio = widget.videoPlayerController.value.aspectRatio;
          }

          return Stack(
            children: [
              // Video player
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: widget.videoPlayerController.value.size.width,
                      height: widget.videoPlayerController.value.size.height,
                      child: VideoPlayer(widget.videoPlayerController),
                    ),
                  ),
                ),
              ),

              // Custom controls with smaller icons
              CustomVideoControls(
                controller: widget.videoPlayerController,
                onFullScreen: _exitFullScreen,
                showFullScreenButton: true,
                isFullScreen: true,
                iconSize: 12.sp, // Reduced from 24.sp
                fontSize: 10.sp,
              ),

              // Bouncing overlay (only in fullscreen as a separate screen)
              if (playerSize.width > 0 && playerSize.height > 0)
                BouncingOverlay(
                  playerWidth: playerSize.width,
                  playerHeight: playerSize.height,
                  offsetX: offsetX,
                  offsetY: offsetY,
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Note: Don't dispose videoPlayerController, as it's managed by VideoPlayerWidget
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    debugPrint('FullScreenVideoPlayer disposed');
    super.dispose();
  }
}
