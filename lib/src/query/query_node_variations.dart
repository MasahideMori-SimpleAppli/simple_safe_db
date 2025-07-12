import 'package:simple_safe_db/src/query/query_node.dart';
import 'package:simple_safe_db/src/query/util_filed.dart';

/// (en) Query node for AND operation.
///
/// (ja) AND演算のためのクエリノード。
class AndNode extends QueryNode {
  final List<QueryNode> conditions;

  /// Query node for AND operation.
  /// * [conditions] : A list of child nodes.
  AndNode(this.conditions);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      conditions.every((c) => c.evaluate(data));

  @override
  Map<String, dynamic> toDict() => {
    'type': 'and',
    'conditions': conditions.map((c) => c.toDict()).toList(),
  };
}

/// (en) Query node for OR operation.
///
/// (ja) OR演算のためのクエリノード。
class OrNode extends QueryNode {
  final List<QueryNode> conditions;

  /// Query node for OR operation.
  /// * [conditions] : A list of child nodes.
  OrNode(this.conditions);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      conditions.any((c) => c.evaluate(data));

  @override
  Map<String, dynamic> toDict() => {
    'type': 'or',
    'conditions': conditions.map((c) => c.toDict()).toList(),
  };
}

/// (en) Query node for NOT operation.
///
/// (ja) NOT演算のためのクエリノード。
class NotNode extends QueryNode {
  final QueryNode condition;

  /// Query node for NOT operation.
  /// * [conditions] : A child node.
  NotNode(this.condition);

  @override
  bool evaluate(Map<String, dynamic> data) => !condition.evaluate(data);

  @override
  Map<String, dynamic> toDict() => {
    'type': 'not',
    'condition': condition.toDict(),
  };
}

/// (en) Query node for Equals operation.
///
/// (ja) Equals演算のためのクエリノード。
class FieldEquals extends QueryNode {
  final String field;
  final dynamic value;

  /// Query node for Equals (filed == value) operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldEquals(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(data, field) == value;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'equals',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for NotEquals operation.
///
/// (ja) NotEquals演算のためのクエリノード。
class FieldNotEquals extends QueryNode {
  final String field;
  final dynamic value;

  /// Query node for NotEquals (filed != value) operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldNotEquals(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(data, field) != value;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'not_equals',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for "field > value" operation.
///
/// (ja) "field > value" 演算のためのクエリノード。
class FieldGreaterThan extends QueryNode {
  final String field;
  final dynamic value;

  /// Query node for "field > value" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldGreaterThan(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(data, field) > value;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'greater_than',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for "field < value" operation.
///
/// (ja) "field < value" 演算のためのクエリノード。
class FieldLessThan extends QueryNode {
  final String field;
  final dynamic value;

  /// Query node for "field < value" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldLessThan(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(data, field) < value;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'less_than',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for "field >= value" operation.
///
/// (ja) "field >= value" 演算のためのクエリノード。
class FieldGreaterThanOrEqual extends QueryNode {
  final String field;
  final dynamic value;

  /// Query node for "field >= value" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldGreaterThanOrEqual(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(data, field) >= value;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'greater_than_or_equal',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for "field <= value" operation.
///
/// (ja) "field <= value" 演算のためのクエリノード。
class FieldLessThanOrEqual extends QueryNode {
  final String field;
  final dynamic value;

  /// Query node for "field <= value" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldLessThanOrEqual(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(data, field) <= value;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'less_than_or_equal',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for "RegExp(pattern).hasMatch(field)" operation.
///
/// (ja) "RegExp(pattern).hasMatch(field)" 演算のためのクエリノード。
class FieldMatchesRegex extends QueryNode {
  final String field;
  final String pattern;

  /// Query node for "RegExp(pattern).hasMatch(field)" operation.
  /// * [field] : The target variable name.
  /// * [pattern] : The compare pattern of regex.
  FieldMatchesRegex(this.field, this.pattern);

  @override
  bool evaluate(Map<String, dynamic> data) {
    final value = UtilField.getNestedFieldValue(data, field)?.toString();
    if (value == null) return false;
    return RegExp(pattern).hasMatch(value);
  }

  @override
  Map<String, dynamic> toDict() => {
    'type': 'regex',
    'field': field,
    'pattern': pattern,
  };
}

/// (en) Query node for "field.contains(value)" operation.
///
/// (ja) "field.contains(value)" 演算のためのクエリノード。
class FieldContains extends QueryNode {
  final String field;
  final dynamic value;

  /// Query node for "field.contains(value)" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldContains(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) {
    final v = UtilField.getNestedFieldValue(data, field);
    if (v is Iterable) return v.contains(value);
    if (v is String && value is String) return v.contains(value);
    return false;
  }

  @override
  Map<String, dynamic> toDict() => {
    'type': 'contains',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for "values.contains(field)" operation.
///
/// (ja) "values.contains(field)" 演算のためのクエリノード。
class FieldIn extends QueryNode {
  final String field;
  final List<dynamic> values;

  /// Query node for "values.contains(field)" operation.
  /// * [field] : The target variable name.
  /// * [values] : The compare value.
  FieldIn(this.field, this.values);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      values.contains(UtilField.getNestedFieldValue(data, field));

  @override
  Map<String, dynamic> toDict() => {
    'type': 'in',
    'field': field,
    'values': values,
  };
}

/// (en) Query node for "Not values.contains(field)" operation.
///
/// (ja) "Not values.contains(field)" 演算のためのクエリノード。
class FieldNotIn extends QueryNode {
  final String field;
  final Iterable<dynamic> values;

  /// Query node for "Not values.contains(field)" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldNotIn(this.field, this.values);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      !values.contains(UtilField.getNestedFieldValue(data, field));

  @override
  Map<String, dynamic> toDict() => {
    'type': 'not_in',
    'field': field,
    'values': values.toList(),
  };
}

/// (en) Query node for "field.toString().startsWidth(value)" operation.
///
/// (ja) "field.toString().startsWidth(value)" 演算のためのクエリノード。
class FieldStartsWith extends QueryNode {
  final String field;
  final String value;

  /// Query node for "field.toString().startsWidth(value)" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldStartsWith(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(
        data,
        field,
      )?.toString().startsWith(value) ??
      false;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'starts_with',
    'field': field,
    'value': value,
  };
}

/// (en) Query node for "field.toString().endsWidth(value)" operation.
///
/// (ja) "field.toString().endsWidth(value)" 演算のためのクエリノード。
class FieldEndsWith extends QueryNode {
  final String field;
  final String value;

  /// Query node for "field.toString().endsWidth(value)" operation.
  /// * [field] : The target variable name.
  /// * [value] : The compare value.
  FieldEndsWith(this.field, this.value);

  @override
  bool evaluate(Map<String, dynamic> data) =>
      UtilField.getNestedFieldValue(data, field)?.toString().endsWith(value) ??
      false;

  @override
  Map<String, dynamic> toDict() => {
    'type': 'ends_with',
    'field': field,
    'value': value,
  };
}
