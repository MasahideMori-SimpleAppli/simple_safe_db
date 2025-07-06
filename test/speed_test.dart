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

void main() {
  test('speed test', () {
    final int recordsCount = 100000;
    debugPrint("speed test for${recordsCount}records");
    final now = DateTime.now();
    // データベース作成とデータ追加
    final db = SimpleSafeDatabase();
    List<User> users = [];
    for (int i = 0; i < recordsCount; i++) {
      users.add(
        User(
          id: '1',
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

    // save
    debugPrint("start save");
    dt1 = DateTime.now();
    final dbMap = db.toDict();
    dt2 = DateTime.now();
    debugPrint(
      "end save: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // load
    debugPrint("start load");
    dt1 = DateTime.now();
    final _ = SimpleSafeDatabase.fromDict(dbMap);
    dt2 = DateTime.now();
    debugPrint(
      "end load: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // search
    final Query q2 = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SortObj(field: 'age'),
    ).build();
    debugPrint("start search");
    dt1 = DateTime.now();
    final QueryResult<User> r2 = db.executeQuery<User>(q2);
    dt2 = DateTime.now();
    debugPrint(
      "end search: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2.result.length}");

    // search (paging obj)
    final Query q2Paging = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SortObj(field: 'age'),
      limit: 50000,
    ).build();
    debugPrint("start search paging");
    dt1 = DateTime.now();
    final QueryResult<User> r2Paging = db.executeQuery<User>(q2Paging);
    dt2 = DateTime.now();
    debugPrint(
      "end search paging: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2Paging.result.length}");
    final Query q2PagingByObj = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SortObj(field: 'age'),
      startAfter: r2Paging.result.last,
    ).build();
    debugPrint("start search paging by obj");
    dt1 = DateTime.now();
    final QueryResult<User> r2PagingObj = db.executeQuery<User>(q2PagingByObj);
    dt2 = DateTime.now();
    debugPrint(
      "end search paging by obj: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2PagingObj.result.length}");
    final Query q2PagingOffset = QueryBuilder.search(
      target: 'users',
      queryNode: FieldStartsWith("name", "sample"),
      sortObj: SortObj(field: 'age'),
      offset: 50000,
    ).build();
    debugPrint("start search paging by offset");
    dt1 = DateTime.now();
    final QueryResult<User> r2PagingOffset = db.executeQuery<User>(
      q2PagingOffset,
    );
    dt2 = DateTime.now();
    debugPrint(
      "end search paging by offset: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
    debugPrint("returnsLength:${r2PagingOffset.result.length}");

    // update
    final Query q3 = QueryBuilder.update(
      target: 'users',
      queryNode: OrNode([
        FieldEquals('name', 'sample1'),
        FieldEquals('name', 'sample2'),
      ]),
      overrideData: {'age': 26},
      returnData: true,
      sortObj: SortObj(field: 'id'),
    ).build();
    debugPrint("start update");
    dt1 = DateTime.now();
    final _ = db.executeQuery<User>(q3);
    dt2 = DateTime.now();
    debugPrint(
      "end update: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // updateOne
    final Query q4 = QueryBuilder.updateOne(
      target: 'users',
      queryNode: OrNode([FieldEquals('name', 'sample3')]),
      overrideData: {'age': 26},
      returnData: true,
    ).build();
    debugPrint("start updateOne");
    dt1 = DateTime.now();
    final _ = db.executeQuery<User>(q4);
    dt2 = DateTime.now();
    debugPrint(
      "end updateOne: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );

    // delete
    final Query q5 = QueryBuilder.delete(
      target: 'users',
      queryNode: FieldEquals("name", "sample100"),
      sortObj: SortObj(field: 'id'),
      returnData: true,
    ).build();
    debugPrint("start delete");
    dt1 = DateTime.now();
    final _ = db.executeQuery<User>(q5);
    dt2 = DateTime.now();
    debugPrint(
      "end delete: ${dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch} ms",
    );
  });
}
