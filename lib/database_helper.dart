import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'transaction.dart';
import 'savings_goal.dart';


class DatabaseHelper {
  static sql.Database? _database;
  static const String transactionTable = 'transactions';
  static const String savingsTable = 'savings_goals';


  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<sql.Database> _initDatabase() async {
    String path = join(await sql.getDatabasesPath(), 'finance.db');
    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
         CREATE TABLE $transactionTable (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           title TEXT,
           amount REAL,
           type TEXT,
           category TEXT,
           date TEXT
         )
       ''');
        await db.execute('''
         CREATE TABLE $savingsTable (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           title TEXT,
           targetAmount REAL,
           savedAmount REAL
         )
       ''');
      },
    );
  }


  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;
    return await db.insert(transactionTable, transaction.toMap());
  }


  Future<List<Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        transactionTable, orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<void> deleteAllTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }

  Future<int> insertSavingsGoal(SavingsGoal goal) async {
    final db = await database;
    return await db.insert('savings_goals', goal.toMap());
  }

  Future<List<SavingsGoal>> getSavingsGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('savings_goals');
    return List.generate(maps.length, (i) => SavingsGoal.fromMap(maps[i]));
  }

  Future<void> deleteSavingsGoal(int id) async {
    final db = await database;
    await db.delete('savings_goals', where: 'id = ?', whereArgs: [id]);
  }
}



