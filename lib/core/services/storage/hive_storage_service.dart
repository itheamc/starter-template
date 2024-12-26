import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/logger.dart';
import 'storage_service.dart';

/// [StorageService] interface implementation using the Hive package
///
class HiveStorageService implements StorageService {
  /// A Hive Box for storing data
  ///
  Box<dynamic>? _hiveBox;

  /// Private static instance, initialized lazily.
  ///
  static HiveStorageService? _instance;

  /// Private Constructor
  ///
  HiveStorageService._internal();

  /// Lazy-loaded singleton instance of this class
  ///
  static HiveStorageService get instance {
    if (_instance == null) {
      Logger.logMessage("HiveStorageService is initialized!");
    }
    _instance ??= HiveStorageService._internal();
    return _instance!;
  }

  @override
  Future<void> init(String name) async {
    try {
      // Initialize hive
      final cacheDir = await getApplicationCacheDirectory();
      Hive.init(cacheDir.path);

      _hiveBox = await Hive.openBox<dynamic>(name);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> remove(String key) async {
    await _hiveBox?.delete(key);
  }

  @override
  dynamic get(String key, {dynamic defaultValue}) {
    return _hiveBox?.get(key, defaultValue: defaultValue);
  }

  @override
  bool has(String key) {
    return _hiveBox?.containsKey(key) ?? false;
  }

  @override
  Future<void> set(String? key, dynamic data) async {
    await _hiveBox?.put(key, data);
  }

  @override
  Future<void> clear() async {
    await _hiveBox?.clear();
  }

  @override
  Future<void> close() async {
    await _hiveBox?.close();
  }
}
