import 'package:file_state_manager/file_state_manager.dart';
import 'package:simple_safe_db/simple_safe_db.dart';

class QueryBuilder {
  String target;
  EnumQueryType type;
  List<CloneableFile>? data;
  Map<String, dynamic>? update;
  CloneableFile? template;
  QueryNode? queryNode;
  SortObj? sortObj;
  int? offset = 0;
  Map<String, dynamic>? startAfter;
  Map<String, dynamic>? endBefore;
  int? limit;
  bool returnUpdated = false;
  bool returnDeleted = false;
  Cause? cause;

  QueryBuilder.add({required this.target, required this.data, this.cause})
    : type = EnumQueryType.add;

  QueryBuilder.update({
    required this.target,
    required this.queryNode,
    required this.update,
    required this.returnUpdated,
    this.sortObj,
    this.cause,
  }) : type = EnumQueryType.update;

  QueryBuilder.updateOne({
    required this.target,
    required this.queryNode,
    required this.update,
    required this.returnUpdated,
    this.cause,
  }) : type = EnumQueryType.updateOne;

  QueryBuilder.delete({
    required this.target,
    required this.queryNode,
    required this.returnDeleted,
    this.sortObj,
    this.cause,
  }) : type = EnumQueryType.delete;

  QueryBuilder.search({
    required this.target,
    required this.queryNode,
    this.sortObj,
    this.offset,
    this.startAfter,
    this.endBefore,
    this.limit,
    this.cause,
  }) : type = EnumQueryType.search;

  QueryBuilder.conformToTemplate({
    required this.target,
    required this.template,
    this.cause,
  }) : type = EnumQueryType.conformToTemplate;

  QueryBuilder.count({required this.target, this.cause})
    : type = EnumQueryType.count;

  QueryBuilder.clear({required this.target, this.cause})
    : type = EnumQueryType.clear;

  /// (en) Commit the content and convert it into a query object.
  ///
  /// (ja) 内容を確定してクエリーオブジェクトに変換します。
  Query build() {
    List<Map<String, dynamic>>? mData = [];
    if (data != null) {
      for (CloneableFile i in data!) {
        mData.add(i.toDict());
      }
    } else {
      mData = null;
    }
    return Query(
      target: target,
      type: type,
      data: mData,
      update: update,
      template: template?.toDict(),
      queryNode: queryNode,
      sortObj: sortObj,
      offset: offset,
      startAfter: startAfter,
      endBefore: endBefore,
      limit: limit,
      returnUpdated: returnUpdated,
      returnDeleted: returnDeleted,
      cause: cause,
    );
  }
}
