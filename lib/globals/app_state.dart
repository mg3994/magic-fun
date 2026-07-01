import 'package:flutter/material.dart';
import 'package:syncpoint_paradox_logic/globals/themes.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:syncpoint_paradox_logic/models/reality_node.dart';
import 'package:syncpoint_paradox_logic/game_log.dart';
import 'dart:async';
import 'package:syncpoint_paradox_logic/reality_quadrant.dart';
import 'package:syncpoint_paradox_logic/log_level.dart';
import 'package:syncpoint_paradox_logic/reality_node_type.dart';
import 'package:syncpoint_paradox_logic/function_type.dart';
import 'package:syncpoint_paradox_logic/main.dart';
import 'dart:math';
import 'package:provider/provider.dart';

@NowaGenerated()
class AppState extends ChangeNotifier {
  AppState() {
    Future.delayed(Duration.zero, () {
      loadStats();
    });
  }

  factory AppState.of(BuildContext context, {bool listen = true}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  ThemeData _theme = lightTheme;

  ThemeData get theme {
    return _theme;
  }

  bool isGameRunning = false;

  bool isGameOver = false;

  bool isGameWon = false;

  String gameOverReason = '';

  double totalStability = 100.0;

  double entropyRate = 1.0;

  int ticksElapsed = 0;

  double realityEnergy = 100.0;

  bool hasParadox = false;

  RealityNode? selectedNode;

  String? connectingSourceId;

  int _lastFlushTick = -30;

  List<RealityNode> nodes = [];

  List<GameLog> logs = [];

  Timer? _gameTimer;

  int get flushCooldownRemaining {
    final elapsedSinceFlush = ticksElapsed - _lastFlushTick;
    final remaining = 15 - elapsedSinceFlush;
    return remaining < 0 ? 0 : remaining;
  }

  int highSurvivalTicks = 0;

  int totalWins = 0;

  RealityQuadrant selectedQuadrant = RealityQuadrant.alpha;

  double canvasScale = 1.0;

  double canvasOffsetX = 0.0;

  double canvasOffsetY = 0.0;

  bool isTerminalTheme = true;

  void changeTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  void addLog(String message, LogLevel level) {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    logs.insert(0, GameLog(timestamp: timeStr, message: message, level: level));
    if (logs.length > 50) {
      logs.removeLast();
    }
    notifyListeners();
  }

  void selectNode(RealityNode? node) {
    selectedNode = node;
    notifyListeners();
  }

  void startConnection(String sourceId) {
    connectingSourceId = sourceId;
    addLog(
      'LINK MODE: Select target node to establish flow from Node ${sourceId}',
      LogLevel.info,
    );
    notifyListeners();
  }

  void cancelConnection() {
    connectingSourceId = null;
    notifyListeners();
  }

  void stopGame() {
    _gameTimer?.cancel();
    isGameRunning = false;
    notifyListeners();
  }

  void restartGame() {
    startGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  bool _isPersistentCycle() {
    return hasParadox;
  }

  void createNode(
    String name,
    RealityNodeType type,
    FunctionType funcType,
    double posX,
    double posY,
  ) {
    if (realityEnergy < 35) {
      addLog(
        'SYS_ERROR: Insufficient reality energy (needs 35.0).',
        LogLevel.warning,
      );
      return;
    }
    final random = DateTime.now().millisecondsSinceEpoch;
    final id = 'NODE-${random % 10000}';
    final minVal = 10 + (random % 40);
    final maxVal = minVal + 40 + (random % 40);
    final newNode = RealityNode(
      id: id,
      name: name,
      type: type,
      functionType: funcType,
      stability: 100.0,
      baseValue: type == RealityNodeType.constant ? 50.0 : 0.0,
      calculatedValue: type == RealityNodeType.constant ? 50.0 : 0.0,
      dependencies: [],
      posX: posX,
      posY: posY,
      targetValueRangeMin: double.parse(minVal.toStringAsFixed(0)),
      targetValueRangeMax: double.parse(maxVal.toStringAsFixed(0)),
    );
    nodes.add(newNode);
    realityEnergy -= 35.0;
    selectedNode = newNode;
    addLog(
      'CREATE: Reality node \'${name}\' (${id}) anchored.',
      LogLevel.success,
    );
    _propagateGraph();
    notifyListeners();
  }

  void deleteNode(String id) {
    if (nodes.length <= 2) {
      addLog(
        'SYS_ERROR: Cannot dismantle any further. Minimum reality grid reached.',
        LogLevel.warning,
      );
      return;
    }
    final node = nodes.firstWhere(
      (n) => n.id == id,
      orElse: () => null as dynamic,
    );
    if (node == null) {
      return;
    }
    nodes.removeWhere((n) => n.id == id);
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].dependencies.contains(id)) {
        final updatedDeps = List<String>.from(nodes[i].dependencies)
          ..remove(id);
        nodes[i] = nodes[i].copyWith(dependencies: updatedDeps);
      }
    }
    if (selectedNode?.id == id) {
      selectedNode = null;
    }
    addLog(
      'DISMANTLE: Node \'${node.name}\' dissolved into quantum foam.',
      LogLevel.info,
    );
    _propagateGraph();
    notifyListeners();
  }

  void connectNodes(String sourceId, String targetId) {
    if (sourceId == targetId) {
      addLog('SYS_ERROR: Cannot connect a node to itself.', LogLevel.warning);
      return;
    }
    final targetIndex = nodes.indexWhere((n) => n.id == targetId);
    if (targetIndex == -1) {
      return;
    }
    final targetNode = nodes[targetIndex];
    if (targetNode.type == RealityNodeType.constant) {
      addLog(
        'SYS_ERROR: Constant nodes cannot receive inputs.',
        LogLevel.warning,
      );
      return;
    }
    if (targetNode.dependencies.contains(sourceId)) {
      addLog('SYS_ERROR: Connection already exists.', LogLevel.warning);
      return;
    }
    final sourceNode = nodes.firstWhere(
      (n) => n.id == sourceId,
      orElse: () => null as dynamic,
    );
    if (sourceNode == null) {
      return;
    }
    final updatedDeps = List<String>.from(targetNode.dependencies)
      ..add(sourceId);
    nodes[targetIndex] = targetNode.copyWith(dependencies: updatedDeps);
    addLog(
      'ROUTED: Connected flow from \'${sourceNode.name}\' -> \'${targetNode.name}\'.',
      LogLevel.success,
    );
    connectingSourceId = null;
    _propagateGraph();
    if (_checkForCycles()) {
      hasParadox = true;
      addLog(
        'PARADOX DETECTED: Feed-forward loop created! Disrupt loop to stop stability drain.',
        LogLevel.critical,
      );
    }
    notifyListeners();
  }

  void disconnectNodes(String sourceId, String targetId) {
    final targetIndex = nodes.indexWhere((n) => n.id == targetId);
    if (targetIndex == -1) {
      return;
    }
    final targetNode = nodes[targetIndex];
    if (!targetNode.dependencies.contains(sourceId)) {
      return;
    }
    final updatedDeps = List<String>.from(targetNode.dependencies)
      ..remove(sourceId);
    nodes[targetIndex] = targetNode.copyWith(dependencies: updatedDeps);
    final sourceNode = nodes.firstWhere(
      (n) => n.id == sourceId,
      orElse: () => null as dynamic,
    );
    final sourceName = sourceNode.name ?? sourceId;
    addLog(
      'SEVERED: Flow disconnected from \'${sourceName}\' -/- \'${targetNode.name}\'.',
      LogLevel.info,
    );
    _propagateGraph();
    hasParadox = _checkForCycles();
    notifyListeners();
  }

  void updateConstantValue(String id, double val) {
    final index = nodes.indexWhere((n) => n.id == id);
    if (index == -1) {
      return;
    }
    final node = nodes[index];
    if (node.type != RealityNodeType.constant) {
      return;
    }
    nodes[index] = node.copyWith(
      baseValue: double.parse(val.toStringAsFixed(1)),
    );
    _propagateGraph();
    notifyListeners();
  }

  void updateNodePosition(String id, double dx, double dy) {
    final index = nodes.indexWhere((n) => n.id == id);
    if (index == -1) {
      return;
    }
    nodes[index] = nodes[index].copyWith(posX: dx, posY: dy);
    notifyListeners();
  }

  void stabilizeNode(String id) {
    if (realityEnergy < 15) {
      addLog(
        'SYS_ERROR: Insufficient reality energy (needs 15.0).',
        LogLevel.warning,
      );
      return;
    }
    final index = nodes.indexWhere((n) => n.id == id);
    if (index == -1) {
      return;
    }
    final node = nodes[index];
    final nextStability = (node.stability + 35).clamp(0, 100);
    nodes[index] = node.copyWith(
      stability: double.parse(nextStability.toStringAsFixed(1)),
    );
    realityEnergy -= 15.0;
    addLog(
      'SECURE: Stabilised node \'${node.name}\' (+35.0% Stability).',
      LogLevel.success,
    );
    notifyListeners();
  }

  void flushEntropy() {
    if (flushCooldownRemaining > 0) {
      addLog(
        'SYS_ERROR: Coolant injection charging. Wait ${flushCooldownRemaining}s.',
        LogLevel.warning,
      );
      return;
    }
    _lastFlushTick = ticksElapsed;
    for (var i = 0; i < nodes.length; i++) {
      final boosted = (nodes[i].stability + 25).clamp(0, 100);
      nodes[i] = nodes[i].copyWith(
        stability: double.parse(boosted.toStringAsFixed(1)),
      );
    }
    addLog(
      'CRITICAL: Manual Entropy Flush executed. All node stabilities boosted by 25%!',
      LogLevel.success,
    );
    notifyListeners();
  }

  bool _dfs(String nodeId, Map<String, int> visited) {
    visited[nodeId] = 1;
    final node = nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => null as dynamic,
    );
    if (node != null) {
      for (var depId in node.dependencies) {
        if (!nodes.any((n) => n.id == depId)) {
          continue;
        }
        final depStatus = visited[depId] ?? 0;
        if (depStatus == 1) {
          return true;
        } else if (depStatus == 0) {
          if (_dfs(depId, visited)) {
            return true;
          }
        }
      }
    }
    visited[nodeId] = 2;
    return false;
  }

  bool _checkForCycles() {
    final visited = <String, int>{};
    for (var node in nodes) {
      visited[node.id] = 0;
    }
    for (var node in nodes) {
      if (visited[node.id] == 0) {
        if (_dfs(node.id, visited)) {
          return true;
        }
      }
    }
    return false;
  }

  void loadStats() {
    try {
      highSurvivalTicks =
          sharedPrefs.getInt('highSurvivalTicks_${selectedQuadrant.name}') ?? 0;
      totalWins = sharedPrefs.getInt('totalWins_${selectedQuadrant.name}') ?? 0;
    } catch (e) {
      highSurvivalTicks = 0;
      totalWins = 0;
    }
    notifyListeners();
  }

  void saveStats(bool won) {
    try {
      final currentHigh =
          sharedPrefs.getInt('highSurvivalTicks_${selectedQuadrant.name}') ?? 0;
      if (ticksElapsed > currentHigh) {
        highSurvivalTicks = ticksElapsed;
        sharedPrefs.setInt(
          'highSurvivalTicks_${selectedQuadrant.name}',
          ticksElapsed,
        );
      }
      if (won) {
        final currentWins =
            sharedPrefs.getInt('totalWins_${selectedQuadrant.name}') ?? 0;
        totalWins = currentWins + 1;
        sharedPrefs.setInt('totalWins_${selectedQuadrant.name}', totalWins);
      }
    } catch (e) {}
    notifyListeners();
  }

  void selectQuadrant(RealityQuadrant quadrant) {
    selectedQuadrant = quadrant;
    loadStats();
  }

  void startGame() {
    _gameTimer?.cancel();
    isGameRunning = true;
    isGameOver = false;
    isGameWon = false;
    gameOverReason = '';
    ticksElapsed = 0;
    entropyRate = 1.0;
    realityEnergy = 100.0;
    hasParadox = false;
    selectedNode = null;
    connectingSourceId = null;
    _lastFlushTick = -30;
    logs.clear();
    addLog(
      'SYS_INIT: Decrypting ${selectedQuadrant.name.toUpperCase()} Quadrant...',
      LogLevel.info,
    );
    if (selectedQuadrant == RealityQuadrant.alpha) {
      nodes = [
        RealityNode(
          id: 'Q-CORE',
          name: 'Quantum Core',
          type: RealityNodeType.constant,
          functionType: FunctionType.sum,
          stability: 100.0,
          baseValue: 60.0,
          calculatedValue: 60.0,
          dependencies: [],
          posX: 100.0,
          posY: 120.0,
          targetValueRangeMin: 40.0,
          targetValueRangeMax: 80.0,
        ),
        RealityNode(
          id: 'T-FLUX',
          name: 'Temporal Flux',
          type: RealityNodeType.constant,
          functionType: FunctionType.sum,
          stability: 100.0,
          baseValue: 40.0,
          calculatedValue: 40.0,
          dependencies: [],
          posX: 100.0,
          posY: 320.0,
          targetValueRangeMin: 30.0,
          targetValueRangeMax: 70.0,
        ),
        RealityNode(
          id: 'S-MATRIX',
          name: 'Stabilizer Matrix',
          type: RealityNodeType.function,
          functionType: FunctionType.sum,
          stability: 95.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['Q-CORE'],
          posX: 350.0,
          posY: 120.0,
          targetValueRangeMin: 50.0,
          targetValueRangeMax: 110.0,
        ),
        RealityNode(
          id: 'E-VALVE',
          name: 'Entropy Valve',
          type: RealityNodeType.function,
          functionType: FunctionType.invert,
          stability: 90.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['T-FLUX'],
          posX: 350.0,
          posY: 320.0,
          targetValueRangeMin: 10.0,
          targetValueRangeMax: 65.0,
        ),
        RealityNode(
          id: 'DIM-ANCHOR',
          name: 'Dimensional Anchor',
          type: RealityNodeType.function,
          functionType: FunctionType.dampen,
          stability: 85.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['S-MATRIX', 'E-VALVE'],
          posX: 600.0,
          posY: 220.0,
          targetValueRangeMin: 20.0,
          targetValueRangeMax: 75.0,
        ),
      ];
      addLog(
        'SYS_ALERT: Space-time collapse imminent. Keep stability above 15%!',
        LogLevel.warning,
      );
    } else if (selectedQuadrant == RealityQuadrant.feedback) {
      nodes = [
        RealityNode(
          id: 'GEN-1',
          name: 'Loop Generator',
          type: RealityNodeType.constant,
          functionType: FunctionType.sum,
          stability: 100.0,
          baseValue: 30.0,
          calculatedValue: 30.0,
          dependencies: [],
          posX: 100.0,
          posY: 50.0,
          targetValueRangeMin: 10.0,
          targetValueRangeMax: 50.0,
        ),
        RealityNode(
          id: 'LOOP-A',
          name: 'Vector Channel A',
          type: RealityNodeType.function,
          functionType: FunctionType.sum,
          stability: 75.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['GEN-1', 'LOOP-C'],
          posX: 120.0,
          posY: 220.0,
          targetValueRangeMin: 40.0,
          targetValueRangeMax: 90.0,
        ),
        RealityNode(
          id: 'LOOP-B',
          name: 'Vector Channel B',
          type: RealityNodeType.function,
          functionType: FunctionType.multiply,
          stability: 70.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['LOOP-A'],
          posX: 360.0,
          posY: 100.0,
          targetValueRangeMin: 50.0,
          targetValueRangeMax: 120.0,
        ),
        RealityNode(
          id: 'LOOP-C',
          name: 'Vector Channel C',
          type: RealityNodeType.function,
          functionType: FunctionType.dampen,
          stability: 65.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['LOOP-B'],
          posX: 360.0,
          posY: 320.0,
          targetValueRangeMin: 20.0,
          targetValueRangeMax: 60.0,
        ),
      ];
      addLog(
        'CRITICAL DETECTED: active cycle found: LOOP-A -> LOOP-B -> LOOP-C -> LOOP-A',
        LogLevel.critical,
      );
      addLog(
        'MISSION DECRYPT: Sever one of the loop edges immediately (click \'x\' in card incoming flows)!',
        LogLevel.info,
      );
    } else if (selectedQuadrant == RealityQuadrant.chaos) {
      nodes = [
        RealityNode(
          id: 'SINE-GEN',
          name: 'Wave Oscillator',
          type: RealityNodeType.function,
          functionType: FunctionType.sine,
          stability: 100.0,
          baseValue: 0.0,
          calculatedValue: 50.0,
          dependencies: [],
          posX: 120.0,
          posY: 220.0,
          targetValueRangeMin: 10.0,
          targetValueRangeMax: 90.0,
        ),
        RealityNode(
          id: 'WAVE-VALVE',
          name: 'Wave Valve',
          type: RealityNodeType.function,
          functionType: FunctionType.sum,
          stability: 90.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['SINE-GEN'],
          posX: 370.0,
          posY: 100.0,
          targetValueRangeMin: 35.0,
          targetValueRangeMax: 75.0,
        ),
        RealityNode(
          id: 'RESONATOR',
          name: 'Resonator Core',
          type: RealityNodeType.function,
          functionType: FunctionType.invert,
          stability: 80.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['SINE-GEN'],
          posX: 370.0,
          posY: 320.0,
          targetValueRangeMin: 30.0,
          targetValueRangeMax: 70.0,
        ),
        RealityNode(
          id: 'CORE-MATRIX',
          name: 'Sync Matrix',
          type: RealityNodeType.function,
          functionType: FunctionType.dampen,
          stability: 75.0,
          baseValue: 0.0,
          calculatedValue: 0.0,
          dependencies: ['WAVE-VALVE', 'RESONATOR'],
          posX: 620.0,
          posY: 220.0,
          targetValueRangeMin: 22.0,
          targetValueRangeMax: 50.0,
        ),
      ];
      addLog(
        'SYS_ALERT: Sine Wave Generator active. Signals will automatically oscillate!',
        LogLevel.warning,
      );
      addLog(
        'SYS_INFO: Balance downstream loads using constant feeds and operators.',
        LogLevel.info,
      );
    }
    _propagateGraph();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _onTick();
    });
    notifyListeners();
  }

  void _propagateGraph() {
    final Map<String, double> tempValues = {};
    for (var node in nodes) {
      if (node.type == RealityNodeType.constant) {
        tempValues[node.id] = node.baseValue;
      } else {
        tempValues[node.id] = 0;
      }
    }
    final iterations = nodes.length;
    for (var i = 0; i < iterations; i++) {
      for (var j = 0; j < nodes.length; j++) {
        final node = nodes[j];
        if (node.type == RealityNodeType.constant) {
          tempValues[node.id] = node.baseValue;
          continue;
        }
        final activeDeps = node.dependencies
            .where((id) => nodes.any((n) => n.id == id))
            .toList();
        final inputValues = activeDeps
            .map((id) => tempValues[id] ?? 0.0)
            .toList();
        final double inputSum = inputValues.fold<double>(
          0.0,
          (sum, val) => sum + val,
        );
        double computed = 0.0;
        switch (node.functionType) {
          case FunctionType.sum:
            computed = inputSum;
            break;
          case FunctionType.multiply:
            if (inputValues.isEmpty) {
              computed = 0.0;
            } else if (inputValues.length == 1) {
              computed = inputValues[0] * 1.5;
            } else {
              computed = inputValues.fold<double>(
                1.0,
                (prod, val) => prod * (val == 0 ? 1 : val),
              );
            }
            break;
          case FunctionType.invert:
            computed = (100 - inputSum).clamp(0, 100);
            break;
          case FunctionType.dampen:
            if (inputValues.isEmpty) {
              computed = 0.0;
            } else {
              computed = (inputSum / inputValues.length) * 0.6;
            }
            break;
          case FunctionType.sine:
            final amplitude = inputValues.isEmpty
                ? 30
                : (inputSum * 0.35).clamp(10, 48);
            computed = 50 + amplitude * sin(ticksElapsed * 0.35);
            break;
        }
        tempValues[node.id] = computed.clamp(0, 999);
      }
    }
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final calcVal = tempValues[node.id] ?? 0;
      nodes[i] = node.copyWith(
        calculatedValue: double.parse(calcVal.toStringAsFixed(1)),
      );
    }
    if (selectedNode != null) {
      final index = nodes.indexWhere((n) => n.id == selectedNode?.id);
      if (index != -1) {
        selectedNode = nodes[index];
      }
    }
  }

  void zoomIn() {
    canvasScale = double.parse(
      (canvasScale + 0.1).clamp(0.6, 1.8).toStringAsFixed(1),
    );
    notifyListeners();
  }

  void zoomOut() {
    canvasScale = double.parse(
      (canvasScale - 0.1).clamp(0.6, 1.8).toStringAsFixed(1),
    );
    notifyListeners();
  }

  void resetZoom() {
    canvasScale = 1.0;
    canvasOffsetX = 0.0;
    canvasOffsetY = 0.0;
    notifyListeners();
  }

  void panCanvas(double dx, double dy) {
    canvasOffsetX += dx;
    canvasOffsetY += dy;
    notifyListeners();
  }

  void upgradeNode(String id) {
    final index = nodes.indexWhere((n) => n.id == id);
    if (index == -1) {
      return;
    }
    final node = nodes[index];
    if (node.level >= 3) {
      addLog(
        'SYS_ERROR: Node \'${node.name}\' is already at maximum decryption (LVL 3).',
        LogLevel.warning,
      );
      return;
    }
    final upgradeCost = 45 * node.level;
    if (realityEnergy < upgradeCost) {
      addLog(
        'SYS_ERROR: Insufficient energy to upgrade. Needs ${upgradeCost.toStringAsFixed(0)}e.',
        LogLevel.warning,
      );
      return;
    }
    realityEnergy -= upgradeCost;
    final nextLevel = node.level + 1;
    final nextMaxStability = node.maxStability + 25;
    final nextDecayResistance = node.decayResistance * 0.7;
    nodes[index] = node.copyWith(
      level: nextLevel,
      maxStability: nextMaxStability,
      stability: nextMaxStability,
      decayResistance: nextDecayResistance,
    );
    addLog(
      'UPGRADE: Node \'${node.name}\' calibrated to LVL ${nextLevel}! Max Integrity: ${nextMaxStability.toStringAsFixed(0)}%.',
      LogLevel.success,
    );
    _propagateGraph();
    notifyListeners();
  }

  void convertNodeOperator(String id, FunctionType newType) {
    final index = nodes.indexWhere((n) => n.id == id);
    if (index == -1) {
      return;
    }
    final node = nodes[index];
    if (node.type != RealityNodeType.function) {
      return;
    }
    nodes[index] = node.copyWith(functionType: newType);
    addLog(
      'CONVERT: Re-coded \'${node.name}\' operator to ${newType.name.toUpperCase()}.',
      LogLevel.success,
    );
    _propagateGraph();
    notifyListeners();
  }

  void toggleTerminalTheme() {
    isTerminalTheme = !isTerminalTheme;
    notifyListeners();
  }

  void _onTick() {
    if (!isGameRunning || isGameOver || isGameWon) {
      return;
    }
    ticksElapsed++;
    realityEnergy = (realityEnergy + 4).clamp(0, 250);
    if (ticksElapsed % 15 == 0) {
      entropyRate += 0.2;
      addLog(
        'SYS_ALERT: Space-time decay speed increased to ${entropyRate.toStringAsFixed(1)}x.',
        LogLevel.warning,
      );
    }
    hasParadox = _checkForCycles();
    _propagateGraph();
    double totalNodeStabilities = 0.0;
    final updatedNodes = <RealityNode>[];
    for (var node in nodes) {
      double decay = 0.0;
      if (node.type == RealityNodeType.constant) {
        decay += entropyRate * 0.4;
      } else {
        decay += entropyRate * 0.8;
      }
      if (node.type == RealityNodeType.function && node.dependencies.isEmpty) {
        decay += 3.0;
      }
      final val = node.calculatedValue;
      if (val < node.targetValueRangeMin || val > node.targetValueRangeMax) {
        decay += 3.5;
      }
      if (hasParadox) {
        decay += 5.0;
      }
      bool hasCompromisedDep = false;
      for (var depId in node.dependencies) {
        final depNode = nodes.firstWhere(
          (n) => n.id == depId,
          orElse: () => null as dynamic,
        );
        if (depNode != null && depNode.stability <= 0) {
          hasCompromisedDep = true;
          break;
        }
      }
      if (hasCompromisedDep) {
        decay += 4.0;
      }
      final bool nextOverloaded = node.calculatedValue > 130;
      if (nextOverloaded) {
        decay += 4.5;
        if (!node.isOverloaded) {
          addLog(
            'OVERLOAD: Node \'${node.name}\' frequency exceeds 130Hz! Excess thermal load active.',
            LogLevel.warning,
          );
        }
      }
      final double targetCenter =
          (node.targetValueRangeMin + node.targetValueRangeMax) / 2;
      final bool nextResonating =
          (node.calculatedValue - targetCenter).abs() <= 2.5 &&
          node.stability > 0;
      double nextStability = node.stability;
      if (nextResonating) {
        nextStability = (node.stability + 1.5).clamp(0, node.maxStability);
        realityEnergy = (realityEnergy + 1).clamp(0, 250);
        if (!node.isResonating) {
          addLog(
            'RESONANCE: Node \'${node.name}\' aligned at safe target core! Repairing and harvesting energy.',
            LogLevel.success,
          );
        }
      }
      double actualDecay = decay * node.decayResistance;
      nextStability = (nextStability - actualDecay).clamp(0, node.maxStability);
      if (node.stability > 25 && nextStability <= 25) {
        addLog(
          'CRITICAL: Node \'${node.name}\' stability is failing!',
          LogLevel.critical,
        );
      } else if (node.stability > 0 && nextStability <= 0) {
        addLog(
          'FAILURE: Node \'${node.name}\' has shut down! Downstream integrity compromised.',
          LogLevel.critical,
        );
      }
      final List<double> nextHistory = List<double>.from(node.valueHistory)
        ..add(node.calculatedValue);
      if (nextHistory.length > 10) {
        nextHistory.removeAt(0);
      }
      updatedNodes.add(
        node.copyWith(
          stability: double.parse(nextStability.toStringAsFixed(1)),
          decayResistance: node.decayResistance,
          maxStability: node.maxStability,
          level: node.level,
          valueHistory: nextHistory,
          isOverloaded: nextOverloaded,
          isResonating: nextResonating,
        ),
      );
      totalNodeStabilities += nextStability;
    }
    nodes = updatedNodes;
    totalStability = double.parse(
      (totalNodeStabilities / nodes.length).toStringAsFixed(1),
    );
    if (hasParadox && ticksElapsed % 4 == 0) {
      addLog(
        'PARADOX WARNING: Infinite Chrono-loop detected. Resolve graph cycles now!',
        LogLevel.critical,
      );
    }
    int winTarget = 150;
    if (selectedQuadrant == RealityQuadrant.feedback) {
      winTarget = 120;
    } else if (selectedQuadrant == RealityQuadrant.chaos) {
      winTarget = 100;
    }
    if (totalStability <= 15) {
      isGameOver = true;
      gameOverReason =
          'Reality core reached absolute decay. System collapsed into noise.';
      addLog('GAME OVER: ${gameOverReason}', LogLevel.critical);
      saveStats(false);
      _gameTimer?.cancel();
    } else if (hasParadox && ticksElapsed > 15 && _isPersistentCycle()) {
      isGameOver = true;
      gameOverReason =
          'Paradox singularity. The Chrono-loop feedback loop imploded space-time.';
      addLog('GAME OVER: ${gameOverReason}', LogLevel.critical);
      saveStats(false);
      _gameTimer?.cancel();
    } else if (ticksElapsed >= winTarget) {
      isGameWon = true;
      addLog(
        'MISSION ACCOMPLISHED: Core alignment achieved! Reality stabilized successfully.',
        LogLevel.success,
      );
      saveStats(true);
      _gameTimer?.cancel();
    }
    notifyListeners();
  }
}
