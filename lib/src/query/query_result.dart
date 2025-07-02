import 'package:file_state_manager/file_state_manager.dart';

/// (ja) DBへのクエリ結果や付加情報を格納したクラスです。
class QueryResult<T> extends CloneableFile {
  static const String className = "QueryResult";
  static const String version = "1";
  bool isNoErrors;
  List<Map<String, dynamic>> result;
  int count;

  /// * [isNoErrors] : 操作が成功したかどうかのフラグ。
  /// これはエラーが発生していないかどうかを表すため、検索や更新数が0でもtrueになります。
  /// * [result] : 検索結果、更新結果、削除されたオブジェクトなど。
  /// * [count] : クエリタイプがsearchの場合は検索でヒットした対象の総数です。
  /// ページングのためにリミットをかけている場合でも、対象となる項目の総数が返ります。
  /// addやconformToTemplate、rename、countではDB内のデータの総数が返されます。
  /// updateやupdateOneの場合は更新された総数が返されます。
  /// deleteの場合は削除された数が返ります。
  /// clearの場合は常に0が返ります。
  /// resultがfalseになる場合（エラーの場合）は常に-1になります。
  QueryResult(this.isNoErrors, this.result, this.count);

  factory QueryResult.fromDict(Map<String, dynamic> src) {
    return QueryResult<T>(src["isNoErrors"], src["result"], src["count"]);
  }

  /// 検索結果を指定クラスの配列で取得します。
  /// * [toClass] : クラスTがCloneableFileである場合、
  /// 辞書からオブジェクトを復元するためのfromDict相当の関数を渡します。
  List<T> convert(T Function(Map<String, dynamic>) toClass) {
    List<T> r = [];
    for (Map<String, dynamic> i in result) {
      r.add(toClass(i));
    }
    return r;
  }

  @override
  QueryResult<T> clone() {
    return QueryResult<T>.fromDict(toDict());
  }

  @override
  Map<String, dynamic> toDict() {
    return {
      "className": className,
      "version": version,
      "isNoErrors": isNoErrors,
      "result": result,
      "count": count,
    };
  }
}
