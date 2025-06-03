import 'package:flutter/material.dart';
import 'package:video_player_watermark/presentation/widgets/video_player_widget.dart';

class WatermarkedVideoPlayer extends StatefulWidget {
  const WatermarkedVideoPlayer({super.key});

  @override
  State<WatermarkedVideoPlayer> createState() => _WatermarkedVideoPlayerState();
}

class _WatermarkedVideoPlayerState extends State<WatermarkedVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const VideoPlayerWidget(
          videoUrl:
              'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
        ),
      ),
    );
  }
}
