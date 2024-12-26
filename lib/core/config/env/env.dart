import 'package:flutter/services.dart';
import '../../../utils/logger.dart';

/// Env for handling environment variables
///
class Env {
  /// Private internal constructor
  ///
  Env._internal() : _variables = <String, String>{};

  /// Private instance of instance
  ///
  static Env? _instance;

  /// Lazy-loaded singleton instance of this class
  ///
  static Env get instance {
    if (_instance == null) {
      Logger.logMessage("Env is initialized!");
    }
    _instance ??= Env._internal();
    return _instance!;
  }

  /// Singleton instance of this class
  ///
  // static final Env instance = Env._internal();

  /// Variables that store key value pairs
  ///
  final Map<String, String> _variables;

  /// Method to get value by key
  /// [key] - Key specified in .env file
  /// [defaultValue] - Default fallback value if not found in env
  ///
  String? valueOf(String key, {String? defaultValue}) =>
      _variables[key] ?? defaultValue;

  /// Method to load .env file from the
  ///
  Future<void> load() async {
    try {
      // Getting file contents from the file .env
      final fileContent = await rootBundle.loadString(".env");

      // Parsing file contents and getting key value pairs
      final variables = await _parse(fileContent);

      // clearing _variables to make it empty
      _variables.clear();

      // Adding variables to the _variables
      _variables.addAll(variables);
    } catch (e) {
      Logger.logError(e.toString());
    }
  }

  /// Function to parse .env file and return a Map<String, String>
  ///
  Future<Map<String, String>> _parse(String fileContent) async {
    // Split the file content into lines
    final lines = fileContent.split('\n');

    // Create a Map to store the key-value pairs
    Map<String, String> pairs = {};

    // Regular expression for matching key-value pairs
    RegExp regex = RegExp(
        r'''^\s*([\w.-]+)\s*=\s*([\'"]?)([^\n\r]*?)\2(?:(?:\s+#.*)?)$''');

    // Iterate over each line to extract key-value pairs
    for (var line in lines) {
      // Remove unnecessary whitespaces
      line = line.trim();

      // Ignore comments (starting with #) and empty lines
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }

      // Try to match the line using the regex
      var match = regex.firstMatch(line);

      if (match != null) {
        // Extract the key and value from the regex match
        String key = match.group(1) ?? '';
        String value = match.group(3) ?? '';

        // Add key-value pair to the map
        pairs[key] = value;
      }
    }

    return pairs;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Env &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => _variables.hashCode;
}
