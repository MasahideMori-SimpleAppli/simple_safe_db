import 'package:file_state_manager/file_state_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_safe_db/src/db/simple_safe_db_collection.dart';
import 'package:simple_safe_db/src/query/enum_query_type.dart';
import 'package:simple_safe_db/src/query/query.dart';
import 'package:simple_safe_db/src/query/query_result.dart';

/// (ja) 様々な操作の安全性を考慮した、未来志向のデータベースです。
/// 20年後を想定して作成しており、人間以外にもAIが主な利用者と想定して設計されています。
class SimpleSafeDatabase extends CloneableFile {
  static const String className = "SimpleSafeDatabase";
  static const String version = "1";

  late final Map<String, CollectionBase> _collections;

  /// (ja) 通常の空データベースを作成します。
  SimpleSafeDatabase() : _collections = {};

  /// (ja) データベースをJSONから復元します。
  SimpleSafeDatabase.fromDict(Map<String, dynamic> src)
    : _collections = _parseCollections(src);

  /// データベースのJSONからの復元処理。
  static Map<String, CollectionBase> _parseCollections(
    Map<String, dynamic> src,
  ) {
    final raw = src["collections"];
    if (raw is! Map<String, dynamic>) {
      throw FormatException(
        "Invalid format: 'collections' should be a Map<String, dynamic>.",
      );
    }
    final Map<String, CollectionBase> r = {};
    for (final entry in raw.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException(
          "Invalid format: value of collection '$key' is not a Map.",
        );
      }
      // ここでもエラーが起きれば、そのままエラーとしてスローされて良い。
      r[key] = Collection.fromDict(value);
    }
    return r;
  }

  /// (ja) 指定のコレクションが存在すればそれを取得し、
  /// 存在しなければ新しく作成して取得します。
  /// 通常は直接これを呼び出さず、クエリ経由で操作します。
  Collection collection(String name) {
    if (_collections.containsKey(name)) {
      return _collections[name] as Collection;
    }
    final col = Collection();
    _collections[name] = col;
    return col;
  }

  /// (ja) 個別のコレクションを辞書として保存します。
  /// 特定のコレクション単位で暗号化して保存したいような場合に利用できます。
  Map<String, dynamic> collectionToDict(String name) =>
      _collections[name]?.toDict() ?? {};

  /// (ja) コレクションを辞書から復元して再登録し、取得します。
  /// 既存の同名のコレクションが既にある場合は上書きされます。
  /// 通常は、collectionToDictで保存したデータを復元する際に使用します。
  Collection collectionFromDict(String name, Map<String, dynamic> src) {
    final col = Collection.fromDict(src);
    _collections[name] = col;
    return col;
  }

  @override
  CloneableFile clone() {
    return SimpleSafeDatabase.fromDict(toDict());
  }

  @override
  Map<String, dynamic> toDict() {
    final Map<String, Map<String, dynamic>> mCollections = {};
    for (String k in _collections.keys) {
      mCollections[k] = _collections[k]!.toDict();
    }
    return {
      "className": className,
      "version": version,
      "collections": mCollections,
    };
  }

  /// (ja) クエリを実行します。
  /// サーバーサイドでは、この呼び出しの前に正規の呼び出しであるかどうかの検証を
  /// 行ってください。
  QueryResult<T> executeQuery<T>(Query q) {
    Collection col = collection(q.target);
    try {
      switch (q.type) {
        case EnumQueryType.add:
          return col.addAll(q);
        case EnumQueryType.update:
          return col.update(q);
        case EnumQueryType.updateOne:
          return col.updateOne(q);
        case EnumQueryType.delete:
          return col.delete(q);
        case EnumQueryType.search:
          return col.search(q);
        case EnumQueryType.conformToTemplate:
          return col.conformToTemplate(q);
        case EnumQueryType.renameField:
          return col.renameField(q);
        case EnumQueryType.count:
          return col.count();
        case EnumQueryType.clear:
          return col.clear();
      }
    } catch (e) {
      debugPrint(e.toString());
      return QueryResult(false, [], -1);
    }
  }
}
