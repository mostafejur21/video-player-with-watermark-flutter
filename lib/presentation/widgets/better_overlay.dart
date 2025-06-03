import 'package:flutter/material.dart';

class BouncingOverlay extends StatefulWidget {
  final double playerWidth;
  final double playerHeight;
  final double offsetX;
  final double offsetY;

  const BouncingOverlay({
    super.key,
    required this.playerWidth,
    required this.playerHeight,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  });

  @override
  BouncingOverlayState createState() => BouncingOverlayState();
}

class BouncingOverlayState extends State<BouncingOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double xPos = 0.0;
  double yPos = 0.0;
  double xSpeed = 1.0;
  double ySpeed = 0.5;
  late double textWidth;
  late double textHeight;
  late String displayText;

  @override
  void initState() {
    super.initState();
    displayText = "WATERMARK";
    _calculateTextSize();

    debugPrint(
      'BouncingOverlay init: width=${widget.playerWidth}, height=${widget.playerHeight}, textWidth=$textWidth, textHeight=$textHeight',
    );

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..addListener(() {
      if (!mounted) return;
      setState(() {
        double nextX = xPos + xSpeed;
        double nextY = yPos + ySpeed;

        // Use actual text dimensions for boundary checking
        if (nextX <= 0 || nextX >= widget.playerWidth - textWidth) {
          xSpeed = -xSpeed;
          nextX = xPos + xSpeed;
        }
        if (nextY <= 0 || nextY >= widget.playerHeight - textHeight) {
          ySpeed = -ySpeed;
          nextY = yPos + ySpeed;
        }

        xPos = nextX.clamp(0, widget.playerWidth - textWidth);
        yPos = nextY.clamp(0, widget.playerHeight - textHeight);
      });
    });

    if (widget.playerWidth > textWidth && widget.playerHeight > textHeight) {
      _controller.repeat();
      debugPrint('BouncingOverlay animation started');
    } else {
      debugPrint('BouncingOverlay animation not started: invalid size');
    }
  }

  void _calculateTextSize() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: displayText,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 14, fontWeight: FontWeight.w500),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textWidth = textPainter.width;
    textHeight = textPainter.height;
  }

  @override
  void didUpdateWidget(BouncingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerWidth != widget.playerWidth || oldWidget.playerHeight != widget.playerHeight) {
      setState(() {
        xPos = 0.0;
        yPos = 0.0;
        _calculateTextSize();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.offsetX + xPos,
      top: widget.offsetY + yPos,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
        child: Text(
          displayText,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    debugPrint('BouncingOverlay disposed');
    super.dispose();
  }
}
