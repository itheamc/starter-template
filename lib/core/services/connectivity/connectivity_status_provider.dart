import 'dart:async';

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
        final hasInternet =
            connected ? await _service.hasActiveInternet() : false;
        state = connected && hasInternet;
      },
    );

    _timer = Timer.periodic(
      const Duration(milliseconds: 5000),
      (timer) async {
        await refresh();
      },
    );
  }

  /// Active Internet Connection Checker Timer
  ///
  Timer? _timer;

  /// ConnectivityService
  ///
  final ConnectivityService _service;

  /// Connectivity Stream
  ///
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// Function to update internet status
  ///
  Future<void> _updateInternetStatus(List<ConnectivityResult> results) async {
    final connected = _getStatus(results);
    if (state != connected) {
      final hasInternet =
          connected ? await _service.hasActiveInternet() : false;
      state = connected && hasInternet;
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

  Future<bool> refresh() async {
    final connected = await _service.hasActiveConnection();
    final hasInternet = connected ? await _service.hasActiveInternet() : false;
    final updated = connected && hasInternet;
    if (mounted) state = updated;
    return updated;
  }

  /// Cancelling the subscription on dispose
  ///
  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
    _timer?.cancel();
  }
}
