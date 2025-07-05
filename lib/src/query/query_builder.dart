import 'package:file_state_manager/file_state_manager.dart';
import 'package:simple_safe_db/simple_safe_db.dart';

class QueryBuilder {
  String target;
  EnumQueryType type;
  List<CloneableFile>? addData;
  Map<String, dynamic>? overrideData;
  CloneableFile? template;
  QueryNode? queryNode;
  SortObj? sortObj;
  int? offset = 0;
  Map<String, dynamic>? startAfter;
  Map<String, dynamic>? endBefore;
  String? renameBefore;
  String? renameAfter;
  int? limit;
  bool returnData = false;
  Cause? cause;

  QueryBuilder.add({required this.target, required this.addData, this.cause})
    : type = EnumQueryType.add;

  QueryBuilder.update({
    required this.target,
    required this.queryNode,
    required this.overrideData,
    required this.returnData,
    this.sortObj,
    this.cause,
  }) : type = EnumQueryType.update;

  QueryBuilder.updateOne({
    required this.target,
    required this.queryNode,
    required this.overrideData,
    required this.returnData,
    this.cause,
  }) : type = EnumQueryType.updateOne;

  QueryBuilder.delete({
    required this.target,
    required this.queryNode,
    required this.returnData,
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

  QueryBuilder.renameField({
    required this.target,
    required this.renameBefore,
    required this.renameAfter,
    required this.returnData,
    this.cause,
  }) : type = EnumQueryType.renameField;

  QueryBuilder.count({required this.target, this.cause})
    : type = EnumQueryType.count;

  QueryBuilder.clear({required this.target, this.cause})
    : type = EnumQueryType.clear;

  /// (en) Commit the content and convert it into a query object.
  ///
  /// (ja) 内容を確定してクエリーオブジェクトに変換します。
  Query build() {
    List<Map<String, dynamic>>? mData = [];
    if (addData != null) {
      for (CloneableFile i in addData!) {
        mData.add(i.toDict());
      }
    } else {
      mData = null;
    }
    return Query(
      target: target,
      type: type,
      addData: mData,
      overrideData: overrideData,
      template: template?.toDict(),
      queryNode: queryNode,
      sortObj: sortObj,
      offset: offset,
      startAfter: startAfter,
      endBefore: endBefore,
      renameBefore: renameBefore,
      renameAfter: renameAfter,
      limit: limit,
      returnData: returnData,
      cause: cause,
    );
  }
}
