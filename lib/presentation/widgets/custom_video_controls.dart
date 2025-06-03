// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_watermark/presentation/widgets/control_button.dart';
import 'package:video_player_watermark/presentation/widgets/video_progress_bar.dart';

class CustomVideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onFullScreen;
  final bool showFullScreenButton;
  final bool isFullScreen;
  final double iconSize;
  final double fontSize;

  const CustomVideoControls({
    super.key,
    required this.controller,
    required this.onFullScreen,
    this.showFullScreenButton = true,
    this.isFullScreen = false,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  State<CustomVideoControls> createState() => _CustomVideoControlsState();
}

class _CustomVideoControlsState extends State<CustomVideoControls> {
  bool _showControls = true;
  bool _isDragging = false;
  double _playbackSpeed = 1.0;
  String _videoQuality = 'Auto';
  bool _isMuted = false;
  double _volumeBeforeMute = 1.0;

  final List<double> _playbackSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
  final List<String> _videoQualities = ['Auto', '1080p', '720p', '480p', '360p'];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  void _togglePlayPause() {
    widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        widget.controller.setVolume(_volumeBeforeMute);
        _isMuted = false;
      } else {
        _volumeBeforeMute = widget.controller.value.volume;
        widget.controller.setVolume(0.0);
        _isMuted = true;
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            if (_showControls)
              Positioned.fill(
                child: Center(
                  child: _PlayPauseButton(
                    isPlaying: widget.controller.value.isPlaying,
                    onTap: _togglePlayPause,
                    iconSize: widget.iconSize,
                    isFullScreen: widget.isFullScreen,
                  ),
                ),
              ),
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Text(
                        _formatDuration(widget.controller.value.position),
                        style: TextStyle(color: Colors.white, fontSize: widget.fontSize, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ProgressBar(
                          controller: widget.controller,
                          onDragStart: () => _isDragging = true,
                          onDragEnd: () => _isDragging = false,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        _formatDuration(widget.controller.value.duration),
                        style: TextStyle(color: Colors.white, fontSize: widget.fontSize, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 12),
                      ControlButton(
                        icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                        onTap: _toggleMute,
                        iconSize: widget.iconSize,
                      ),
                      SizedBox(width: 8),
                      if (widget.showFullScreenButton)
                        ControlButton(
                          icon: widget.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                          onTap: widget.onFullScreen,
                          iconSize: widget.iconSize,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  final double iconSize;
  final bool isFullScreen;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.onTap,
    required this.iconSize,
    required this.isFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    final size = isFullScreen ? 60.0 : 50.0;
    final iconSizeAdjusted = isFullScreen ? iconSize * 3 : iconSize * 2.5;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: iconSizeAdjusted),
      ),
    );
  }
}
