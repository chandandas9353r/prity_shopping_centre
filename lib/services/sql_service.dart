import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as p;

class DatabaseHelper{
  sql.Database? _database;
  int id = 0;
  DatabaseHelper(){
    initialise;
  }

  Future<void> get initialise async {
    if(_database != null){
      _database = _database;
      return;
    }
    String dbPath = await sql.getDatabasesPath();
    String path = p.join(dbPath,'products.db');
    _database = await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await initialiseTables(db),
    );
  }

  Future<void> initialiseTables(sql.Database database) async {
    database.rawQuery('''
      CREATE TABLE PRODUCTS(
        id INTEGER PRIMARY KEY NOT NULL,
        image STRING NOT NULL,
        name STRING NOT NULL,
        description STRING,
        price INTEGER NOT NULL
      );
    ''');
  }

  Future<void> getId(List<Map<String, Object?>>? data) async {
    id = (data?.last['id'] as int) + 1;
  }

  Future<List<Map<String, Object?>>?> get getData async {
    await initialise;
    var data = await _database?.rawQuery('''
      SELECT * FROM PRODUCTS;
    ''');
    if(data?.isNotEmpty == true) await getId(data);
    return data;
  }

  Future<bool> insertData(
    int id,
    String image,
    String name,
    String description,
    int price,
  ) async {
    await initialise;
    int? result = await _database?.insert(
      'PRODUCTS',
      {
        'id' : id,
        'image' : image,
        'name' : name,
        'description' : description,
        'price' : price,
      },
    );
    if(result != id) return false;
    return true;
  }

  Future<bool> get deleteData async {
    await initialise;
    await _database?.delete('PRODUCTS');
    return true;
  }
}