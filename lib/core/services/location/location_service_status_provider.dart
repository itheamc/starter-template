import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service_provider.dart';

final locationServiceStatusStateProvider =
    StateNotifierProvider<LocationServiceStatusStateNotifier, bool>((ref) {
  return LocationServiceStatusStateNotifier(
    true,
    ref,
  );
});

class LocationServiceStatusStateNotifier extends StateNotifier<bool> {
  LocationServiceStatusStateNotifier(super.state, this._ref);

  /// Ref
  ///
  final Ref _ref;

  /// Method to check device location service
  ///
  Future<void> checkLocationServiceStatus({
    void Function(bool)? onCompleted,
  }) async {
    final locationService = _ref.read(locationServiceProvider);
    final enabled = await locationService.isLocationEnabled();

    if (enabled) {
      final hasPermission = await locationService.hasPermission();

      if (mounted) state = hasPermission;
      onCompleted?.call(state);
      return;
    }

    if (mounted) state = enabled;
    onCompleted?.call(enabled);
  }
}
