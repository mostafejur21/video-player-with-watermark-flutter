import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;

  const ProgressBar({super.key, required this.controller, required this.onDragStart, required this.onDragEnd});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    if (!controller.value.isInitialized || controller.value.duration == Duration.zero) {
      return SizedBox(height: 20.h); // Ensures consistent layout height
    }

    final duration = controller.value.duration;
    final position = controller.value.position;

    final progress = (_dragValue ?? position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

    return SliderTheme(
      data: _customSliderTheme(),
      child: Slider(
        value: progress,
        onChanged: (value) => setState(() => _dragValue = value),
        onChangeStart: (_) => widget.onDragStart(),
        onChangeEnd: (value) {
          final newPosition = Duration(milliseconds: (value * duration.inMilliseconds).round());
          controller.seekTo(newPosition);
          widget.onDragEnd();
          setState(() => _dragValue = null);
        },
      ),
    );
  }

  SliderThemeData _customSliderTheme() {
    return SliderThemeData(
      trackHeight: 2.h,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.w),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 8.w),
      activeTrackColor: Colors.blue,
      inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
      thumbColor: Colors.blue,
      overlayColor: Colors.blue.withValues(alpha: 0.2),
    );
  }
}
