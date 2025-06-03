import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayPauseButton extends StatelessWidget {
  final Color borderAndButtonColor;
  final Color backgroundColor;
  final Function() onTap;
  final bool isPlaying;

  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
    this.borderAndButtonColor = Colors.white,
    this.backgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderAndButtonColor, width: 2.w),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: isPlaying
                ? SizedBox.square(
                    key: const ValueKey('pause'),
                    dimension: 28.sp,
                    child: Icon(Icons.pause, size: 28.sp, color: borderAndButtonColor),
                  )
                : SizedBox.square(
                    key: const ValueKey('play'),
                    dimension: 20.sp,
                    child: Icon(Icons.play_arrow, size: 28.sp, color: borderAndButtonColor),
                  ),
          ),
        ),
      ),
    );
  }
}
