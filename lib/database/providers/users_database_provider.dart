import 'package:sqflite/sqflite.dart';

import '../../utils/logger.dart';
import '../core/base_database_provider.dart';
import '../tables/users/users_table.dart';

class UsersDatabaseProvider extends BaseDatabaseProvider {
  UsersDatabaseProvider._();

  static final UsersDatabaseProvider instance = UsersDatabaseProvider._();

  @override
  String get databaseName => 'users.db';

  @override
  int get databaseVersion => 1;

  @override
  Future<void> onCreate(Database db, int version) async {
    await UsersTable.instance.createTable(db);
  }

  @override
  Future<void> runMigrationScript(Database db, int version) async {
    await UsersTable.instance.migrateTable(db, version);
  }

  @override
  Future<void> deleteTables() async {
    try {
      await UsersTable.instance.deleteTable();
    } catch (e) {
      Logger.logError(e.toString());
    }
  }

  @override
  Future<void> close() async {
    try {
      final db = await database;
      if (db == null) return;
      await db.close();
    } catch (e) {
      Logger.logError(e.toString());
    }
  }
}
