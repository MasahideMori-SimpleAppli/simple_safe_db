import 'package:simple_safe_db/src/query/query_node.dart';
import 'package:simple_safe_db/src/query/util_filed.dart';

class AndNode extends QueryNode {
  final List<QueryNode> conditions;

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

class OrNode extends QueryNode {
  final List<QueryNode> conditions;

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

class NotNode extends QueryNode {
  final QueryNode condition;

  NotNode(this.condition);

  @override
  bool evaluate(Map<String, dynamic> data) => !condition.evaluate(data);

  @override
  Map<String, dynamic> toDict() => {
    'type': 'not',
    'condition': condition.toDict(),
  };
}

class FieldEquals extends QueryNode {
  final String field;
  final dynamic value;

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

class FieldNotEquals extends QueryNode {
  final String field;
  final dynamic value;

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

class FieldGreaterThan extends QueryNode {
  final String field;
  final dynamic value;

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

class FieldLessThan extends QueryNode {
  final String field;
  final dynamic value;

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

class FieldGreaterThanOrEqual extends QueryNode {
  final String field;
  final dynamic value;

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

class FieldLessThanOrEqual extends QueryNode {
  final String field;
  final dynamic value;

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

class FieldMatchesRegex extends QueryNode {
  final String field;
  final String pattern;

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

class FieldContains extends QueryNode {
  final String field;
  final dynamic value;

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

class FieldIn extends QueryNode {
  final String field;
  final List<dynamic> values;

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

class FieldNotIn extends QueryNode {
  final String field;
  final Iterable<dynamic> values;

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

class FieldStartsWith extends QueryNode {
  final String field;
  final String value;

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

class FieldEndsWith extends QueryNode {
  final String field;
  final String value;

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
