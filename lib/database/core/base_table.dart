import 'dart:async';
import 'sql_query_builder.dart';
import 'package:sqflite/sqflite.dart';
import '../../../utils/logger.dart';
import '../database_provider.dart';
import 'base_schema.dart';

/// An abstract class representing a table for a generic entity type [T].
///
/// This class serves as a base for creating various tables for different
/// entities. It defines the common operations that any table should
/// implement, such as creating the table, inserting, updating, deleting,
/// and querying records.
///
/// The type parameter [T] represents the entity class.
abstract class BaseTable<T extends BaseSchema> {
  /// The name of the table.
  ///
  /// Each derived class should specify the table name for the entity.
  String get tableName;

  /// The list of columns for querying in
  ///
  /// The query given in fetch [fetch] function will execute on this columns
  List<String> get columns4Query;

  /// The column for order by
  ///
  /// Fetched items will be ordered by this column
  String get column4OrderBy;

  /// Method to get Schema [T] from json data
  ///
  /// This will lead to convert json data to the schema [T]
  T fromJson(dynamic json);

  /// Creates the table in the database.
  ///
  /// This method should be called during the database initialization to
  /// create the table structure in the database.
  Future<void> createTable(Database database);

  /// Migrate the table in the database.
  ///
  /// This method should be called during the database initialization to
  /// create the table structure in the database.
  Future<void> migrateTable(Database db, int version);

  /// Inserts a new record into the table.
  ///
  /// [schema] is the instance of [T] to be inserted.
  /// Returns inserted [T] if the insert was successful, otherwise `null`.
  Future<T?> insert(T schema) async {
    try {
      final database = await DatabaseProvider.instance.database;
      final id = await database?.insert(
        tableName,
        schema.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return id != null ? schema.copy(id: id) as T : null;
    } catch (e) {
      Logger.logError(e.toString());
      return null;
    }
  }

  /// Updates an existing record in the table.
  ///
  /// [id] is the identifier of the record to be updated.
  /// [schema] is the instance of [T] with updated data.
  /// Returns updated [T] if the update was successful, otherwise `null`.
  Future<T?> update(int id, T schema) async {
    try {
      final database = await DatabaseProvider.instance.database;

      final count = await database?.update(
        tableName,
        schema.toJson(),
        where: "id = ?",
        whereArgs: [
          schema.id ?? id,
        ],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (count != null && count > 0) {
        final updated = await get(id);

        return updated;
      }

      return null;
    } catch (e) {
      Logger.logError(e.toString());
      return null;
    }
  }

  /// Deletes a record from the table.
  ///
  /// [id] is the identifier of the record to be deleted.
  /// Returns `true` if the deletion was successful, otherwise `false`.
  Future<bool> delete(int id) async {
    try {
      final database = await DatabaseProvider.instance.database;

      final count = await database?.delete(
        tableName,
        where: "id = ?",
        whereArgs: [
          id,
        ],
      );

      return count != null && count > 0;
    } catch (e) {
      Logger.logError(e.toString());
      return false;
    }
  }

  /// Retrieves a record from the table by its identifier.
  ///
  /// [id] is the identifier of the record to be retrieved.
  /// Returns an instance of [T] if the record was found, otherwise `null`.
  Future<T?> get(int id) async {
    try {
      final database = await DatabaseProvider.instance.database;

      final query = await database?.query(
        tableName,
        where: "$id = ?",
        whereArgs: [id],
      );

      return query != null && query.isNotEmpty ? fromJson(query.first) : null;
    } catch (e) {
      Logger.logError(e.toString());
    }

    return null;
  }

  /// Fetches all records from the table.
  ///
  /// [limit] specifies the maximum number of records to fetch.
  /// [offset] specifies the starting point for the query.
  /// [query] is an optional search query to filter records.
  /// Returns a list of [T] instances.
  Future<List<T>> fetch({
    int page = 1,
    int limit = 50,
    String? query,
  }) async {
    try {
      final database = await DatabaseProvider.instance.database;

      final whereClause = query != null
          ? query.isNotEmpty
              ? columns4Query
                  .map((column) => 'LOWER($column) LIKE ?')
                  .join(' OR ')
              : null
          : null;

      final whereArgs = query != null && query.isNotEmpty
          ? [
              '%$query%',
              '%$query%',
              '%$query%',
            ]
          : null;

      final res = await database?.query(
        tableName,
        where: whereClause,
        whereArgs: whereArgs,
        limit: limit,
        offset: (page - 1) * limit,
        orderBy: '$column4OrderBy ASC',
      );

      final lst = res?.map((json) => fromJson(json)).toList(growable: true);

      return lst ?? List.empty();
    } catch (e) {
      Logger.logError(e.toString());
    }
    return List.empty();
  }

  /// Fetches records from the table with a custom SQL query.
  ///
  /// This method allows for advanced querying using SQL statements.
  /// It supports pagination, filtering, grouping, and sorting.
  ///
  /// [limit] specifies the maximum number of records to fetch.
  /// [page] specifies the page number for pagination. The default value is 1.
  /// [where] is the optional WHERE clause to apply filters.
  /// [whereArgs] contains the values that replace the ? placeholders in the WHERE clause.
  /// [groupBy] specifies the optional GROUP BY clause to group the results.
  /// [orderBy] specifies the optional ORDER BY clause to sort the results.
  ///
  /// Returns a list of [T] instances that match the query.
  Future<List<T>> fetchWithRawQuery({
    int page = 1,
    int limit = 50,
    String? where,
    List<Object?>? whereArgs,
    List<String>? columns,
    String? groupBy,
    String? orderBy,
  }) async {
    try {
      final database = await DatabaseProvider.instance.database;

      final res = await database?.query(tableName,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          limit: limit,
          offset: (page - 1) * limit,
          orderBy: orderBy,
          groupBy: groupBy);

      final lst = res?.map((json) => fromJson(json)).toList(growable: true);

      return lst ?? List.empty();
    } catch (e) {
      Logger.logError(e.toString());
    }
    return List.empty();
  }

  /// Executes a raw SQL query and maps the results to a list of [T] instances.
  ///
  /// This method provides a flexible way to interact with the database using custom SQL queries.
  /// It leverages the [SqlQueryBuilder] to construct the query and handle parameters.
  ///
  /// The [builder] parameter is an instance of [SqlQueryBuilder] that encapsulates the queryDetails:
  /// - `build()`: Generates the SQL query string.
  /// - `whereArgs`: Provides the values for any placeholders in the query.
  ///
  /// The method executes the query using the underlying database connection and maps the resulting
  /// rows to a list of [T] objects using the `fromJson` method.
  ///
  /// **Returns:**
  /// A [Future] that resolves to a list of [T] instances representing the query results.
  /// If an error occurs during the query execution, an empty list is returned.
  ///
  Future<List<T>> rawQuery({
    required SqlQueryBuilder builder,
  }) async {
    try {
      final database = await DatabaseProvider.instance.database;

      // If builder contains different table name or null update this with current
      // table name
      if (builder.tableName != tableName) {
        builder.table(tableName);
      }

      final res = await database?.rawQuery(builder.build(), builder.whereArgs);

      final lst = res?.map((json) => fromJson(json)).toList(growable: true);

      return lst ?? List.empty();
    } catch (e) {
      Logger.logError(e.toString());
    }
    return List.empty();
  }

  /// Retrieves the total number of records in the table.
  ///
  /// Returns the total count of records.
  Future<int> count() async {
    try {
      final database = await DatabaseProvider.instance.database;

      final q = 'SELECT COUNT(*) FROM $tableName';

      final res = await database?.rawQuery(q);

      if (res == null || res.isEmpty) return 0;

      if (res.first.containsKey('COUNT(*)')) {
        return Sqflite.firstIntValue(res) ?? 0;
      }
    } catch (e) {
      Logger.logError(e.toString());
    }
    return 0;
  }

  /// Delete the table.
  ///
  Future<void> deleteTable() async {
    try {
      final database = await DatabaseProvider.instance.database;
      database?.execute("DROP TABLE IF EXISTS $tableName");
    } catch (e) {
      Logger.logError(e.toString());
    }
  }
}
