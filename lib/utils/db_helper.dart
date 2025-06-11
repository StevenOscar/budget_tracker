import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static String userTable = "user";
  static String transactionTable = "transactions";
  static Future<Database> _db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, "tracker_app.db"),
      onCreate: (db, version) async {
        Batch batch = db.batch();
        batch.execute('''
          CREATE TABLE $userTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            username TEXT,
            password TEXT,
            phone_number TEXT,
            monthly_expense INTEGER
          )
        ''');
        batch.execute('''
          CREATE TABLE $transactionTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            amount INTEGER,
            type INTEGER,
            note TEXT,
            category TEXT,
            date TEXT,
            time TEXT,
            FOREIGN KEY (user_id) REFERENCES $userTable(id) ON DELETE CASCADE
          )
        ''');
        await batch.commit();
      },
      version: 1,
    );
  }

  static Future<void> insertUserData({required UserModel data}) async {
    Database database = await _db();
    print("data : ${data.toMap()}");
    await database.insert(
      userTable,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<bool> checkUserDataAvailability({
    required String username,
  }) async {
    Database database = await _db();
    final user = await database.query(
      userTable,
      where: "username = ?",
      whereArgs: [username],
    );

    if (user.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> authenticateUser({
    required String username,
    required String password,
  }) async {
    Database database = await _db();
    List<Map<String, dynamic>> data = await database.query(
      userTable,
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );
    if (data.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<UserModel?> getUserData({required String username}) async {
    Database database = await _db();
    List<Map<String, dynamic>> data = await database.query(
      userTable,
      where: "username = ?",
      whereArgs: [username],
    );
    if (data.isNotEmpty) {
      return UserModel.fromMap(data.first);
    } else {
      return null;
    }
  }

  static Future<void> updateUserTarget({required String username, required int target}) async {
    Database database = await _db();
    await database.update(
      userTable,
      {'monthly_expense': target},
      where: "username = ?",
      whereArgs: [username],
    );
  }

  static Future<void> insertTransactionData({
    required TransactionModel data,
  }) async {
    Database database = await _db();
    print("data : ${data.toMap()}");
    await database.insert(
      transactionTable,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateTransactionData({
    required TransactionModel data,
  }) async {
    Database database = await _db();
    print("data : ${data.toMap()}");
    await database.update(
      transactionTable,
      data.toMap(),
      where: "id = ?",
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteTransactionData(int id) async {
    Database database = await _db();
    await database.delete(transactionTable, where: "id = ?", whereArgs: [id]);
  }

  static Future<List<TransactionModel>> getTransactionData({
    required int userId,
  }) async {
    Database database = await _db();
    List<Map<String, dynamic>> data = await database.query(
      transactionTable,
      where: "user_id = ?",
      whereArgs: [userId],
    );
    return data.map((e) => TransactionModel.fromMap(e)).toList();
  }
}
