import 'package:collection/collection.dart';
import 'package:file_state_manager/file_state_manager.dart';

import '../../simple_safe_db.dart';

abstract class CollectionBase extends CloneableFile {}

class Collection extends CollectionBase {
  static const String className = "Collection";
  static const String version = "1";
  List<Map<String, dynamic>> _data = [];

  /// (en) The constructor.
  ///
  /// (ja) コンストラクタ。
  Collection();

  /// (en) Restore this object from the dictionary.
  ///
  /// (ja) このオブジェクトを辞書から復元します。
  ///
  /// * [src] : A dictionary made with toDict of this class.
  Collection.fromDict(Map<String, dynamic> src) {
    _data = src["data"];
  }

  @override
  Map<String, dynamic> toDict() {
    return {"className": className, "version": version, "data": _data};
  }

  @override
  Collection clone() {
    return Collection.fromDict(toDict());
  }

  /// コレクションのリストの参照を返します。直接編集すると危険なため注意してください。
  List<Map<String, dynamic>> get raw => _data;

  /// コレクションのデータ数を返します。
  int get length => _data.length;

  QueryResult<T> addAll<T>(Query q) {
    _data.addAll(q.addData!);
    return QueryResult<T>(
      isNoErrors: true,
      result: [],
      dbLength: length,
      updateCount: 0,
      hitCount: 0,
    );
  }

  /// クエリーにマッチするオブジェクトを更新します。
  QueryResult<T> update<T>(Query q) {
    if (q.returnData) {
      List<Map<String, dynamic>> r = [];
      for (int i = 0; i < _data.length; i++) {
        if (_evaluate(_data[i], q.queryNode!)) {
          _data[i].addAll(q.overrideData!);
          r.add(_data[i]);
        }
      }
      if (q.sortObj != null) {
        r.sort(q.sortObj!.getComparator());
      }
      return QueryResult<T>(
        isNoErrors: true,
        result: r,
        dbLength: length,
        updateCount: r.length,
        hitCount: r.length,
      );
    } else {
      int count = 0;
      for (int i = 0; i < _data.length; i++) {
        if (_evaluate(_data[i], q.queryNode!)) {
          _data[i].addAll(q.overrideData!);
          count += 1;
        }
      }
      return QueryResult<T>(
        isNoErrors: true,
        result: [],
        dbLength: length,
        updateCount: count,
        hitCount: count,
      );
    }
  }

  /// クエリーにマッチするオブジェクトを最初の１件だけ更新します。
  /// シリアル番号を含めて探索している場合など、対象が１件であることが分かっている場合は
  /// updateよりも高速に動作します。
  QueryResult<T> updateOne<T>(Query q) {
    if (q.returnData) {
      List<Map<String, dynamic>> r = [];
      for (int i = 0; i < _data.length; i++) {
        if (_evaluate(_data[i], q.queryNode!)) {
          _data[i].addAll(q.overrideData!);
          r.add(_data[i]);
          return QueryResult<T>(
            isNoErrors: true,
            result: r,
            dbLength: length,
            updateCount: r.length,
            hitCount: r.length,
          );
        }
      }
      return QueryResult<T>(
        isNoErrors: true,
        result: r,
        dbLength: length,
        updateCount: r.length,
        hitCount: r.length,
      );
    } else {
      for (int i = 0; i < _data.length; i++) {
        if (_evaluate(_data[i], q.queryNode!)) {
          _data[i].addAll(q.overrideData!);
          return QueryResult<T>(
            isNoErrors: true,
            result: [],
            dbLength: length,
            updateCount: 1,
            hitCount: 1,
          );
        }
      }
      return QueryResult<T>(
        isNoErrors: true,
        result: [],
        dbLength: length,
        updateCount: 0,
        hitCount: 0,
      );
    }
  }

  /// クエリーにマッチするオブジェクトを削除します。
  QueryResult<T> delete<T>(Query q) {
    if (q.returnData) {
      final List<Map<String, dynamic>> deletedItems = [];
      _data.removeWhere((item) {
        final shouldDelete = _evaluate(item, q.queryNode!);
        if (shouldDelete) {
          deletedItems.add(item);
        }
        return shouldDelete;
      });
      if (q.sortObj != null) {
        deletedItems.sort(q.sortObj!.getComparator());
      }
      return QueryResult<T>(
        isNoErrors: true,
        result: deletedItems,
        dbLength: length,
        updateCount: deletedItems.length,
        hitCount: deletedItems.length,
      );
    } else {
      int count = 0;
      _data.removeWhere((item) {
        final shouldDelete = _evaluate(item, q.queryNode!);
        if (shouldDelete) {
          count += 1;
        }
        return shouldDelete;
      });
      return QueryResult<T>(
        isNoErrors: true,
        result: [],
        dbLength: length,
        updateCount: count,
        hitCount: count,
      );
    }
  }

  QueryResult<T> search<T>(Query q) {
    List<Map<String, dynamic>> r = [];
    for (var i = 0; i < _data.length; i++) {
      if (_evaluate(_data[i], q.queryNode!)) {
        r.add(_data[i]);
      }
    }
    final int hitCount = r.length;
    if (q.sortObj != null) {
      final sorted = [...r];
      sorted.sort(q.sortObj!.getComparator());
      r = sorted;
      if (q.offset != null) {
        if (q.offset! > 0) {
          r = r.skip(q.offset!).toList();
        }
      }
      if (q.startAfter != null) {
        final equality = const DeepCollectionEquality();
        final index = r.indexWhere(
          (item) => equality.equals(item, q.startAfter),
        );
        if (index != -1 && index + 1 < r.length) {
          r = r.sublist(index + 1);
        } else if (index != -1 && index + 1 >= r.length) {
          r = [];
        }
      }
      if (q.endBefore != null) {
        final equality = const DeepCollectionEquality();
        final index = r.indexWhere(
          (item) => equality.equals(item, q.endBefore),
        );
        if (index != -1) {
          r = r.sublist(0, index);
        }
      }
    }
    if (q.limit != null) {
      if (q.endBefore != null) {
        r = r.length > q.limit! ? r.sublist(r.length - q.limit!) : r;
      } else {
        r = r.take(q.limit!).toList();
      }
    }
    return QueryResult<T>(
      isNoErrors: true,
      result: r,
      dbLength: length,
      updateCount: 0,
      hitCount: hitCount,
    );
  }

  QueryResult<T> conformToTemplate<T>(Query q) {
    for (Map<String, dynamic> item in _data) {
      // 1. 削除処理：itemにあるがtmpに無いキーは削除
      final keysToRemove = item.keys
          .where((key) => !q.template!.containsKey(key))
          .toList();
      for (String key in keysToRemove) {
        item.remove(key);
      }
      // 2. 追加処理：tmpにあるがitemに無いキーを追加
      for (String key in q.template!.keys) {
        if (!item.containsKey(key)) {
          item[key] = q.template![key];
        }
      }
    }
    return QueryResult<T>(
      isNoErrors: true,
      result: [],
      dbLength: length,
      updateCount: length,
      hitCount: length,
    );
  }

  QueryResult<T> renameField<T>(Query q) {
    List<Map<String, dynamic>> r = [];
    for (Map<String, dynamic> item in _data) {
      if (!item.containsKey(q.renameBefore!)) {
        throw ArgumentError("The target key does not exist.");
      }
      if (item.containsKey(q.renameAfter!)) {
        throw ArgumentError("An existing key was specified as the new key.");
      }
      item[q.renameAfter!] = item[q.renameBefore!];
      item.remove(q.renameBefore!);
      if (q.returnData) {
        r.add(item);
      }
    }
    return QueryResult<T>(
      isNoErrors: true,
      result: r,
      dbLength: length,
      updateCount: length,
      hitCount: length,
    );
  }

  QueryResult<T> count<T>() {
    return QueryResult<T>(
      isNoErrors: true,
      result: [],
      dbLength: length,
      updateCount: 0,
      hitCount: length,
    );
  }

  QueryResult<T> clear<T>() {
    final int preLen = length;
    _data.clear();
    return QueryResult<T>(
      isNoErrors: true,
      result: [],
      dbLength: 0,
      updateCount: preLen,
      hitCount: preLen,
    );
  }

  bool _evaluate(Map<String, dynamic> record, QueryNode node) =>
      node.evaluate(record);
}
