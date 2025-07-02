import 'package:file_state_manager/file_state_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_safe_db/simple_safe_db.dart';

class User extends CloneableFile {
  final String id;
  final String name;
  final int age;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.createdAt,
  });

  static User fromDict(Map<String, dynamic> dict) => User(
    id: dict['id'],
    name: dict['name'],
    age: dict['age'],
    createdAt: DateTime.parse(dict['createdAt']),
  );

  @override
  Map<String, dynamic> toDict() => {
    'id': id,
    'name': name,
    'age': age,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  User clone() {
    return User.fromDict(toDict());
  }
}

class User2 extends CloneableFile {
  final String id;
  final String name;
  final int age;
  final String gender;

  User2({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  static User fromDict(Map<String, dynamic> dict) => User(
    id: dict['id'],
    name: dict['name'],
    age: dict['age'],
    createdAt: dict['gender'],
  );

  @override
  Map<String, dynamic> toDict() => {
    'id': id,
    'name': name,
    'age': age,
    'gender': gender,
  };

  @override
  User clone() {
    return User.fromDict(toDict());
  }
}

void main() {
  test('DB basic operation test', () {
    final now = DateTime.now();
    final db = SimpleSafeDatabase();
    // add
    final QueryResult<User> r1 = db.executeQuery<User>(
      QueryBuilder.add(
        target: 'users',
        data: [
          User(id: '1', name: '山田太郎', age: 25, createdAt: now),
          User(id: '2', name: '山田次郎', age: 28, createdAt: now),
          User(id: '3', name: '山田三郎', age: 31, createdAt: now),
          User(id: '4', name: '佐藤花子', age: 17, createdAt: now),
        ],
      ).build(),
    );
    expect(r1.isNoErrors, true);
    expect(r1.count == 4, true);

    // search
    final QueryResult<User> r2 = db.executeQuery<User>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith("name", "山田"),
        sortObj: SortObj(field: 'age', reversed: true),
        limit: 2,
      ).build(),
    );
    expect(r2.count == 3, true);
    List<User> result2 = r2.convert(User.fromDict);
    expect(result2.length == 2, true);
    expect(result2[0].name == '山田三郎', true);

    final QueryResult<User> r3 = db.executeQuery<User>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith('name', '山田'),
        sortObj: SortObj(field: 'age', reversed: true),
        limit: 2,
        startAfter: r2.result.last,
      ).build(),
    );
    expect(r3.count == 3, true);
    List<User> result3 = r3.convert(User.fromDict);
    expect(result3.length == 1, true);
    expect(result3[0].name == '山田太郎', true);

    // update
    final QueryResult<User> r4 = db.executeQuery<User>(
      QueryBuilder.update(
        target: 'users',
        queryNode: OrNode([
          FieldEquals('name', '山田太郎'),
          FieldEquals('name', '佐藤花子'),
        ]),
        update: {'age': 26},
        returnUpdated: true,
        sortObj: SortObj(field: 'id'),
      ).build(),
    );
    expect(r4.count == 2, true);
    List<User> result4 = r4.convert(User.fromDict);
    expect(result4[0].name == '山田太郎', true);
    expect(result4[0].age == 26, true);
    expect(result4[1].name == '佐藤花子', true);
    expect(result4[1].age == 26, true);
    final QueryResult<User> r5 = db.executeQuery<User>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith("age", "26"),
        sortObj: SortObj(field: 'id'),
        limit: 2,
      ).build(),
    );
    List<User> result5 = r5.convert(User.fromDict);
    expect(result5[0].name == '山田太郎', true);
    expect(result5[0].age == 26, true);
    expect(result5[1].name == '佐藤花子', true);
    expect(result5[1].age == 26, true);

    // updateOne

    // delete
    // conformToTemplate
    // rename
    // count
    // clear
  });

  test('save and load test', () {
    final now = DateTime.now();
    // データベース作成とデータ追加
    final db = SimpleSafeDatabase();
    // add
    final QueryResult<User> r1 = db.executeQuery<User>(
      QueryBuilder.add(
        target: 'users',
        data: [
          User(id: '1', name: '山田太郎', age: 25, createdAt: now),
          User(id: '2', name: '山田次郎', age: 28, createdAt: now),
          User(id: '3', name: '山田三郎', age: 31, createdAt: now),
          User(id: '4', name: '佐藤花子', age: 17, createdAt: now),
        ],
      ).build(),
    );
    expect(r1.isNoErrors, true);
    // シリアライズと復元
    final usersDB = db.toDict();
    final db2 = SimpleSafeDatabase.fromDict(usersDB);
    final users = db.collection('users');
    final loadedUsers = db2.collection('users');
    // ユーザー数が一致している
    expect(loadedUsers.length, equals(4));
    // IDごとに取得・比較
    for (int i = 0; i < users.length; i++) {
      final originalMap = users.raw[i];
      final loadedMap = loadedUsers.raw[i];
      final original = User.fromDict(originalMap);
      final loaded = User.fromDict(loadedMap);
      expect(loaded.id, equals(original.id));
      expect(loaded.name, equals(original.name));
      expect(loaded.age, equals(original.age));
      expect(
        loaded.createdAt.toIso8601String(),
        equals(original.createdAt.toIso8601String()),
      );
    }
  });

  test('query serialize test', () {
    // TODO
  });
}
