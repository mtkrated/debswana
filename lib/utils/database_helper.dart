import 'dart:io';

import 'package:new_app/models/equipment_update.dart';
import 'package:new_app/models/production_update.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "debswana_db";
  static final _databaseVersion = 1;

  static final table1 = "productionUpdates";
  static final table2 = "equipmentUpdates";

  static final columnId = "id";
  static final columnProduct = "product";
  static final columnValue = "value";
  static final columnDate = "date";
  static final columnShift = "shift";
  static final columnComments = "comments";

  static final columnEId = "id";
  static final columnEquipment = "equipment";
  static final columnEngAvail = "engineering_availability";
  static final columnEquiAvail = "equipment_availability";
  static final columnEquiUtil = "equipment_utilization";
  static final columnEDate = "date";
  static final columnEShift = "shift";
  static final columnEComments = "comments";

  // make this a  singleton class
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();

  //only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onOpen: (db) {},
    );
  }

  openDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onOpen: (db) {},
    );
  }

  closeDb() async {
    await db.closeDb();
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table1 (
            $columnId INTEGER PRIMARY KEY,
            $columnProduct TEXT NOT NULL,
            $columnValue INTEGER NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnShift TEXT NOT NULL,
            $columnComments TEXT NOT NULL  
          )
    ''');

    await db.execute('''
          CREATE TABLE $table2 (
            $columnEId INTEGER PRIMARY KEY,
            $columnEquipment TEXT NOT NULL,
            $columnEngAvail INTEGER NOT NULL,
            $columnEquiAvail INTEGER NOT NULL,
            $columnEquiUtil INTEGER NOT NULL,
            $columnEDate TEXT NOT NULL,
            $columnEShift TEXT NOT NULL,
            $columnEComments TEXT NOT NULL  
          )
    ''');
  }

  Future<int> addProductionUpdate(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table1, row);
  }

  Future<int> addEquipmentUpdate(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table2, row);
  }

  Future<List<ProductionUpdate>> getDailyProductionUpdate(String date) async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM $table1 WHERE date=?', [date]);

    List<ProductionUpdate> list = res.isNotEmpty
        ? res.map((c) => ProductionUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<EquipmentUpdate>> getDailyEquipmentUpdate(String date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $table2 WHERE date=?', [date]);

    List<EquipmentUpdate> list = res.isNotEmpty
        ? res.map((c) => EquipmentUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<ProductionUpdate>> getMonthlyProductionUpdate(
      List<String> date) async {
    final db = await database;
    // var res = await db.rawQuery('SELECT * FROM $table WHERE date=?', [date]);

    final res = await db.query(
      table1,
      where: "date IN (${('?' * (date.length)).split('').join(', ')})",
      whereArgs: date,
    );

    List<ProductionUpdate> list = res.isNotEmpty
        ? res.map((c) => ProductionUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<EquipmentUpdate>> getMonthlyEquipmentUpdate(
      List<String> date) async {
    final db = await database;
    // var res = await db.rawQuery('SELECT * FROM $table WHERE date=?', [date]);

    final res = await db.query(
      table2,
      where: "date IN (${('?' * (date.length)).split('').join(', ')})",
      whereArgs: date,
    );

    List<EquipmentUpdate> list = res.isNotEmpty
        ? res.map((c) => EquipmentUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<ProductionUpdate>> getShiftProductionUpdate(
      String date, String shift) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $table1 WHERE date=? AND shift=?', [date, shift]);

    List<ProductionUpdate> list = res.isNotEmpty
        ? res.map((c) => ProductionUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<ProductionUpdate>> getShiftRangeProductionUpdate(
      List<String> date, String shift) async {
    final db = await database;
    // final res = await db.rawQuery(
    //     "SELECT * FROM $table1 WHERE $columnDate IN (${date.join(',')}) AND $columnShift ='$shift'");

    final res = await db.query(
      table1,
      where:
          "date IN (${('?' * (date.length)).split('').join(', ')}) AND $columnShift ='$shift'",
      whereArgs: date,
    );

    List<ProductionUpdate> list = res.isNotEmpty
        ? res.map((c) => ProductionUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<EquipmentUpdate>> getShiftEquipmentUpdate(
      String date, String shift) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $table2 WHERE date=? AND shift=?', [date, shift]);

    List<EquipmentUpdate> list = res.isNotEmpty
        ? res.map((c) => EquipmentUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<EquipmentUpdate>> getShiftRangeEquipmentUpdate(
      List<String> date, String shift) async {
    final db = await database;

    final res = await db.query(
      table2,
      where:
          "date IN (${('?' * (date.length)).split('').join(', ')}) AND $columnEShift ='$shift'",
      whereArgs: date,
    );

    List<EquipmentUpdate> list = res.isNotEmpty
        ? res.map((c) => EquipmentUpdate.fromJson(c)).toList()
        : [];
    return list;
  }

  createProduction(ProductionUpdate production) async {
    await deleteAllProductions();

    final db = await database;
    // Batch batch = db.batch();
    // batch.insert(table1, production.toJson());
    // final res = await batch.commit(noResult: true);
    // final res = await db.insert(table1, production.toJson());
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.insert(table1, production.toJson());
      await batch.commit(noResult: true, continueOnError: true);
    });

    // return res;
  }

  createEquipment(EquipmentUpdate equipment) async {
    await deleteAllEquipment();
    final db = await database;
    await db.transaction((txn2) async {
      var batch2 = txn2.batch();
      batch2.insert(table2, equipment.toJson());
      await batch2.commit(noResult: true, continueOnError: true);
    });
    // Batch batch = db.batch();
    // batch.insert(table2, equipment.toJson());
    // final res = await batch.commit(noResult: true);
    // // final res = await db.insert(table2, equipment.toJson());
    // return res;
  }

  Future<int> deleteAllProductions() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $table1');
    return res;
  }

  Future<int> deleteAllEquipment() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $table2');

    return res;
  }
}
