import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../utils/logger.dart';
import 'tables/users/users_table.dart';

/// A singleton class that provides access to the SQLite database.
///
/// The [DatabaseProvider] class is responsible for initializing the database,
/// creating tables, handling migrations, and providing a single instance of
/// the database throughout the application.
class DatabaseProvider {
  /// The SQLite database instance.
  ///
  Database? _database;

  /// The name of the database file.
  ///
  static const _dbName = 'memory-map-app.db';

  /// The version of the database.
  ///
  /// This should be incremented whenever the database schema is updated.
  static const _dbVersion = 1;

  /// The singleton instance of [DatabaseProvider].
  static final DatabaseProvider instance = DatabaseProvider._();

  /// Private constructor to create the singleton instance.
  DatabaseProvider._() {
    _initDatabase().then((db) {
      _database = db;
    });
  }

  /// Gets the database instance asynchronously.
  ///
  /// If the database is already initialized, it returns the existing instance.
  /// Otherwise, it initializes the database and then returns the instance.
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();

    return _database;
  }

  /// Initializes the database.
  ///
  /// This method sets up the database by specifying the file path, version,
  /// and the onCreate and onUpgrade callbacks.
  ///
  /// Returns the initialized [Database] instance.
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();

    return await openDatabase(
      join(path, _dbName),
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          await _runMigrationScript(db, i);
        }
      },
    );
  }

  /// Initializes the database schema by creating the necessary tables.
  ///
  ///This method is called during the database creation process and is responsible
  /// for setting up the structure of the database.
  Future<void> _onCreate(Database database, int version) async {
    await UsersTable.instance.createTable(database);
  }

  /// Runs the migration script for the given version.
  ///
  /// This method is called during the database upgrade to migrate the
  /// database schema to a newer version.
  ///
  /// [db] is the database instance.
  /// [version] is the target version for the migration.
  Future<void> _runMigrationScript(Database db, int version) async {
    await UsersTable.instance.migrateTable(db, version);
  }

  /// Clears all the tables in the database.
  ///
  /// This method deletes all the records in the specified tables.
  ///
  /// [close] specifies whether to close the database after clearing the tables.
  /// The default value is `false`.
  Future<void> clearAll({bool close = false}) async {
    try {
      await UsersTable.instance.deleteTable();

      final db = await database;

      if (db == null) return;

      if (close) await db.close();
    } catch (e) {
      Logger.logError(e.toString());
    }
  }
}
