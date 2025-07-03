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

  static User2 fromDict(Map<String, dynamic> dict) => User2(
    id: dict['id'],
    name: dict['name'],
    age: dict['age'],
    gender: dict['gender'],
  );

  @override
  Map<String, dynamic> toDict() => {
    'id': id,
    'name': name,
    'age': age,
    'gender': gender,
  };

  @override
  User2 clone() {
    return User2.fromDict(toDict());
  }
}

class User3 extends CloneableFile {
  final String serialID;
  final String name;
  final int age;
  final String gender;

  User3({
    required this.serialID,
    required this.name,
    required this.age,
    required this.gender,
  });

  static User3 fromDict(Map<String, dynamic> dict) => User3(
    serialID: dict['serialID'],
    name: dict['name'],
    age: dict['age'],
    gender: dict['gender'],
  );

  @override
  Map<String, dynamic> toDict() => {
    'serialID': serialID,
    'name': name,
    'age': age,
    'gender': gender,
  };

  @override
  User3 clone() {
    return User3.fromDict(toDict());
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
          User(id: '1', name: 'サンプル太郎', age: 25, createdAt: now),
          User(id: '2', name: 'サンプル次郎', age: 28, createdAt: now),
          User(id: '3', name: 'サンプル三郎', age: 31, createdAt: now),
          User(id: '4', name: 'サンプル花子', age: 17, createdAt: now),
        ],
      ).build(),
    );
    expect(r1.isNoErrors, true);
    expect(r1.count == 4, true);

    // search
    final QueryResult<User> r2 = db.executeQuery<User>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith("name", "サンプル"),
        sortObj: SortObj(field: 'age', reversed: true),
        limit: 2,
      ).build(),
    );
    expect(r2.count == 4, true);
    List<User> result2 = r2.convert(User.fromDict);
    expect(result2.length == 2, true);
    expect(result2[0].name == 'サンプル三郎', true);
    expect(result2[0].createdAt == now, true);

    final QueryResult<User> r3 = db.executeQuery<User>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith('name', 'サンプル'),
        sortObj: SortObj(field: 'age', reversed: true),
        limit: 2,
        startAfter: r2.result.last,
      ).build(),
    );
    expect(r3.count == 4, true);
    List<User> result3 = r3.convert(User.fromDict);
    expect(result3.length == 2, true);
    expect(result3[0].name == 'サンプル太郎', true);

    // update
    final QueryResult<User> r4 = db.executeQuery<User>(
      QueryBuilder.update(
        target: 'users',
        queryNode: OrNode([
          FieldEquals('name', 'サンプル太郎'),
          FieldEquals('name', 'サンプル花子'),
        ]),
        update: {'age': 26},
        returnData: true,
        sortObj: SortObj(field: 'id'),
      ).build(),
    );
    expect(r4.count == 2, true);
    List<User> result4 = r4.convert(User.fromDict);
    expect(result4[0].name == 'サンプル太郎', true);
    expect(result4[0].age == 26, true);
    expect(result4[1].name == 'サンプル花子', true);
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
    expect(result5[0].name == 'サンプル太郎', true);
    expect(result5[0].age == 26, true);
    expect(result5[1].name == 'サンプル花子', true);
    expect(result5[1].age == 26, true);

    // updateOne
    final QueryResult<User> r6 = db.executeQuery<User>(
      QueryBuilder.updateOne(
        target: 'users',
        queryNode: FieldEquals('name', 'サンプル花子'),
        update: {'name': 'テスト花子'},
        returnData: true,
      ).build(),
    );
    expect(r6.count == 1, true);
    List<User> result6 = r6.convert(User.fromDict);
    expect(result6[0].name == 'テスト花子', true);
    expect(result6[0].age == 26, true);
    final QueryResult<User> r7 = db.executeQuery<User>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith("age", "26"),
        sortObj: SortObj(field: 'id'),
        limit: 2,
      ).build(),
    );
    List<User> result7 = r7.convert(User.fromDict);
    expect(result7[0].name == 'サンプル太郎', true);
    expect(result7[0].age == 26, true);
    expect(result7[1].name == 'テスト花子', true);
    expect(result7[1].age == 26, true);

    // delete
    final QueryResult<User> r8 = db.executeQuery<User>(
      QueryBuilder.delete(
        target: 'users',
        queryNode: FieldEquals("name", "テスト花子"),
        sortObj: SortObj(field: 'id'),
        returnData: true,
      ).build(),
    );
    expect(r8.count == 1, true);
    List<User> result8 = r8.convert(User.fromDict);
    expect(result8[0].name == 'テスト花子', true);
    expect(result8[0].age == 26, true);
    final QueryResult<User> r9 = db.executeQuery<User>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith("name", "テスト花子"),
        sortObj: SortObj(field: 'id'),
        limit: 2,
      ).build(),
    );
    expect(r9.count == 0, true);
    List<User> result9 = r9.convert(User.fromDict);
    expect(result9.isEmpty, true);

    // conformToTemplate (User to User2)
    final QueryResult<User2> r10 = db.executeQuery<User2>(
      QueryBuilder.conformToTemplate(
        target: 'users',
        template: User2(id: '5', name: 'NoData', age: -1, gender: 'NoData'),
      ).build(),
    );
    expect(r10.count == 3, true);
    final QueryResult<User2> r11 = db.executeQuery<User2>(
      QueryBuilder.search(
        target: 'users',
        queryNode: FieldStartsWith("name", "サンプル"),
        sortObj: SortObj(field: 'id'),
        limit: 2,
      ).build(),
    );
    List<User2> result11 = r11.convert(User2.fromDict);
    expect(result11[0].gender == "NoData", true);

    // renameField
    final QueryResult<User3> r12 = db.executeQuery<User3>(
      QueryBuilder.renameField(
        target: 'users',
        renameBefore: 'id',
        renameAfter: 'serialID',
        returnData: true,
      ).build(),
    );
    expect(r12.count == 3, true);
    List<User3> _ = r12.convert(User3.fromDict);

    // count
    final QueryResult<User3> r13 = db.executeQuery<User3>(
      QueryBuilder.count(target: 'users').build(),
    );
    expect(r13.count == 3, true);

    // clear
    final QueryResult<User3> r14 = db.executeQuery<User3>(
      QueryBuilder.clear(target: 'users').build(),
    );
    expect(r14.count == 0, true);
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
          User(id: '1', name: 'サンプル太郎', age: 25, createdAt: now),
          User(id: '2', name: 'サンプル次郎', age: 28, createdAt: now),
          User(id: '3', name: 'サンプル三郎', age: 31, createdAt: now),
          User(id: '4', name: 'サンプル花子', age: 17, createdAt: now),
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
    final now = DateTime.now();
    final db = SimpleSafeDatabase();
    // add
    final Query q1 = QueryBuilder.add(
      target: 'users',
      data: [
        User(id: '1', name: 'サンプル太郎', age: 25, createdAt: now),
        User(id: '2', name: 'サンプル次郎', age: 28, createdAt: now),
        User(id: '3', name: 'サンプル三郎', age: 31, createdAt: now),
        User(id: '4', name: 'サンプル花子', age: 17, createdAt: now),
      ],
      cause: Cause(
        serial: "test1",
        chainParentSerial: "test",
        who: Actor(
          EnumActorType.human,
          "ActorUID",
          ["tester"],
          ["users:rw:all"],
        ),
        when: TemporalTrace(
          nodes: [TimestampNode(timestamp: now, location: "japan, kobe")],
        ),
        what: "The test add operation",
        why: "Now testing",
        from: "flutter test",
        context: {"type": "test"},
        confidenceScore: 1.0,
      ),
    ).build();
    final QueryResult<User> r1 = db.executeQuery<User>(
      Query.fromDict(q1.toDict()),
    );
    expect(r1.isNoErrors, true);
    expect(r1.count == 4, true);

    // search
    final Query q2 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "サンプル"),
      sortObj: SortObj(field: 'age', reversed: true),
      limit: 2,
    ).build();
    final QueryResult<User> r2 = db.executeQuery<User>(
      Query.fromDict(q2.toDict()),
    );
    expect(r2.count == 4, true);
    List<User> result2 = r2.convert(User.fromDict);
    expect(result2.length == 2, true);
    expect(result2[0].name == 'サンプル三郎', true);
    expect(result2[0].createdAt == now, true);

    final Query q3 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith('name', 'サンプル'),
      sortObj: SortObj(field: 'age', reversed: true),
      limit: 2,
      startAfter: r2.result.last,
    ).build();
    final QueryResult<User> r3 = db.executeQuery<User>(
      Query.fromDict(q3.toDict()),
    );
    expect(r3.count == 4, true);
    List<User> result3 = r3.convert(User.fromDict);
    expect(result3.length == 2, true);
    expect(result3[0].name == 'サンプル太郎', true);

    // update
    final Query q4 = QueryBuilder.update(
      target: 'users',
      queryNode: OrNode([
        FieldEquals('name', 'サンプル太郎'),
        FieldEquals('name', 'サンプル花子'),
      ]),
      update: {'age': 26},
      returnData: true,
      sortObj: SortObj(field: 'id'),
    ).build();
    final QueryResult<User> r4 = db.executeQuery<User>(
      Query.fromDict(q4.toDict()),
    );
    expect(r4.count == 2, true);
    List<User> result4 = r4.convert(User.fromDict);
    expect(result4[0].name == 'サンプル太郎', true);
    expect(result4[0].age == 26, true);
    expect(result4[1].name == 'サンプル花子', true);
    expect(result4[1].age == 26, true);
    final Query q5 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("age", "26"),
      sortObj: SortObj(field: 'id'),
      limit: 2,
    ).build();
    final QueryResult<User> r5 = db.executeQuery<User>(
      Query.fromDict(q5.toDict()),
    );
    List<User> result5 = r5.convert(User.fromDict);
    expect(result5[0].name == 'サンプル太郎', true);
    expect(result5[0].age == 26, true);
    expect(result5[1].name == 'サンプル花子', true);
    expect(result5[1].age == 26, true);

    // updateOne
    final Query q6 = QueryBuilder.updateOne(
      target: 'users',
      queryNode: FieldEquals('name', 'サンプル花子'),
      update: {'name': 'テスト花子'},
      returnData: true,
    ).build();
    final QueryResult<User> r6 = db.executeQuery<User>(
      Query.fromDict(q6.toDict()),
    );
    expect(r6.count == 1, true);
    List<User> result6 = r6.convert(User.fromDict);
    expect(result6[0].name == 'テスト花子', true);
    expect(result6[0].age == 26, true);
    final Query q7 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("age", "26"),
      sortObj: SortObj(field: 'id'),
      limit: 2,
    ).build();
    final QueryResult<User> r7 = db.executeQuery<User>(
      Query.fromDict(q7.toDict()),
    );
    List<User> result7 = r7.convert(User.fromDict);
    expect(result7[0].name == 'サンプル太郎', true);
    expect(result7[0].age == 26, true);
    expect(result7[1].name == 'テスト花子', true);
    expect(result7[1].age == 26, true);

    // delete
    final Query q8 = QueryBuilder.delete(
      target: 'users',
      queryNode: FieldEquals("name", "テスト花子"),
      sortObj: SortObj(field: 'id'),
      returnData: true,
    ).build();
    final QueryResult<User> r8 = db.executeQuery<User>(
      Query.fromDict(q8.toDict()),
    );
    expect(r8.count == 1, true);
    List<User> result8 = r8.convert(User.fromDict);
    expect(result8[0].name == 'テスト花子', true);
    expect(result8[0].age == 26, true);
    final Query q9 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "テスト花子"),
      sortObj: SortObj(field: 'id'),
      limit: 2,
    ).build();
    final QueryResult<User> r9 = db.executeQuery<User>(
      Query.fromDict(q9.toDict()),
    );
    expect(r9.count == 0, true);
    List<User> result9 = r9.convert(User.fromDict);
    expect(result9.isEmpty, true);

    // conformToTemplate (User to User2)
    final Query q10 = QueryBuilder.conformToTemplate(
      target: 'users',
      template: User2(id: '5', name: 'NoData', age: -1, gender: 'NoData'),
    ).build();
    final QueryResult<User2> r10 = db.executeQuery<User2>(
      Query.fromDict(q10.toDict()),
    );
    expect(r10.count == 3, true);
    final Query q11 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "サンプル"),
      sortObj: SortObj(field: 'id'),
      limit: 2,
    ).build();
    final QueryResult<User2> r11 = db.executeQuery<User2>(
      Query.fromDict(q11.toDict()),
    );
    List<User2> result11 = r11.convert(User2.fromDict);
    expect(result11[0].gender == "NoData", true);

    // renameField
    final Query q12 = QueryBuilder.renameField(
      target: 'users',
      renameBefore: 'id',
      renameAfter: 'serialID',
      returnData: true,
    ).build();
    final QueryResult<User3> r12 = db.executeQuery<User3>(
      Query.fromDict(q12.toDict()),
    );
    expect(r12.count == 3, true);
    List<User3> _ = r12.convert(User3.fromDict);

    // count
    final Query q13 = QueryBuilder.count(target: 'users').build();
    final QueryResult<User3> r13 = db.executeQuery<User3>(
      Query.fromDict(q13.toDict()),
    );
    expect(r13.count == 3, true);

    // clear
    final Query q14 = QueryBuilder.clear(target: 'users').build();
    final QueryResult<User3> r14 = db.executeQuery<User3>(
      Query.fromDict(q14.toDict()),
    ); /**/
    expect(r14.count == 0, true);
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
          User(id: '1', name: 'サンプル太郎', age: 25, createdAt: now),
          User(id: '2', name: 'サンプル次郎', age: 28, createdAt: now),
          User(id: '3', name: 'サンプル三郎', age: 31, createdAt: now),
          User(id: '4', name: 'サンプル花子', age: 17, createdAt: now),
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
}
