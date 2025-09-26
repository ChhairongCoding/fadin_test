import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class RecordingWaveformPainter extends CustomPainter {
  final int barsCount;
  final double barWidth;
  final double spacing;
  final double? audioLevel;
  final bool isRecording;
  final Color color;

  RecordingWaveformPainter({
    required this.barsCount,
    this.barWidth = 3.0,
    this.spacing = 2.0,
    this.audioLevel,
    required this.isRecording,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double maxBarHeight = size.height;
    final double now = DateTime.now().millisecondsSinceEpoch.toDouble();
    final double totalWidth = (barWidth + spacing) * barsCount - spacing;
    final double startOffset = (size.width - totalWidth) / 2;

    for (int i = 0; i < barsCount; i++) {
      final double normalized = i / barsCount;
      final double x = startOffset + i * (barWidth + spacing);

      double animationFactor = isRecording ? (now / 200) : 0;
      double sineWave1 = 0.5 + 0.5 * sin((normalized * 30) + animationFactor);
      double sineWave2 =
          0.3 + 0.7 * sin((normalized * 15) + animationFactor * 1.3);
      double combinedWave = (sineWave1 + sineWave2) / 2;

      double heightFactor = audioLevel != null
          ? lerpDouble(0.3, 1.0, audioLevel!)!
          : combinedWave;

      double barHeight = maxBarHeight * heightFactor;

      paint.color =
          color.withOpacity(isRecording ? 0.8 + 0.2 * sin(now / 300 + i) : 0.8);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + barWidth / 2, maxBarHeight / 2),
            width: barWidth,
            height: barHeight,
          ),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RecordingWaveformPainter oldDelegate) {
    return oldDelegate.audioLevel != audioLevel ||
        oldDelegate.isRecording != isRecording ||
        oldDelegate.barsCount != barsCount;
  }
}
