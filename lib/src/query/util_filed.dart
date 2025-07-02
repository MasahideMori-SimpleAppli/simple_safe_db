class UtilField {
  /// (ja) 辞書の、ネストされたフィールドにアクセスするための関数です。
  ///
  /// * [map] : 探索したいマップ。
  /// * [path] : "."区切りの探索用パス。user.nameなど。
  static dynamic getNestedFieldValue(Map<String, dynamic> map, String path) {
    final keys = path.split('.');
    dynamic current = map;
    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }
}
