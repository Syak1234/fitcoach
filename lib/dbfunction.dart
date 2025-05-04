import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WorkoutDatabase {
  // Singleton pattern for database
  static final WorkoutDatabase instance = WorkoutDatabase._init();
  static Database? _database;

  WorkoutDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workout.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final dbLocation = join(dbPath, path);

    return await openDatabase(dbLocation, version: 1, onCreate: _onCreate);
  }

  // Create the table
  // Create the table only if it doesn't exist
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS workouts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      workoutname TEXT NOT NULL,
      kg INTEGER NOT NULL,
      reps INTEGER NOT NULL,
      sets INTEGER NOT NULL,
      workoutimg TEXT
    )
  ''');
  }

  // Insert a new workout
  Future<int> insertWorkout(Map<String, dynamic> workout) async {
    final db = await instance.database;

    // Check if the workout already exists based on a unique field
    final List<Map<String, dynamic>> existing = await db.query(
      'workouts',
      where: 'workoutname = ? AND kg = ? AND reps = ? AND sets = ?',
      whereArgs: [
        workout['workoutname'],
        workout['kg'],
        workout['reps'],
        workout['sets'],
      ],
    );

    if (existing.isNotEmpty) {
      // Duplicate found, return -1 to indicate no insert
      return -1;
    }

    // Insert if not duplicate
    return await db.insert('workouts', workout);
  }

  // Fetch all workouts
  Future<List<Map<String, dynamic>>> fetchAllWorkouts() async {
    final db = await instance.database;
    return await db.query('workouts');
  }

  // Update a workout
  Future<int> updateWorkout(Map<String, dynamic> workout) async {
    final db = await instance.database;
    int id = workout['id'];
    return await db.update(
      'workouts',
      workout,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a workout
  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
