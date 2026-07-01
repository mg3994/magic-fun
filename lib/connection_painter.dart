import 'package:flutter/material.dart';
import 'package:syncpoint_paradox_logic/models/reality_node.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ConnectionPainter extends CustomPainter {
  ConnectionPainter({
    required this.nodes,
    this.connectingSourceId,
    required this.context,
  });

  final List<RealityNode> nodes;

  final String? connectingSourceId;

  final BuildContext context;

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.connectingSourceId != connectingSourceId;
  }

  Offset _cubicBezier(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
    final double u = 1 - t;
    final double tt = t * t;
    final double uu = u * u;
    final double uuu = uu * u;
    final double ttt = tt * t;
    return p0 * uuu + p1 * (3 * uu * t) + p2 * (3 * u * tt) + p3 * ttt;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final theme = Theme.of(context);
    final paintGrid = Paint();
    paintGrid.color = theme.colorScheme.primary.withValues(alpha: 0.05);
    paintGrid.strokeWidth = 1.0;
    const double gridSize = 40.0;
    for (double x = 0.0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0.0), Offset(x, size.height), paintGrid);
    }
    for (double y = 0.0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0.0, y), Offset(size.width, y), paintGrid);
    }
    final int ms = DateTime.now().millisecondsSinceEpoch;
    for (var targetNode in nodes) {
      for (var sourceId in targetNode.dependencies) {
        final sourceNode = nodes.firstWhereOrNull((n) => n.id == sourceId);
        if (sourceNode == null) {
          continue;
        }
        final start = Offset(sourceNode.posX + 250, sourceNode.posY + 70);
        final end = Offset(targetNode.posX, targetNode.posY + 70);
        final controlPoint1 = Offset(start.dx + 60, start.dy);
        final controlPoint2 = Offset(end.dx - 60, end.dy);
        final path = Path();
        path.moveTo(start.dx, start.dy);
        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          end.dx,
          end.dy,
        );
        final isPathSelected =
            targetNode.stability < 30 || sourceNode.stability < 30;
        final Color strokeColor = isPathSelected
            ? Colors.red.withValues(alpha: 0.6)
            : theme.colorScheme.primary.withValues(alpha: 0.6);
        final paintLine = Paint();
        paintLine.color = strokeColor;
        paintLine.style = PaintingStyle.stroke;
        paintLine.strokeWidth = 2.5;
        paintLine.strokeCap = StrokeCap.round;
        final paintGlow = Paint();
        paintGlow.color = strokeColor.withValues(alpha: 0.3);
        paintGlow.style = PaintingStyle.stroke;
        paintGlow.strokeWidth = 6.0;
        paintGlow.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
        canvas.drawPath(path, paintGlow);
        canvas.drawPath(path, paintLine);
        final double t1 = (ms % 1600) / 1600;
        final double t2 = ((ms + 800) % 1600) / 1600;
        final bubbleOffset1 = _cubicBezier(
          start,
          controlPoint1,
          controlPoint2,
          end,
          t1,
        );
        final bubbleOffset2 = _cubicBezier(
          start,
          controlPoint1,
          controlPoint2,
          end,
          t2,
        );
        final paintBubble = Paint();
        paintBubble.color = isPathSelected
            ? Colors.redAccent
            : Colors.cyanAccent;
        paintBubble.style = PaintingStyle.fill;
        paintBubble.maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
        canvas.drawCircle(bubbleOffset1, 4.0, paintBubble);
        canvas.drawCircle(bubbleOffset2, 4.0, paintBubble);
        final arrowPaint = Paint();
        arrowPaint.color = strokeColor;
        arrowPaint.style = PaintingStyle.fill;
        final arrowPath = Path();
        arrowPath.moveTo(end.dx, end.dy);
        arrowPath.lineTo(end.dx - 10, end.dy - 6);
        arrowPath.lineTo(end.dx - 10, end.dy + 6);
        arrowPath.close();
        canvas.drawPath(arrowPath, arrowPaint);
      }
    }
  }
}
