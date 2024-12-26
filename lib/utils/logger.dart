import 'package:flutter/cupertino.dart';

class Logger {
  static void logSuccess(dynamic message) {
    debugPrint('✅✅✅ ${message?.toString()} ✅✅✅');
  }

  static void logError(dynamic message) {
    debugPrint('❌❌❌ ${message?.toString()} ❌❌❌');
  }

  static void logWarning(dynamic message) {
    debugPrint('⚠️⚠️⚠️ ${message?.toString()} ⚠️⚠️⚠️');
  }

  static void logMessage(dynamic message) {
    debugPrint('➡️➡️➡️ ${message?.toString()} ⬅️⬅️⬅️');
  }
}
