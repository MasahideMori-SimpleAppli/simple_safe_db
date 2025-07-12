import 'package:simple_safe_db/src/query/query_node_variations.dart';

abstract class QueryNode {
  /// (en) Returns true if the object matches the calculation.
  ///
  /// (ja) 計算と一致するオブジェクトだった場合はtrueを返します。
  bool evaluate(Map<String, dynamic> data);

  /// (en) Convert the object to a dictionary.
  /// The returned dictionary can only contain primitive types, null, lists
  /// or maps with only primitive elements.
  /// If you want to include other classes,
  /// the target class should inherit from this class and chain calls toDict.
  ///
  /// (ja) このオブジェクトを辞書に変換します。
  /// 戻り値の辞書にはプリミティブ型かプリミティブ型要素のみのリスト
  /// またはマップ等、そしてnullのみを含められます。
  /// それ以外のクラスを含めたい場合、対象のクラスもこのクラスを継承し、
  /// toDictを連鎖的に呼び出すようにしてください。
  Map<String, dynamic> toDict();

  /// (en) Restore this object from the dictionary.
  ///
  /// (ja) このオブジェクトを辞書から復元します。
  ///
  /// * [src] : A dictionary made with toDict of this class.
  static QueryNode fromDict(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'and':
        return AndNode(
          (map['conditions'] as List)
              .map((e) => QueryNode.fromDict(Map<String, dynamic>.from(e)))
              .toList(),
        );
      case 'or':
        return OrNode(
          (map['conditions'] as List)
              .map((e) => QueryNode.fromDict(Map<String, dynamic>.from(e)))
              .toList(),
        );
      case 'not':
        return NotNode(
          QueryNode.fromDict(Map<String, dynamic>.from(map['condition'])),
        );
      case 'equals':
        return FieldEquals(map['field'], map['value']);
      case 'not_equals':
        return FieldNotEquals(map['field'], map['value']);
      case 'greater_than':
        return FieldGreaterThan(map['field'], map['value']);
      case 'less_than':
        return FieldLessThan(map['field'], map['value']);
      case 'greater_than_or_equal':
        return FieldGreaterThanOrEqual(map['field'], map['value']);
      case 'less_than_or_equal':
        return FieldLessThanOrEqual(map['field'], map['value']);
      case 'regex':
        return FieldMatchesRegex(map['field'], map['pattern']);
      case 'contains':
        return FieldContains(map['field'], map['value']);
      case 'in':
        return FieldIn(map['field'], List.from(map['values']));
      case 'not_in':
        return FieldIn(map['field'], List.from(map['values']));
      case 'starts_with':
        return FieldStartsWith(map['field'], map['value']);
      case 'ends_with':
        return FieldEndsWith(map['field'], map['value']);
      default:
        throw UnsupportedError('Unknown query type: ${map['type']}');
    }
  }
}
