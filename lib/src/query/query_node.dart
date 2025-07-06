import 'package:simple_safe_db/src/query/query_node_variations.dart';

abstract class QueryNode {
  bool evaluate(Map<String, dynamic> data);
  Map<String, dynamic> toDict();

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
