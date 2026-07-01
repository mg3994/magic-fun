import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:syncpoint_paradox_logic/globals/app_state.dart';
import 'package:syncpoint_paradox_logic/components/reality_tree_sidebar.dart';
import 'package:syncpoint_paradox_logic/components/logic_grid_canvas.dart';
import 'package:syncpoint_paradox_logic/components/telemetry_dashboard.dart';
import 'package:syncpoint_paradox_logic/reality_quadrant.dart';

@NowaGenerated()
class HomePage extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context, listen: true);
    final theme = Theme.of(context);
    if (!state.isGameRunning &&
        state.ticksElapsed == 0 &&
        !state.isGameOver &&
        !state.isGameWon) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF0F141C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.radar_outlined,
                    color: theme.colorScheme.primary,
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'SYNCPOINT: PARADOX LOGIC',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'COGNITIVE STABILIZATION DECRYPTOR v1.2.0',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildSectorStatsHeader(context),
                  const SizedBox(height: 12),
                  Text(
                    'SELECT SPACE-TIME SECTOR',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuadrantSelector(context),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 16),
                  Text(
                    'STABILIZATION PROTOCOL',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionItem(
                    context,
                    Icons.bubble_chart_outlined,
                    'BALANCED FREQUENCIES',
                    'Keep each reality node\'s Hz frequency inside its yellow target zone. Out-of-bounds nodes lose stability rapidly.',
                  ),
                  _buildInstructionItem(
                    context,
                    Icons.alt_route,
                    'INTERACTIVE ROUTING',
                    'Click \'ROUT\' on a node, then click another\'s input port to route streams. Disconnect flows by clicking the \'x\'.',
                  ),
                  _buildInstructionItem(
                    context,
                    Icons.sync_problem,
                    'PARADOX BREAKING',
                    'Connecting nodes in a circle creates a loop (Paradox). Break feedback loops immediately to avoid terminal core decay.',
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      state.startGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'INITIALIZE ${state.selectedQuadrant.name.toUpperCase()} GRID',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final bool showCriticalFlash =
        (state.hasParadox || state.totalStability < 30) &&
        (state.ticksElapsed % 2 == 0);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: showCriticalFlash
                  ? BoxDecoration(
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.6),
                        width: 4,
                      ),
                    )
                  : null,
              child: const Row(
                children: const [
                  RealityTreeSidebar(),
                  Expanded(child: LogicGridCanvas()),
                  TelemetryDashboard(),
                ],
              ),
            ),
            if (state.hasParadox)
              Positioned(
                top: 80,
                left: 340,
                right: 340,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white38, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.sync_problem, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'WARNING: PARADOX DETECTED. HIGH DRAIN RATE ACTIVE.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (state.isGameOver)
              _buildOverlay(
                context,
                icon: Icons.dangerous_outlined,
                iconColor: Colors.redAccent,
                title: 'REALITY COLLAPSED',
                subtitle: state.gameOverReason,
                actionText: 'REBOOT QUANTUM TERMINAL',
                onAction: () {
                  state.restartGame();
                },
              ),
            if (state.isGameWon)
              _buildOverlay(
                context,
                icon: Icons.gpp_good,
                iconColor: Colors.greenAccent,
                title: 'TEMPORAL REALIGNMENT SUCCESSFUL',
                subtitle:
                    'You successfully maintained structural stability through the paradox shift. Space-time has been locked in safe coordinates.',
                actionText: 'STABILIZE ANOTHER CORE',
                onAction: () {
                  state.restartGame();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectorStatsHeader(BuildContext context) {
    final state = AppState.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryMetric(
            context,
            'ACTIVE SECTOR:',
            state.selectedQuadrant.name.toUpperCase(),
            Colors.cyan,
          ),
          _buildSummaryMetric(
            context,
            'SECTOR RECORD:',
            '${state.highSurvivalTicks}s',
            Colors.amber,
          ),
          _buildSummaryMetric(
            context,
            'TOTAL SECURED:',
            '${state.totalWins} CORES',
            Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildQuadrantSelector(BuildContext context) {
    final state = AppState.of(context);
    return Column(
      children: [
        _buildQuadrantCard(
          context,
          RealityQuadrant.alpha,
          'QUADRANT ALPHA',
          'Calibration target: 150s. Standard starting anchor nodes. Recommended for systems baseline diagnostics.',
          Icons.shield_outlined,
          state.selectedQuadrant == RealityQuadrant.alpha,
        ),
        const SizedBox(height: 10),
        _buildQuadrantCard(
          context,
          RealityQuadrant.feedback,
          'QUADRANT FEEDBACK',
          'Calibration target: 120s. Starts with a severe 3-node paradox cycle loop. Sever the feedback loop immediately!',
          Icons.sync_problem,
          state.selectedQuadrant == RealityQuadrant.feedback,
        ),
        const SizedBox(height: 10),
        _buildQuadrantCard(
          context,
          RealityQuadrant.chaos,
          'QUADRANT CHAOS',
          'Calibration target: 100s. Dynamic sine waves oscillate frequency streams. Highly volatile, keep targets stable.',
          Icons.waves,
          state.selectedQuadrant == RealityQuadrant.chaos,
        ),
      ],
    );
  }

  Widget _buildQuadrantCard(
    BuildContext context,
    RealityQuadrant quadrant,
    String title,
    String desc,
    IconData icon,
    bool isSelected,
  ) {
    final state = AppState.of(context);
    final theme = Theme.of(context);
    final highlightColor = isSelected
        ? theme.colorScheme.primary
        : Colors.white24;
    return GestureDetector(
      onTap: () {
        state.selectQuadrant(quadrant);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: highlightColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : Colors.white38,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary.withValues(alpha: 0.8),
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionText,
    required void Function() onAction,
  }) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF140D11),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.15),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(icon, color: iconColor, size: 56),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
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
