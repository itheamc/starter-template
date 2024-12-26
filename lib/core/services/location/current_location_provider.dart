import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_coordinate.dart';
import 'location_service.dart';
import 'location_service_provider.dart';
import 'package:location/location.dart';

final currentLocationProvider =
    StateNotifierProvider<CurrentLocationStateNotifier, LocationCoordinate?>(
        (ref) {
  final locationService = ref.read(locationServiceProvider);
  return CurrentLocationStateNotifier(
    null,
    locationService,
  );
});

/// CurrentLocationStateNotifier
///
class CurrentLocationStateNotifier extends StateNotifier<LocationCoordinate?> {
  CurrentLocationStateNotifier(
    super.state,
    this._service,
  );

  /// Location Handler
  ///
  final LocationService _service;

  /// Location Stream
  ///
  late StreamSubscription<LocationData> _locationSubscription;

  /// Initialization status
  ///
  bool _alreadySubscribed = false;

  /// Method to subscribe location update
  ///
  void subscribeLocationUpdate() {
    if (_alreadySubscribed) return;

    _locationSubscription =
        _service.locationStream.listen(_updateCurrentLocation);

    _alreadySubscribed = true;

    _service.getCurrentLocation().then((l) {
      if (l != null) {
        _updateCurrentLocation(l);
      }
    });
  }

  /// Function to update Location
  ///
  void _updateCurrentLocation(LocationData location) {
    final latLng = _fromLocationData(location);

    if (latLng != null) state = latLng;
  }

  /// Method to get LatLng from the LocationData
  ///
  LocationCoordinate? _fromLocationData(LocationData location) {
    if (location.latitude != null && location.longitude != null) {
      return LocationCoordinate(
        location.latitude!,
        location.longitude!,
        accuracy: location.accuracy,
        altitude: location.altitude,
        speed: location.speed,
      );
    }

    return null;
  }

  /// Cancelling the subscription on dispose
  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
  }
}
