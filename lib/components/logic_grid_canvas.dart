import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:syncpoint_paradox_logic/globals/app_state.dart';
import 'package:syncpoint_paradox_logic/connection_painter.dart';
import 'package:syncpoint_paradox_logic/reality_node_type.dart';
import 'package:syncpoint_paradox_logic/components/node_card.dart';
import 'package:syncpoint_paradox_logic/function_type.dart';

@NowaGenerated()
class LogicGridCanvas extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const LogicGridCanvas({super.key});

  @override
  State<LogicGridCanvas> createState() {
    return _LogicGridCanvasState();
  }
}

@NowaGenerated()
class _LogicGridCanvasState extends State<LogicGridCanvas> {
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context, listen: true);
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => ClipRect(
        child: Container(
          color: theme.colorScheme.surfaceContainerLowest,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    state.panCanvas(details.delta.dx, details.delta.dy);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(),
                ),
              ),
              Positioned.fill(
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(state.canvasOffsetX, state.canvasOffsetY)
                    ..scale(state.canvasScale),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ConnectionPainter(
                            nodes: state.nodes,
                            connectingSourceId: state.connectingSourceId,
                            context: context,
                          ),
                        ),
                      ),
                      ...state.nodes.map((node) {
                        final isSelected = state.selectedNode?.id == node.id;
                        final isSource = state.connectingSourceId == node.id;
                        final canBeTarget =
                            state.connectingSourceId != null &&
                            state.connectingSourceId != node.id &&
                            node.type == RealityNodeType.function;
                        final isOutOfBounds =
                            node.calculatedValue < node.targetValueRangeMin ||
                            node.calculatedValue > node.targetValueRangeMax;
                        return Positioned(
                          left: node.posX,
                          top: node.posY,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              final scaledDx =
                                  details.delta.dx / state.canvasScale;
                              final scaledDy =
                                  details.delta.dy / state.canvasScale;
                              final newX = (node.posX + scaledDx).clamp(
                                0.0,
                                1600.0,
                              ).toDouble();
                              final newY = (node.posY + scaledDy).clamp(
                                0.0,
                                1200.0,
                              ).toDouble();
                              state.updateNodePosition(node.id, newX, newY);
                            },
                            onTap: () {
                              state.selectNode(node);
                            },
                            child: NodeCard(
                              node: node,
                              isSelected: isSelected,
                              isSource: isSource,
                              canBeTarget: canBeTarget,
                              isOutOfBounds: isOutOfBounds,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              if (state.connectingSourceId != null)
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 4.0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: Colors.black),
                        const SizedBox(width: 12.0),
                        const Expanded(
                          child: Text(
                            'ROUTING STREAM: Click another Node\'s input port to complete connection, or CANCEL below.',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            state.cancelConnection();
                          },
                          child: const Text(
                            'CANCEL CONNECTION',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 20.0,
                right: 20.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.zoom_out, size: 18.0),
                        onPressed: () {
                          state.zoomOut();
                        },
                        tooltip: 'Zoom Out',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${(state.canvasScale * 100).toStringAsFixed(0)}%',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.zoom_in, size: 18.0),
                        onPressed: () {
                          state.zoomIn();
                        },
                        tooltip: 'Zoom In',
                      ),
                      const SizedBox(width: 4.0),
                      const VerticalDivider(
                        width: 1.0,
                        indent: 8.0,
                        endIndent: 8.0,
                      ),
                      const SizedBox(width: 4.0),
                      IconButton(
                        icon: const Icon(Icons.center_focus_strong, size: 18.0),
                        onPressed: () {
                          state.resetZoom();
                        },
                        tooltip: 'Reset Position & Scale',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20.0,
                left: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CENTER DEPLOY:',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          final centerX =
                              (constraints.maxWidth / 2 -
                                  125 -
                                  state.canvasOffsetX) /
                              state.canvasScale;
                          final centerY =
                              (constraints.maxHeight / 2 -
                                  90 -
                                  state.canvasOffsetY) /
                              state.canvasScale;
                          state.createNode(
                            'Constant Feed',
                            RealityNodeType.constant,
                            FunctionType.sum,
                            centerX,
                            centerY,
                          );
                        },
                        icon: const Icon(
                          Icons.offline_bolt_outlined,
                          size: 12.0,
                        ),
                        label: const Text(
                          'CONST (35e)',
                          style: TextStyle(fontSize: 9.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.withValues(alpha: 0.15),
                          foregroundColor: Colors.cyanAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          final centerX =
                              (constraints.maxWidth / 2 -
                                  125 -
                                  state.canvasOffsetX) /
                              state.canvasScale;
                          final centerY =
                              (constraints.maxHeight / 2 -
                                  90 -
                                  state.canvasOffsetY) /
                              state.canvasScale;
                          state.createNode(
                            'Operator Module',
                            RealityNodeType.function,
                            FunctionType.sum,
                            centerX,
                            centerY,
                          );
                        },
                        icon: const Icon(
                          Icons.settings_input_component,
                          size: 12.0,
                        ),
                        label: const Text(
                          'OPERATOR (35e)',
                          style: TextStyle(fontSize: 9.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.withValues(
                            alpha: 0.15,
                          ),
                          foregroundColor: Colors.purpleAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
