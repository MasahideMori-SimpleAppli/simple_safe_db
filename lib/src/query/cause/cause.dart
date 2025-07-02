import 'package:file_state_manager/file_state_manager.dart';
import 'package:simple_safe_db/src/query/cause/temporal_trace/temporal_trace.dart';

import 'actor.dart';

class Cause extends CloneableFile {
  static const String className = "Cause";
  static const String version = "1";

  String? serial;
  String? chainParentSerial;
  Actor who;
  TemporalTrace when;
  String what;
  String why;
  String from;
  Map<String, dynamic>? context;
  double confidenceScore;

  /// * [serial] : この操作に割り当てられた一意な識別子。
  /// * [chainParentSerial] : この操作が連鎖的に動く操作だった場合の、以前のCauseのserial。
  /// * [who] : 操作した者の情報。
  /// * [when] : イベントの「時間の軌跡」。
  /// * [what] : どういう操作なのかという、この問い合わせについての説明。例：画面Aでの指定期間のデータを取得。
  /// * [why] : なぜこの問い合わせを行うのかについての説明。例：ユーザーの入力ミスの修正。
  /// * [from] : どこからの問い合わせなのかについての説明。例：モバイルアプリAから。
  /// * [context] : その他の更に詳細な情報。
  /// * [confidenceScore] : 0.0 ~ 1.0で表される確信度。
  /// 誤りを修正する場合などに、入力または上書きするデータが正しいかどうかの確信度を表す。
  /// 特にAIでの自動操作の場合はここにはAIの確信度が入る。
  /// 人間の操作の場合は基本的に常に1.0が入る。
  Cause({
    this.serial,
    this.chainParentSerial,
    required this.who,
    required this.when,
    required this.what,
    required this.why,
    required this.from,
    this.context,
    this.confidenceScore = 1.0,
  });

  factory Cause.fromDict(Map<String, dynamic> src) {
    return Cause(
      serial: src["serial"],
      chainParentSerial: src["chainParentSerial"],
      who: Actor.fromDict(src["who"]),
      when: TemporalTrace.fromDict(src["when"]),
      what: src["what"],
      why: src["why"],
      from: src["from"],
      context: src["context"],
      confidenceScore: src["confidenceScore"],
    );
  }

  @override
  CloneableFile clone() {
    return Cause.fromDict(toDict());
  }

  @override
  Map<String, dynamic> toDict() {
    return {
      "className": className,
      "version": version,
      "serial": serial,
      "chainParentSerial": chainParentSerial,
      "who": who.toDict(),
      "when": when.toDict(),
      "what": what,
      "why": why,
      "from": from,
      "context": context,
      "confidenceScore": confidenceScore,
    };
  }
}
