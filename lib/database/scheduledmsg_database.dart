import 'dart:async';
import 'package:path/path.dart';
import 'package:mypo/model/scheduledmsg.dart';
import 'package:sqflite/sqflite.dart';

class ScheduledMessagesDataBase {
  //global field -> instance calling de constructor
  static final ScheduledMessagesDataBase instance =
      ScheduledMessagesDataBase._init();

  // field for data base
  static Database? _database;

  // private constructor
  ScheduledMessagesDataBase._init();

  //opening database
  Future<Database?> get database async {
    // return the database if it exist
    if (_database != null) return _database;

    //otherwise init db
    _database = await _initDB('database.db');
    return _database!;
  }

  //initializing db
  Future<Database> _initDB(String filePath) async {
    //storing db path
    final dbPath = await getDatabasesPath();
    // defining the file path to the db path in the device
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //creating db and tables
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    // final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
  CREATE TABLE $tableScheduledmsg (
    ${ScheduledmsgFields.id} $idType,
    ${ScheduledmsgFields.phoneNumber} $textType,
    ${ScheduledmsgFields.message} $textType,
    ${ScheduledmsgFields.date} $textType,
    ${ScheduledmsgFields.repeat} $textType,
    ${ScheduledmsgFields.countdown} $boolType,
    ${ScheduledmsgFields.confirm} $boolType,
    ${ScheduledmsgFields.notification} $boolType
  )
    ''');

    /*
    Create another table if needed
    */
  }

  // CRUD = Create Read Update Delete
  Future<Scheduledmsg> create(Scheduledmsg scheduledmsg) async {
    // ref to db
    final db = await instance.database;

    //inserting a scheduled msg to db
    final id = await db!.insert(tableScheduledmsg, scheduledmsg.toJson());

    //if we want to insert particular data in particular column
    // final json =scheduledmsg.toJson();
    // final columns = '${ScheduledmsgFields.phoneNumber} , ${ScheduledmsgFields.message}, ${ScheduledmsgFields.date}, ${ScheduledmsgFields.repeat}, ${ScheduledmsgFields.countdown}, ${ScheduledmsgFields.confirm}, ${ScheduledmsgFields.notification}';
    // final values = '${json[ScheduledmsgFields.phoneNumber]} , ${json[ScheduledmsgFields.message]}, ${json[ScheduledmsgFields.date]}, ${json[ScheduledmsgFields.repeat]}, ${json[ScheduledmsgFields.countdown]}, ${json[ScheduledmsgFields.confirm]}, ${json[ScheduledmsgFields.notification]}';
    // final id = await db.rawInsert('INSERT INTO $tableScheduledmsg ($columns) VALUES ($values)');

    // after inserting we always get a unique id that we want to update
    return scheduledmsg.copy(id: id);
  }

  Future<Scheduledmsg> readScheduledmsg(int id) async {
    final db = await instance.database;

    final maps = await db!.query(
      tableScheduledmsg,
      columns: ScheduledmsgFields.values,
      where: '${ScheduledmsgFields.id} = ?',
      whereArgs: [id], // preventing sql injection attacks
    );

    if (maps.isNotEmpty) {
      return Scheduledmsg.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
      // return null;
    }
  }

  Future<int> update(Scheduledmsg scheduledmsg) async {
    final db = await instance.database;

    return db!.update(
      tableScheduledmsg,
      scheduledmsg.toJson(),
      where: '${ScheduledmsgFields.id} = ?',
      whereArgs: [scheduledmsg.id], // preventing sql injection attack
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db!.delete(
      tableScheduledmsg,
      where: '${ScheduledmsgFields.id} = ?',
      whereArgs: [id], // preventing sql injection attack
    );
  }

  Future<List<Scheduledmsg>> readAllScheduledmsg() async {
    final db = await instance.database;
    final orderBy = '${ScheduledmsgFields.date} ASC';
    final result = await db!.query(tableScheduledmsg, orderBy: orderBy);

    //raw query statements
    //final result = db.rawQuery('SELECT * FROM $tableScheduledmsg ORDER BY $orderBy');

    // for each object we convert it back to Scheduledmsg type
    return result.map((json) => Scheduledmsg.fromJson(json)).toList();
  }

  // closing db
  Future close() async {
    var db = await instance.database;
    db!.close();
    db = null;
  }
}
