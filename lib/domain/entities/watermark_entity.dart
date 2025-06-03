import 'package:flutter/material.dart';

class WatermarkEntity {
  final String text;
  final Alignment position;
  final double opacity;
  final Color color;

  const WatermarkEntity({required this.text, required this.position, this.opacity = 0.7, this.color = Colors.white});
}
