import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/logger.dart';

class ConnectivityService {
  /// Connectivity Instance
  ///
  final Connectivity _connectivity;

  /// Private internal constructor
  ///
  ConnectivityService._() : _connectivity = Connectivity();

  /// Private instance of ConnectivityService
  ///
  static ConnectivityService? _instance;

  /// Lazy-loaded singleton instance of this class
  ///
  static ConnectivityService get instance {
    if (_instance == null) {
      Logger.logMessage("ConnectivityService is initialized!");
    }
    _instance ??= ConnectivityService._();
    return _instance!;
  }

  /// Checking Internet Connectivity
  ///
  Future<bool> hasActiveConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.bluetooth);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  /// Method to check if connected network has really internet connection or not
  ///
  Future<bool> hasActiveInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Listening the connectivity change status
  ///
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
