import 'dart:convert';

import 'package:file_state_manager/file_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_safe_db/simple_safe_db.dart';

class User extends CloneableFile {
  final String id;
  final String name;
  final int age;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> nestedObj;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.createdAt,
    required this.updatedAt,
    required this.nestedObj,
  });

  static User fromDict(Map<String, dynamic> src) => User(
    id: src['id'],
    name: src['name'],
    age: src['age'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(src['createdAt']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(src['updatedAt']),
    nestedObj: src['nestedObj'],
  );

  @override
  Map<String, dynamic> toDict() => {
    'id': id,
    'name': name,
    'age': age,
    'createdAt': createdAt.millisecondsSinceEpoch,
    // This will automatically update the update date.
    'updatedAt': DateTime.now().millisecondsSinceEpoch,
    'nestedObj': nestedObj,
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
  final Map<String, dynamic> nestedObj;
  final String gender;

  User2({
    required this.id,
    required this.name,
    required this.age,
    required this.nestedObj,
    required this.gender,
  });

  static User2 fromDict(Map<String, dynamic> src) => User2(
    id: src['id'],
    name: src['name'],
    age: src['age'],
    nestedObj: src['nestedObj'],
    gender: src['gender'],
  );

  @override
  Map<String, dynamic> toDict() => {
    'id': id,
    'name': name,
    'age': age,
    'nestedObj': nestedObj,
    'gender': gender,
  };

  @override
  User2 clone() {
    return User2.fromDict(toDict());
  }
}

void main() {
  test('speed test', () {
    final int recordsCount = 100000;
    debugPrint("speed test for $recordsCount records");
    final now = DateTime.now();
    // データベース作成とデータ追加
    final db = SimpleSafeDatabase();
    List<User> users = [];
    for (int i = 0; i < recordsCount; i++) {
      users.add(
        User(
          id: i.toString(),
          name: 'sample$i',
          age: i,
          createdAt: now,
          updatedAt: now,
          nestedObj: {"num": i},
        ),
      );
    }
    // add
    final Query q1 = QueryBuilder.add(target: 'users', addData: users).build();
    debugPrint("start add");
    DateTime dt1 = DateTime.now();
    final QueryResult<User> r1 = db.executeQuery<User>(q1);
    DateTime dt2 = DateTime.now();
    debugPrint(
      "end add: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    expect(r1.isNoErrors, true);

    // getAll
    final Query q1Get = QueryBuilder.getAll(target: 'users').build();
    debugPrint("start getAll (with object convert)");
    dt1 = DateTime.now();
    final QueryResult<User> r1Get = db.executeQuery<User>(q1Get);
    final List<User> _ = r1Get.convert(User.fromDict);
    dt2 = DateTime.now();
    debugPrint(
      "end getAll: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    expect(r1.isNoErrors, true);
    debugPrint("returnsLength:${r1Get.result.length}");

    // save
    debugPrint("start save (with json string convert)");
    dt1 = DateTime.now();
    final dbMap = db.toDict();
    final jsonStr = jsonEncode(dbMap);
    dt2 = DateTime.now();
    debugPrint(
      "end save: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // load
    debugPrint("start load (with json string convert)");
    dt1 = DateTime.now();
    final jsonMap = jsonDecode(jsonStr);
    final _ = SimpleSafeDatabase.fromDict(jsonMap);
    dt2 = DateTime.now();
    debugPrint(
      "end load: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // search
    final Query q2 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SingleSort(field: 'age'),
    ).build();
    debugPrint("start search (with object convert)");
    dt1 = DateTime.now();
    final QueryResult<User> r2 = db.executeQuery<User>(q2);
    List<User> _ = r2.convert(User.fromDict);
    dt2 = DateTime.now();
    debugPrint(
      "end search: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2.result.length}");

    // search (paging obj)
    final Query q2Paging = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SingleSort(field: 'age'),
      limit: recordsCount ~/ 2,
    ).build();
    debugPrint(
      "start search paging, half limit pre search (with object convert)",
    );
    dt1 = DateTime.now();
    final QueryResult<User> r2Paging = db.executeQuery<User>(q2Paging);
    List<User> _ = r2Paging.convert(User.fromDict);
    dt2 = DateTime.now();
    debugPrint(
      "end search paging: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2Paging.result.length}");
    final Query q2PagingByObj = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SingleSort(field: 'age'),
      startAfter: r2Paging.result.last,
    ).build();
    debugPrint("start search paging by obj (with object convert)");
    dt1 = DateTime.now();
    final QueryResult<User> r2PagingObj = db.executeQuery<User>(q2PagingByObj);
    List<User> _ = r2PagingObj.convert(User.fromDict);
    dt2 = DateTime.now();
    debugPrint(
      "end search paging by obj: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2PagingObj.result.length}");
    final Query q2PagingOffset = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SingleSort(field: 'age'),
      offset: 50000,
    ).build();
    debugPrint("start search paging by offset (with object convert)");
    dt1 = DateTime.now();
    final QueryResult<User> r2PagingOffset = db.executeQuery<User>(
      q2PagingOffset,
    );
    List<User> _ = r2PagingOffset.convert(User.fromDict);
    dt2 = DateTime.now();
    debugPrint(
      "end search paging by offset: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2PagingOffset.result.length}");

    // update
    final Query q3 = QueryBuilder.update(
      target: 'users',
      queryNode: OrNode([
        FieldEquals('name', 'sample${(recordsCount ~/ 2)}'),
        FieldEquals('name', 'sample${recordsCount - 1}'),
      ]),
      overrideData: {'age': recordsCount + 1},
      returnData: false,
      sortObj: SingleSort(field: 'id'),
    ).build();
    debugPrint("start update at half index and last index object");
    dt1 = DateTime.now();
    final _ = db.executeQuery<User>(q3);
    dt2 = DateTime.now();
    debugPrint(
      "end update: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // updateOne
    final Query q4 = QueryBuilder.updateOne(
      target: 'users',
      queryNode: OrNode([FieldEquals('name', 'sample${(recordsCount ~/ 2)}')]),
      overrideData: {'age': recordsCount},
      returnData: false,
    ).build();
    debugPrint("start updateOne of half index object");
    dt1 = DateTime.now();
    final _ = db.executeQuery<User>(q4);
    dt2 = DateTime.now();
    debugPrint(
      "end updateOne: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // conformToTemplate
    final Query q5 = QueryBuilder.conformToTemplate(
      target: 'users',
      template: User2(
        id: "None",
        name: "None",
        age: -1,
        nestedObj: {"num": -1},
        gender: "None",
      ),
    ).build();
    debugPrint("start conformToTemplate");
    final db2 = db.clone() as SimpleSafeDatabase;
    dt1 = DateTime.now();
    final _ = db2.executeQuery<User2>(q5);
    dt2 = DateTime.now();
    debugPrint(
      "end conformToTemplate: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // delete
    final Query q6 = QueryBuilder.delete(
      target: 'users',
      queryNode: FieldGreaterThan('age', (recordsCount ~/ 2) - 1),
      sortObj: SingleSort(field: 'id'),
      returnData: true,
    ).build();
    debugPrint("start delete half object (with object convert)");
    dt1 = DateTime.now();
    final r6 = db.executeQuery<User>(q6);
    List<User> _ = r6.convert(User.fromDict);
    dt2 = DateTime.now();
    debugPrint(
      "end delete: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r6.result.length}");
  });
}
