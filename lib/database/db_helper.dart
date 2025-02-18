import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        userType TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE admins (
        adminId INTEGER PRIMARY KEY AUTOINCREMENT,
        adminName TEXT NOT NULL,
        membershipID INTEGER NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (userId) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE businessOwners (
        businessId INTEGER PRIMARY KEY AUTOINCREMENT,
        businessName TEXT NOT NULL,
        membershipID INTEGER NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (userId) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE customers (
        customerId INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        location TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (userId) ON DELETE CASCADE
      );
    ''');
  }

  // Insert a new user
  Future<int> insertUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert an admin
  Future<int> insertAdmin(Admin admin) async {
    final db = await instance.database;
    int userId = await insertUser(admin);
    return await db.insert('admins', {
      'adminId': admin.adminId,
      'adminName': admin.adminName,
      'membershipID': admin.membershipID,
      'userId': userId,
    });
  }

  // Insert a business owner
  Future<int> insertBusinessOwner(BusinessOwner businessOwner) async {
    final db = await instance.database;
    int userId = await insertUser(businessOwner);
    return await db.insert('businessOwners', {
      'businessId': businessOwner.businessId,
      'businessName': businessOwner.businessName,
      'membershipID': businessOwner.membershipID,
      'userId': userId,
    });
  }

  // Insert a customer
  Future<int> insertCustomer(Customer customer) async {
    final db = await instance.database;
    int userId = await insertUser(customer);
    return await db.insert('customers', {
      'customerId': customer.customerId,
      'customerName': customer.customerName,
      'location': customer.location,
      'userId': userId,
    });
  }

  // Fetch user by email
  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Update user
  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return await db.update('users', user.toMap(), where: 'userId = ?', whereArgs: [user.userId]);
  }

  // Delete user
  Future<int> deleteUser(int userId) async {
    final db = await instance.database;
    return await db.delete('users', where: 'userId = ?', whereArgs: [userId]);
  }
}
