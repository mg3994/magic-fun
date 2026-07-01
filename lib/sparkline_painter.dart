import 'package:nowa_runtime/nowa_runtime.dart';



import 'package:nowa_runtime/nowa_runtime.dart';

import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'globals/app_state.dart';

import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'globals/app_state.dart';

import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'globals/app_state.dart';

@NowaGenerated()
class SparklinePainter extends CustomPainter {
  SparklinePainter({
    required this.history,
    required this.minTarget,
    required this.maxTarget,
    required this.context,
  });

  final List<double> history;

  final double minTarget;

  final double maxTarget;

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) {
      return;
    }
    final theme = Theme.of(context);
    final isTerminal = AppState.of(context, listen: false).isTerminalTheme;
    final double maxVal = 150;
    final double minVal = 0;
    final double range = maxVal - minVal;
    final double targetTopY =
        size.height - ((maxTarget - minVal) / range) * size.height;
    final double targetBottomY =
        size.height - ((minTarget - minVal) / range) * size.height;
    final targetPaint = Paint()
      ..color = Colors.amber.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(
        0,
        targetTopY.clamp(0, size.height),
        size.width,
        targetBottomY.clamp(0, size.height),
      ),
      targetPaint,
    );
    final boundsPaint = Paint()
      ..color = Colors.amber.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, targetTopY.clamp(0, size.height)),
      Offset(size.width, targetTopY.clamp(0, size.height)),
      boundsPaint,
    );
    canvas.drawLine(
      Offset(0, targetBottomY.clamp(0, size.height)),
      Offset(size.width, targetBottomY.clamp(0, size.height)),
      boundsPaint,
    );
    final double stepX = size.width / 9;
    final path = Path();
    for (int i = 0; i < history.length; i++) {
      final double val = history[i].clamp(0, 150);
      final double x = i * stepX;
      final double y = size.height - ((val - minVal) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final double latestVal = history.last;
    final bool isUnstable = latestVal < minTarget || latestVal > maxTarget;
    final Color strokeColor = isUnstable
        ? Colors.amberAccent
        : (isTerminal ? const Color(0xFF00FF66) : Colors.greenAccent);
    final linePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final glowPaint = Paint()
      ..color = strokeColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.history != history ||
        oldDelegate.minTarget != minTarget ||
        oldDelegate.maxTarget != maxTarget;
  }
}