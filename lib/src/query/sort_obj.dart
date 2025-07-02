import 'package:file_state_manager/file_state_manager.dart';
import 'package:simple_safe_db/src/query/util_filed.dart';

class SortObj extends CloneableFile {
  static const String className = "SortObj";
  static const String version = "1";
  late String field;
  late bool reversed;

  SortObj({required this.field, this.reversed = false});

  SortObj.fromDict(Map<String, dynamic> src) {
    field = src["field"];
    reversed = src["reversed"] ?? false;
  }

  @override
  Map<String, dynamic> toDict() {
    return {
      "className": className,
      "version": version,
      "field": field,
      "reversed": reversed,
    };
  }

  @override
  SortObj clone() {
    return SortObj.fromDict(toDict());
  }

  Comparator<Map<String, dynamic>> getComparator() {
    return (Map<String, dynamic> a, Map<String, dynamic> b) {
      final aValue = UtilField.getNestedFieldValue(a, field);
      final bValue = UtilField.getNestedFieldValue(b, field);
      if (aValue is Comparable && bValue is Comparable) {
        return reversed ? bValue.compareTo(aValue) : aValue.compareTo(bValue);
      }
      throw Exception('Field "$field" is not Comparable: $aValue, $bValue');
    };
  }
}
