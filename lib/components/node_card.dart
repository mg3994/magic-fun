import 'package:flutter/material.dart';
import 'package:syncpoint_paradox_logic/models/reality_node.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:syncpoint_paradox_logic/globals/app_state.dart';
import 'package:syncpoint_paradox_logic/reality_node_type.dart';
import 'package:syncpoint_paradox_logic/function_type.dart';

@NowaGenerated()
class NodeCard extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const NodeCard({
    super.key,
    required this.node,
    required this.isSelected,
    required this.isSource,
    required this.canBeTarget,
    required this.isOutOfBounds,
  });

  final RealityNode node;

  final bool isSelected;

  final bool isSource;

  final bool canBeTarget;

  final bool isOutOfBounds;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context, listen: false);
    final theme = Theme.of(context);
    Color borderAccent = Colors.grey;
    if (isSelected) {
      borderAccent = theme.colorScheme.primary;
    } else if (isSource) {
      borderAccent = Colors.amber;
    } else if (canBeTarget) {
      borderAccent = Colors.green;
    } else if (node.stability < 30) {
      borderAccent = Colors.red;
    }
    final int upgradeCost = (45 * node.level).toInt();
    return MouseRegion(
      cursor: SystemMouseCursors.allScroll,
      child: Container(
        width: 250.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: borderAccent,
            width: isSelected || isSource || canBeTarget ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12.0,
              offset: const Offset(0.0, 6.0),
            ),
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 16.0,
                spreadRadius: 3.0,
              ),
            if (node.stability < 30)
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: borderAccent.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              node.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              'LVL ${node.level}',
                              style: TextStyle(
                                fontSize: 8.0,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        node.id,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 9.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    state.deleteNode(node.id);
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red.withValues(alpha: 0.7),
                    size: 16.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INTEGRITY:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      '${node.stability.toStringAsFixed(0)} / ${node.maxStability.toStringAsFixed(0)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: node.stability > 60
                            ? Colors.green
                            : node.stability > 25
                            ? Colors.amber
                            : Colors.red,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FREQUENCY:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      '${node.calculatedValue} Hz',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOutOfBounds
                            ? Colors.amber[600]
                            : Colors.green[400],
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                if (node.type == RealityNodeType.constant) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SET CONSTANT:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      Text(
                        '${node.baseValue.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Colors.cyan,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12.0,
                      ),
                      activeTrackColor: Colors.cyan,
                      inactiveTrackColor: Colors.cyan.withValues(alpha: 0.2),
                      thumbColor: Colors.cyan,
                    ),
                    child: Slider(
                      value: node.baseValue,
                      min: 0.0,
                      max: 100.0,
                      onChanged: (val) {
                        state.updateConstantValue(node.id, val);
                      },
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OPERATOR:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10.0,
                        ),
                      ),
                      DropdownButton<FunctionType>(
                        value: node.functionType,
                        underline: const SizedBox(),
                        isDense: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.purpleAccent,
                          size: 16.0,
                        ),
                        items: FunctionType.values
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                    color: Colors.purpleAccent,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            state.convertNodeOperator(node.id, val!);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  if (node.dependencies.isNotEmpty) ...[
                    Text(
                      'INCOMING FLOWS:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 8.0,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: node.dependencies.map((depId) {
                        final depNode = state.nodes.firstWhereOrNull((n) => n.id == depId);
                        final depName = depNode?.name ?? depId;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.05,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                depName,
                                style: const TextStyle(fontSize: 9.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 4.0),
                              GestureDetector(
                                onTap: () {
                                  state.disconnectNodes(depId, node.id);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 10.0,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    Text(
                      'DISCONNECTED (STABILITY FAILING)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.red[300],
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (canBeTarget)
                      ElevatedButton(
                        onPressed: () {
                          state.connectNodes(
                            state.connectingSourceId!,
                            node.id,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: const Text(
                          'LINK TARGET',
                          style: TextStyle(
                            fontSize: 9.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () {
                          state.startConnection(node.id);
                        },
                        icon: const Icon(Icons.link, size: 10.0),
                        label: const Text(
                          'ROUT',
                          style: TextStyle(fontSize: 8.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6.0,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: () {
                        state.stabilizeNode(node.id);
                      },
                      icon: const Icon(
                        Icons.bolt,
                        size: 10.0,
                        color: Colors.amber,
                      ),
                      label: const Text(
                        'HEAL (15e)',
                        style: TextStyle(fontSize: 8.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 6.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                    if (node.level < 3)
                      ElevatedButton.icon(
                        onPressed: state.realityEnergy >= upgradeCost
                            ? () {
                                state.upgradeNode(node.id);
                              }
                            : null,
                        icon: const Icon(
                          Icons.keyboard_double_arrow_up,
                          size: 10.0,
                          color: Colors.greenAccent,
                        ),
                        label: Text(
                          'UP (${upgradeCost}e)',
                          style: const TextStyle(fontSize: 8.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          foregroundColor: theme.colorScheme.primary,
                          disabledBackgroundColor: theme.colorScheme.onSurface
                              .withValues(alpha: 0.05),
                          disabledForegroundColor: theme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6.0,
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
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}
