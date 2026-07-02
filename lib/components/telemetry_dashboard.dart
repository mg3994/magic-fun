import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:syncpoint_paradox_logic/globals/app_state.dart';
import 'package:syncpoint_paradox_logic/components/selected_node_sparkline.dart';
import 'package:syncpoint_paradox_logic/log_level.dart';

@NowaGenerated()
class TelemetryDashboard extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const TelemetryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context, listen: true);
    final theme = Theme.of(context);
    final isHorizontal = MediaQuery.of(context).size.width > 900;
    final minutes = (state.ticksElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.ticksElapsed % 60).toString().padLeft(2, '0');
    final timeStr = '${minutes}:${seconds}';
    final Color panelBg = state.isTerminalTheme
        ? const Color(0xFF070B12)
        : theme.colorScheme.surface.withValues(alpha: 0.95);
    final Color labelColor = state.isTerminalTheme
        ? const Color(0xFF75F8A2).withValues(alpha: 0.7)
        : theme.colorScheme.primary;
    final Color statsCardBg = state.isTerminalTheme
        ? const Color(0xFF0A111E)
        : (state.totalStability > 60
              ? Colors.green.withValues(alpha: 0.05)
              : state.totalStability > 30
              ? Colors.amber.withValues(alpha: 0.05)
              : Colors.red.withValues(alpha: 0.08));
    return Container(
      width: isHorizontal ? 320 : null,
      decoration: BoxDecoration(
        color: panelBg,
        border: Border(
          left: BorderSide(
            color: state.isTerminalTheme
                ? const Color(0xFF14243B)
                : theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: state.isTerminalTheme
                  ? const Color(0xFF09121F)
                  : theme.colorScheme.primary.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: state.isTerminalTheme
                      ? const Color(0xFF14243B)
                      : theme.colorScheme.primary.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.monitor_heart,
                  color: state.isTerminalTheme
                      ? const Color(0xFF00FF66)
                      : theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SYSTEM MONITOR',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: state.isTerminalTheme
                              ? const Color(0xFF00FF66)
                              : theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'CORE COGNITIVE TELEMETRY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: state.isTerminalTheme
                              ? Colors.white38
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    state.isTerminalTheme
                        ? Icons.terminal
                        : Icons.palette_outlined,
                    color: state.isTerminalTheme
                        ? const Color(0xFF00FF66)
                        : theme.colorScheme.primary,
                    size: 18,
                  ),
                  onPressed: () {
                    state.toggleTerminalTheme();
                  },
                  tooltip: 'Toggle Neon Terminal Mode',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statsCardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.isTerminalTheme
                          ? const Color(0xFF14243B)
                          : (state.totalStability > 60
                                ? Colors.green.withValues(alpha: 0.25)
                                : state.totalStability > 30
                                ? Colors.amber.withValues(alpha: 0.25)
                                : Colors.red.withValues(alpha: 0.4)),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'CORE INTEGRITY',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: state.isTerminalTheme
                              ? Colors.white54
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            '${state.totalStability.toStringAsFixed(1)}%',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [FontFeature.tabularFigures()],
                              fontSize: 32,
                              color: state.isTerminalTheme
                                  ? (state.totalStability > 60
                                        ? const Color(0xFF00FF66)
                                        : state.totalStability > 30
                                        ? Colors.amberAccent
                                        : Colors.redAccent)
                                  : (state.totalStability > 60
                                        ? Colors.green
                                        : state.totalStability > 30
                                        ? Colors.amber
                                        : Colors.red),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: state.totalStability / 100,
                          minHeight: 6,
                          backgroundColor: state.isTerminalTheme
                              ? Colors.black26
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.08,
                                ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            state.isTerminalTheme
                                ? (state.totalStability > 60
                                      ? const Color(0xFF00FF66)
                                      : state.totalStability > 30
                                      ? Colors.amber
                                      : Colors.red)
                                : (state.totalStability > 60
                                      ? Colors.green
                                      : state.totalStability > 30
                                      ? Colors.amber
                                      : Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UPTIME CHRONO:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: state.isTerminalTheme
                            ? Colors.white38
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: state.isTerminalTheme
                            ? const Color(0xFF00FF66)
                            : Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ENTROPY DECAY:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: state.isTerminalTheme
                            ? Colors.white38
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${state.entropyRate.toStringAsFixed(1)}x / SEC',
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PARADOX FEEDBACK:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: state.isTerminalTheme
                            ? Colors.white38
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (state.hasParadox)
                      const Row(
                        children: const [
                          Icon(Icons.sync_problem, color: Colors.red, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'CRITICAL LOOP',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: state.isTerminalTheme
                                ? const Color(0xFF00FF66)
                                : Colors.green,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'STABLE (DAG)',
                            style: TextStyle(
                              color: state.isTerminalTheme
                                  ? const Color(0xFF00FF66)
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (state.selectedNode != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SelectedNodeSparkline(node: state.selectedNode!),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: state.flushCooldownRemaining == 0
                  ? () {
                      state.flushEntropy();
                    }
                  : null,
              icon: const Icon(Icons.flash_on, size: 18),
              label: Text(
                state.flushCooldownRemaining == 0
                    ? 'FLUSH CORE ENTROPY'
                    : 'CHARGING (${state.flushCooldownRemaining}S)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.1,
                ),
                disabledForegroundColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'REAL-TIME DIAGNOSTIC FEED',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: state.isTerminalTheme
                        ? Colors.white38
                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: state.isTerminalTheme
                        ? const Color(0xFF00FF66)
                        : Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: state.isTerminalTheme
                      ? const Color(0xFF14243B)
                      : theme.colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
              child: ListView.builder(
                itemCount: state.logs.length,
                reverse: false,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final log = state.logs[index];
                  Color logColor;
                  switch (log.level) {
                    case LogLevel.success:
                      logColor = state.isTerminalTheme
                          ? const Color(0xFF00FF66)
                          : Colors.greenAccent;
                      break;
                    case LogLevel.warning:
                      logColor = Colors.amberAccent;
                      break;
                    case LogLevel.critical:
                      logColor = Colors.redAccent;
                      break;
                    case LogLevel.info:
                    default:
                      logColor = state.isTerminalTheme
                          ? const Color(0xFF00E1FF)
                          : Colors.cyanAccent;
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 11,
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(
                            text: '[${log.timestamp}] ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          TextSpan(
                            text: log.message,
                            style: TextStyle(color: logColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
