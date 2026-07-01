import 'package:flutter/material.dart';
import 'package:syncpoint_paradox_logic/models/reality_node.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:syncpoint_paradox_logic/globals/app_state.dart';
import 'package:syncpoint_paradox_logic/sparkline_painter.dart';

@NowaGenerated()
class SelectedNodeSparkline extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SelectedNodeSparkline({super.key, required this.node});

  final RealityNode node;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = AppState.of(context);
    final paddedHistory = List<double>.from(node.valueHistory);
    while (paddedHistory.length < 10) {
      paddedHistory.insert(
        0,
        paddedHistory.isEmpty ? node.calculatedValue : paddedHistory.first,
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: state.isTerminalTheme
            ? const Color(0xFF0B121E)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: state.isTerminalTheme
              ? const Color(0xFF14243B)
              : theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SIGNAL TELEMETRY SPARKLINE',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 8,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              Text(
                '${node.calculatedValue} Hz',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color:
                      (node.calculatedValue < node.targetValueRangeMin ||
                          node.calculatedValue > node.targetValueRangeMax)
                      ? Colors.amberAccent
                      : (state.isTerminalTheme
                            ? const Color(0xFF00FF66)
                            : Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: CustomPaint(
              painter: SparklinePainter(
                history: paddedHistory,
                minTarget: node.targetValueRangeMin,
                maxTarget: node.targetValueRangeMax,
                context: context,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 Hz',
                style: TextStyle(
                  fontSize: 8,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              Text(
                'Target Zone: ${node.targetValueRangeMin.toStringAsFixed(0)}-${node.targetValueRangeMax.toStringAsFixed(0)} Hz',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.amber.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '150 Hz',
                style: TextStyle(
                  fontSize: 8,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
