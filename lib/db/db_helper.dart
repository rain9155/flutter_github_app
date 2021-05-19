
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static final tag = 'DBProvider';

  static DBHelper? _instance;

  static DBHelper getInstance(){
    if(_instance == null){
      _instance = DBHelper._internal();
    }
    return _instance!;
  }

  DBHelper._internal();

  final String _dbName = 'flutter_github_app.db';

  Database? _db;

  Future<Database?> openDb() async{
    if(_db == null || !_db!.isOpen){
      _db = await openDatabase(_dbName, version: 1, onCreate: (db, version){
        LogUtil.printString(tag, 'onCreate: version = $version');
      });
    }
    return _db;
  }

  Future closeDb() async{
    if(_db != null && _db!.isOpen){
      _db?.close();
    }
  }

  Future deleteDb() async{
    await closeDb();
    return deleteDatabase(_dbName);
  }

  /// 执行一个sql语句
  Future execute(String sql, [List<Object>? arguments]) async{
    await openDb();
    return _db!.execute(sql);
  }

  /// 插入values到table中，插入成功后返回row id, conflictAlgorithm可以指定冲突策略
  Future<int> insert(String table, Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm
  }) async{
    await openDb();
    return _db!.insert(table, values, nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
  }

  /// 删除table中满足where条件的row，删除成功后返回删除的行数，如果where为空表示删除整个table
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async{
    await openDb();
    return _db!.delete(table, where: where, whereArgs: whereArgs);
  }

  /// 用values更新table中满足where条件的row，更新成功后返回更新的行数，如果where为空表示更新整个table
  Future<int> update(String table, Map<String, Object> values, {
    String? where,
    List<Object>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm
  }) async{
    await openDb();
    return _db!.update(table, values);
  }

  /// 查询table中满足where条件的row，并返回
  /// distinct：去重
  /// columns：投影
  /// where：条件语句
  /// whereArgs：代替where中的？占位符
  /// orderBy：查询结果顺序
  /// limit：限制返回的row数
  Future<List<Map<String, Object?>>> query(String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset
  }) async{
    await openDb();
    return _db!.query(table, distinct: distinct, columns: columns, where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy, limit: limit, offset: offset);
  }

}