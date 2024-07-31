
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'User.dart';

class DatabaseHelper {
  static final _dbName = 'StudentDB.db';
  static final _dbVersion = 1;
  static final _tableName = 'students';
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnGender = 'gender';
  static final columnStudentId = 'student_id';
  static final columnLevel = 'level';
  static final columnPassword = 'password';
  static final columnProfilePhotoUrl = 'profile_photo_url';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // Open the database and create it if it doesn't exist
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_tableName (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnEmail TEXT NOT NULL UNIQUE,
            $columnGender TEXT,
            $columnStudentId TEXT NOT NULL UNIQUE,
            $columnLevel INTEGER,
            $columnPassword TEXT NOT NULL,
            $columnProfilePhotoUrl TEXT  
          )
          ''');
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$columnEmail =? AND $columnPassword =?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateUser(User user) async {
    print('Before update: ${user.toMap()}');
    final db = await database;
    await db.update(
      _tableName,
      user.toMap(),
      where: '$columnEmail =? AND $columnPassword =?',
      whereArgs: [user.email, user.password],
    );
    print('After update: ${user.toMap()}');
  }

}
