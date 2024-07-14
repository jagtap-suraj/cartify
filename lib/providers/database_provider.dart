import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Cartify.db");
    var database = await openDatabase(path, version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE Users ("
        "id TEXT PRIMARY KEY, "
        "name TEXT, "
        "email TEXT, "
        "password TEXT, "
        "address TEXT, "
        "type TEXT, "
        "token TEXT"
        ")");
    await database.execute("CREATE TABLE Products ("
        "id TEXT PRIMARY KEY, "
        "name TEXT, "
        "description TEXT, "
        "quantity REAL, "
        "images TEXT, "
        "category TEXT, "
        "price REAL, "
        "sellerId TEXT"
        ")");
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // Perform database upgrade
    }
  }
}
