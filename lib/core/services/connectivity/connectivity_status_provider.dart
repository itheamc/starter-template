import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connectivity_service.dart';

final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityStatusStateNotifier, bool>(
  (ref) {
    return ConnectivityStatusStateNotifier(true);
  },
);

/// ConnectivityStatusStateNotifier
///
class ConnectivityStatusStateNotifier extends StateNotifier<bool> {
  ConnectivityStatusStateNotifier(
    super.state,
  ) : _service = ConnectivityService.instance {
    _connectivitySubscription =
        _service.onConnectivityChanged.listen(_updateInternetStatus);

    _service.hasActiveConnection().then(
      (connected) async {
        final hasInternet = connected ? await _hasActiveInternet() : false;
        state = connected && hasInternet;
      },
    );
  }

  /// ConnectivityService
  ///
  final ConnectivityService _service;

  /// Connectivity Stream
  ///
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// Function to update internet status
  ///
  Future<void> _updateInternetStatus(List<ConnectivityResult> results) async {
    if (state != _getStatus(results)) {
      final isConnected = _getStatus(results);
      final hasInternet = isConnected ? await _hasActiveInternet() : false;
      state = isConnected && hasInternet;
    }
  }

  /// Function to get internet status from the connectivity result
  ///
  bool _getStatus(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.bluetooth);
  }

  /// Method to check if connected network has really internet connection or not
  ///
  Future<bool> _hasActiveInternet() async {
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

  /// Cancelling the subscription on dispose
  ///
  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
}
