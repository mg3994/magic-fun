import 'package:syncpoint_paradox_logic/reality_node_type.dart';
import 'package:syncpoint_paradox_logic/function_type.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class RealityNode {
  const RealityNode({
    required this.id,
    required this.name,
    required this.type,
    required this.functionType,
    required this.stability,
    required this.baseValue,
    required this.calculatedValue,
    required this.dependencies,
    required this.posX,
    required this.posY,
    required this.targetValueRangeMin,
    required this.targetValueRangeMax,
    this.level = 1,
    this.maxStability = 100,
    this.decayResistance = 1,
    this.valueHistory = const [],
    this.isResonating = false,
    this.isOverloaded = false,
  });

  factory RealityNode.fromJson(Map<String, dynamic> json) {
    return RealityNode(
      id: json['id'] as String,
      name: json['name'] as String,
      type: RealityNodeType.values.firstWhere((e) => e.name == json['type']),
      functionType: FunctionType.values.firstWhere(
        (e) => e.name == json['functionType'],
      ),
      stability: (json['stability'] as num).toDouble(),
      baseValue: (json['baseValue'] as num).toDouble(),
      calculatedValue: (json['calculatedValue'] as num).toDouble(),
      dependencies: (json['dependencies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      posX: (json['posX'] as num).toDouble(),
      posY: (json['posY'] as num).toDouble(),
      targetValueRangeMin: (json['targetValueRangeMin'] as num).toDouble(),
      targetValueRangeMax: (json['targetValueRangeMax'] as num).toDouble(),
      level: json['level'] != null ? json['level'] as int : 1,
      maxStability: json['maxStability'] != null
          ? (json['maxStability'] as num).toDouble()
          : 100.0,
      decayResistance: json['decayResistance'] != null
          ? (json['decayResistance'] as num).toDouble()
          : 1.0,
      valueHistory: json['valueHistory'] != null
          ? (json['valueHistory'] as List<dynamic>)
                .map((e) => (e as num).toDouble())
                .toList()
          : const [],
      isResonating: json['isResonating'] != null
          ? json['isResonating'] as bool
          : false,
      isOverloaded: json['isOverloaded'] != null
          ? json['isOverloaded'] as bool
          : false,
    );
  }

  final String id;

  final String name;

  final RealityNodeType type;

  final FunctionType functionType;

  final double stability;

  final double baseValue;

  final double calculatedValue;

  final List<String> dependencies;

  final double posX;

  final double posY;

  final double targetValueRangeMin;

  final double targetValueRangeMax;

  final int level;

  final double maxStability;

  final double decayResistance;

  final List<double> valueHistory;

  final bool isResonating;

  final bool isOverloaded;

  RealityNode copyWith({
    String? id,
    String? name,
    RealityNodeType? type,
    FunctionType? functionType,
    double? stability,
    double? baseValue,
    double? calculatedValue,
    List<String>? dependencies,
    double? posX,
    double? posY,
    double? targetValueRangeMin,
    double? targetValueRangeMax,
    int? level,
    double? maxStability,
    double? decayResistance,
    List<double>? valueHistory,
    bool? isResonating,
    bool? isOverloaded,
  }) {
    return RealityNode(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      functionType: functionType ?? this.functionType,
      stability: stability ?? this.stability,
      baseValue: baseValue ?? this.baseValue,
      calculatedValue: calculatedValue ?? this.calculatedValue,
      dependencies: dependencies ?? List.from(this.dependencies),
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      targetValueRangeMin: targetValueRangeMin ?? this.targetValueRangeMin,
      targetValueRangeMax: targetValueRangeMax ?? this.targetValueRangeMax,
      level: level ?? this.level,
      maxStability: maxStability ?? this.maxStability,
      decayResistance: decayResistance ?? this.decayResistance,
      valueHistory: valueHistory ?? List.from(this.valueHistory),
      isResonating: isResonating ?? this.isResonating,
      isOverloaded: isOverloaded ?? this.isOverloaded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'functionType': functionType.name,
      'stability': stability,
      'baseValue': baseValue,
      'calculatedValue': calculatedValue,
      'dependencies': dependencies,
      'posX': posX,
      'posY': posY,
      'targetValueRangeMin': targetValueRangeMin,
      'targetValueRangeMax': targetValueRangeMax,
      'level': level,
      'maxStability': maxStability,
      'decayResistance': decayResistance,
      'valueHistory': valueHistory,
      'isResonating': isResonating,
      'isOverloaded': isOverloaded,
    };
  }
}

extension RealityNodeListExtension on List<RealityNode> {
  RealityNode? firstWhereOrNull(bool Function(RealityNode) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
