
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'employee_model.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  // Get database or initialize it.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Create / Open database
  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = join(directory.path, 'fleetops.db');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDatabase,
      ),
    );
  }

  // Create employees table
  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        department TEXT NOT NULL,
        role TEXT NOT NULL,
        vehicle TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    // Insert initial demo records only once.
    final batch = db.batch();

    batch.insert('employees', {
      'name': 'Muhammad Ali',
      'department': 'IT',
      'role': 'Employee',
      'vehicle': 'Toyota Corolla',
      'status': 'Active',
    });

    batch.insert('employees', {
      'name': 'Ayesha Khan',
      'department': 'Finance',
      'role': 'Manager',
      'vehicle': 'Honda Civic',
      'status': 'Active',
    });

    batch.insert('employees', {
      'name': 'Ahmed Raza',
      'department': 'Operations',
      'role': 'Employee',
      'vehicle': '-',
      'status': 'Active',
    });

    batch.insert('employees', {
      'name': 'Sara Ahmed',
      'department': 'HR',
      'role': 'Employee',
      'vehicle': 'Suzuki Swift',
      'status': 'Inactive',
    });

    await batch.commit(noResult: true);
  }

  // CREATE: Insert employee
  Future<int> insertEmployee(Employee employee) async {
    final db = await database;

    return await db.insert(
      'employees',
      employee.toMap(),
    );
  }

  // READ: Get all employees
  Future<List<Employee>> getEmployees() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(
      'employees',
      orderBy: 'id DESC',
    );

    return maps.map((map) {
      return Employee.fromMap(map);
    }).toList();
  }

  // UPDATE: Update employee
  Future<int> updateEmployee(Employee employee) async {
    final db = await database;

    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  // DELETE: Delete employee
  Future<int> deleteEmployee(int id) async {
    final db = await database;

    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Optional: Close database connection
  Future<void> closeDatabase() async {
    final db = _database;

    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
