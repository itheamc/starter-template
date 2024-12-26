import 'package:location/location.dart';

import '../../../utils/logger.dart';

class LocationService {
  /// Location Instance
  ///
  final Location _location;

  /// Private internal constructor
  ///
  LocationService._() : _location = Location.instance;

  /// Private instance of LocationService
  ///
  static LocationService? _instance;

  /// Lazy-loaded singleton instance of this class
  ///
  static LocationService get instance {
    if (_instance == null) {
      Logger.logMessage("LocationService is initialized!");
    }
    _instance ??= LocationService._();
    return _instance!;
  }

  /// Method to check whether location service is enabled or not
  ///
  Future<bool> isLocationEnabled() async {
    try {
      return await _location.serviceEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Method to request location service
  ///
  Future<bool> requestLocationService() async {
    try {
      return await _location.requestService();
    } catch (e) {
      return false;
    }
  }

  /// Method to check whether location permission is provided or not
  ///
  Future<bool> hasPermission() async {
    try {
      final status = await _location.hasPermission();
      return status == PermissionStatus.grantedLimited ||
          status == PermissionStatus.granted;
    } catch (e) {
      return false;
    }
  }

  /// Method to request location permission
  ///
  Future<bool> requestPermission() async {
    try {
      final status = await _location.requestPermission();

      return status == PermissionStatus.grantedLimited ||
          status == PermissionStatus.granted;
    } catch (e) {
      return false;
    }
  }

  /// Method to check and request location service and permission
  /// [onCompleted] -> callback which will be triggered if request is completed
  /// [retries] -> It is the max retries for location service request
  ///
  Future<void> checkAndRequestLocationPermission({
    required void Function(bool granted) onCompleted,
    int retries = 2,
  }) async {
    try {
      // Check if location service is enabled or not
      bool enabled = await isLocationEnabled();

      // If location service is enabled
      if (enabled) {
        // Check if has permission
        final permission = await hasPermission();

        // If has permission return from here
        if (permission) {
          onCompleted.call(permission);
          return;
        }

        // If don't have permission and retries left
        if (retries > 0) {
          // request location permission
          final granted = await requestPermission();

          if (granted) {
            onCompleted.call(granted);
            return;
          } else {
            await checkAndRequestLocationPermission(
              onCompleted: onCompleted,
              retries: retries - 1,
            );
            return;
          }
        }

        onCompleted.call(false);
        return;
      }

      // If location service is not enabled
      // Then request to enable it
      if (retries > 0) {
        await requestLocationService();
        await checkAndRequestLocationPermission(
          onCompleted: onCompleted,
          retries: retries - 1,
        );
      } else {
        onCompleted.call(false);
      }
    } catch (e) {
      onCompleted.call(false);
    }
  }

  /// Method to get the current location
  ///
  Future<LocationData?> getCurrentLocation() async {
    try {
      final enabled = await _location.serviceEnabled();

      if (!enabled) return null;

      final permission = await hasPermission();

      if (!permission) return null;

      final loc = await _location.getLocation();

      return loc;
    } catch (e) {
      return null;
    }
  }

  /// Method to check whether background mode is enabled or not
  ///
  Future<bool> isBackgroundModeEnabled() async {
    try {
      return await _location.isBackgroundModeEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Method to enable/disable background mode
  ///
  Future<bool> enableBackgroundMode({
    bool enable = true,
  }) async {
    try {
      return await _location.enableBackgroundMode(enable: enable);
    } catch (e) {
      return false;
    }
  }

  /// Method to update location settings
  ///
  Future<bool> updateLocationSettings({
    LocationAccuracy? accuracy = LocationAccuracy.high,
    int? interval = 1000,
    double? distanceFilter = 0,
  }) async {
    try {
      return await _location.changeSettings(
        accuracy: accuracy,
        interval: interval,
        distanceFilter: distanceFilter,
      );
    } catch (e) {
      return false;
    }
  }

  /// Getter to listen location stream
  ///
  Stream<LocationData> get locationStream => _location.onLocationChanged;
}
