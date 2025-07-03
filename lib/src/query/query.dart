import 'package:file_state_manager/file_state_manager.dart';
import 'package:simple_safe_db/simple_safe_db.dart';

/// (en) This is a query class for DB operations. It is usually built using
/// QueryBuilder.
/// This class allows you to set the operation target and operation type,
/// as well as specify paging and
/// Track operations by Cause. If you output this class directly to a log on
/// the server side, the log will be a complete history of DB operations.
///
/// (ja) DB操作用のクエリクラスです。通常はQueryBuilderを使用して構築されます。
/// このクラスは、操作対象の設定、操作の種類の設定の他、ページングの指定や
/// Causeによる操作追跡機能を持っています。このクラスをサーバー側でそのままログに出力すると、
/// そのログは完全なDB操作の履歴になります。
class Query extends CloneableFile {
  static const String className = "Query";
  static const String version = "1";

  String target;
  EnumQueryType type;
  List<Map<String, dynamic>>? data;
  Map<String, dynamic>? update;
  Map<String, dynamic>? template;
  QueryNode? queryNode;
  SortObj? sortObj;
  int? offset;
  Map<String, dynamic>? startAfter;
  Map<String, dynamic>? endBefore;
  String? renameBefore;
  String? renameAfter;
  int? limit;
  bool returnData;
  Cause? cause;

  /// * [target] : The target DB name.
  /// * [type] : The query type.
  /// * [data] : Data specified when performing an add or addAll operation.
  /// Typically, this is assigned the list that results from calling toDict on
  /// a subclass of ClonableFile.
  /// * [update] : This is not a serialized version of the full class,
  /// but a dictionary containing only the parameters you want to update.
  /// * [template] : Specify this when changing the structure of the DB class.
  /// Fields that do not exist in the existing structure but exist in the
  /// template will be added with the template value as the initial value.
  /// Fields that do not exist in the template will be deleted.
  /// * [queryNode] :
  /// * [sortObj] :
  /// * [offset] :
  /// * [startAfter] :
  /// * [endBefore] :
  /// * [renameBefore] : use rename type only.
  /// * [renameAfter] : use rename type only.
  /// * [limit] :
  /// * [returnData] : If true, return the changed objs.
  /// * [cause] :
  Query({
    required this.target,
    required this.type,
    this.data,
    this.update,
    this.template,
    this.queryNode,
    this.sortObj,
    this.offset,
    this.startAfter,
    this.endBefore,
    this.renameBefore,
    this.renameAfter,
    this.limit,
    this.returnData = false,
    this.cause,
  });

  factory Query.fromDict(Map<String, dynamic> src) {
    return Query(
      target: src["target"],
      type: EnumQueryType.values.byName(src["type"]),
      data: src["data"],
      update: src["update"],
      template: src["template"],
      queryNode: src["queryNode"] != null
          ? QueryNode.fromDict(src["queryNode"])
          : null,
      sortObj: src["sortObj"] != null ? SortObj.fromDict(src["sortObj"]) : null,
      offset: src["offset"],
      startAfter: src["startAfter"],
      endBefore: src["endBefore"],
      renameBefore: src["renameBefore"],
      renameAfter: src["renameAfter"],
      limit: src["limit"],
      returnData: src["returnUpdated"],
      cause: src["cause"] != null ? Cause.fromDict(src["cause"]) : null,
    );
  }

  @override
  Map<String, dynamic> toDict() {
    return {
      "className": className,
      "version": version,
      "target": target,
      "type": type.name,
      "data": data,
      "update": update,
      "template": template,
      "queryNode": queryNode?.toDict(),
      "sortObj": sortObj?.toDict(),
      "offset": offset,
      "startAfter": startAfter,
      "endBefore": endBefore,
      "renameBefore": renameBefore,
      "renameAfter": renameAfter,
      "limit": limit,
      "returnUpdated": returnData,
      "cause": cause?.toDict(),
    };
  }

  @override
  Query clone() {
    return Query.fromDict(toDict());
  }
}
