import 'package:file_state_manager/file_state_manager.dart';

/// (ja) 軌跡上の各チェックポイントを表すノード。
/// サーバー間でリレーが必要になった場合などには、各地点での個別のデータが入ります。
class TimestampNode extends CloneableFile {
  static const String className = "TimestampNode";
  static const String version = "1";

  /// その地点で記録されたタイムスタンプ
  final DateTime timestamp;

  /// その地点の名称や識別子
  /// 例: 'UserBrowserClient', 'ApiGateway', 'MarsRelaySatellite-7'
  final String location;

  /// その地点での追加コンテキスト情報。キーはロケーション名。
  final Map<String, dynamic> context;

  TimestampNode({
    required this.timestamp,
    required this.location,
    this.context = const {},
  });

  factory TimestampNode.fromDict(Map<String, dynamic> src) {
    return TimestampNode(
      timestamp: DateTime.parse(src["timestamp"]),
      location: src["location"],
      context: src["context"],
    );
  }

  @override
  TimestampNode clone() {
    return TimestampNode.fromDict(toDict());
  }

  @override
  Map<String, dynamic> toDict() {
    return {
      "className": className,
      "version": version,
      "timestamp": timestamp.toUtc().toIso8601String(),
      "location": location,
      "context": context,
    };
  }
}
