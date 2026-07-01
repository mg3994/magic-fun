import 'package:syncpoint_paradox_logic/log_level.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class GameLog {
  GameLog({
    required this.timestamp,
    required this.message,
    required this.level,
  });

  final String timestamp;

  final String message;

  final LogLevel level;
}
