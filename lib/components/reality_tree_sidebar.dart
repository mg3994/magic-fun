import 'package:flutter/material.dart';
import 'package:syncpoint_paradox_logic/reality_node_type.dart';
import 'package:syncpoint_paradox_logic/function_type.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:syncpoint_paradox_logic/globals/app_state.dart';

@NowaGenerated()
class RealityTreeSidebar extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const RealityTreeSidebar({super.key});

  @override
  State<RealityTreeSidebar> createState() {
    return _RealityTreeSidebarState();
  }
}

@NowaGenerated()
class _RealityTreeSidebarState extends State<RealityTreeSidebar> {
  final _nameController = TextEditingController();

  RealityNodeType _selectedType = RealityNodeType.constant;

  FunctionType _selectedFuncType = FunctionType.sum;

  bool _isCreatingNode = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context, listen: true);
    final theme = Theme.of(context);
    final isHorizontal = MediaQuery.of(context).size.width > 900;

    return Container(
      width: isHorizontal ? 320 : null,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
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
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lan_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REALITY GRAPH',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'REACTIVE VECTOR STREAM',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isCreatingNode)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ANCHOR NEW NODE',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Node Name',
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Node Class:',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      DropdownButton<RealityNodeType>(
                        value: _selectedType,
                        items: RealityNodeType.values
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type.name.toUpperCase(),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedType = val!;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (_selectedType == RealityNodeType.function)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Operator:',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        DropdownButton<FunctionType>(
                          value: _selectedFuncType,
                          items: FunctionType.values
                              .map(
                                (func) => DropdownMenuItem(
                                  value: func,
                                  child: Text(
                                    func.name.toUpperCase(),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedFuncType = val!;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isCreatingNode = false;
                          });
                        },
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final name = _nameController.text.trim();
                          if (name.isNotEmpty) {
                            state.createNode(
                              name,
                              _selectedType,
                              _selectedFuncType,
                              250,
                              150 + (state.nodes.length * 40) % 300,
                            );
                            _nameController.clear();
                            setState(() {
                              _isCreatingNode = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: const Text('DEPLOY'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isCreatingNode = true;
                  });
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'ANCHOR REALITY NODE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.15,
                  ),
                  foregroundColor: theme.colorScheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.amber[400], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Reality Energy:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${state.realityEnergy.toStringAsFixed(0)} / 250',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: state.nodes.length,
              itemBuilder: (context, index) {
                final node = state.nodes[index];
                final isSelected = state.selectedNode?.id == node.id;
                final isOutOfBounds =
                    node.calculatedValue < node.targetValueRangeMin ||
                    node.calculatedValue > node.targetValueRangeMax;
                Color nodeColor;
                IconData nodeIcon;
                if (node.type == RealityNodeType.constant) {
                  nodeColor = Colors.cyan;
                  nodeIcon = Icons.offline_bolt_outlined;
                } else {
                  nodeColor = Colors.purpleAccent;
                  nodeIcon = Icons.settings_input_component;
                }
                return GestureDetector(
                  onTap: () {
                    state.selectNode(node);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.08)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: nodeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(nodeIcon, color: nodeColor, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    node.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${node.type.name.toUpperCase()} • ${node.id}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.4),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (node.stability == 0)
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 16,
                              )
                            else if (isOutOfBounds)
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.amber,
                                size: 16,
                              )
                            else
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 16,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SIGNAL: ${node.calculatedValue} Hz',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isOutOfBounds
                                    ? Colors.amber[600]
                                    : Colors.green[400],
                              ),
                            ),
                            Text(
                              'TARGET: ${node.targetValueRangeMin}-${node.targetValueRangeMax}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: node.stability / 100,
                                  minHeight: 4,
                                  backgroundColor: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.08),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    node.stability > 60
                                        ? Colors.green
                                        : node.stability > 25
                                        ? Colors.amber
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${node.stability.toStringAsFixed(0)}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: node.stability > 60
                                    ? Colors.green
                                    : node.stability > 25
                                    ? Colors.amber
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
