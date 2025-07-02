import 'package:file_state_manager/file_state_manager.dart';
import 'package:simple_safe_db/src/query/cause/temporal_trace/timestamp_node.dart';

/// (ja) イベントの「時間の軌跡」を記録するクラスです。
/// これを利用することで、通信経路をリレーする場合も含め、転送を追跡できます。
/// これは将来的に惑星間通信などが必要になってもそのまま利用できるようになっています。
class TemporalTrace extends CloneableFile {
  static const String className = "TemporalTrace";
  static const String version = "1";

  // タイムスタンプの連鎖（チェーン）。経路順でタイムスタンプが格納されます。
  final List<TimestampNode> nodes;

  TemporalTrace({this.nodes = const []});

  /// (ja) 最初のイベントが発生した時刻です。
  /// 通常はフロントエンドデバイスでの時刻を返します。
  DateTime? get initiatedAt => nodes.isNotEmpty ? nodes.first.timestamp : null;

  /// (ja) 最後のイベントが記録された時刻です。
  /// 通常はエンドポイントサーバーでの時刻を返します。
  DateTime? get finalizedAt => nodes.isNotEmpty ? nodes.last.timestamp : null;

  factory TemporalTrace.fromDict(Map<String, dynamic> src) {
    final List<TimestampNode> mNodes = [];
    for (Map<String, dynamic> node in src["nodes"]) {
      mNodes.add(TimestampNode.fromDict(node));
    }
    return TemporalTrace(nodes: mNodes);
  }

  @override
  TemporalTrace clone() {
    return TemporalTrace.fromDict(toDict());
  }

  @override
  Map<String, dynamic> toDict() {
    final List<Map<String, dynamic>> mNodes = [];
    for (TimestampNode node in nodes) {
      mNodes.add(node.toDict());
    }
    return {"className": className, "version": version, "nodes": mNodes};
  }
}
