import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

import '../../../../core/services/location/current_location_provider.dart';
import '../../../../ui/features/map/models/queried_feature.dart';

final mapStateProvider = ChangeNotifierProvider<MapStateNotifier>((ref) {
  return MapStateNotifier(ref);
});

class MapStateNotifier extends ChangeNotifier {
  /// Constructor
  ///
  MapStateNotifier(this._ref);

  /// Ref
  ///
  final Ref _ref;

  /// MapLibreMap Controller
  ///
  MapLibreMapController? _controller;

  /// Fully Loaded status flag
  ///
  bool _fullyLoaded = false;

  bool get fullyLoaded => _fullyLoaded;

  /// Method to handle onMapCreated callback
  ///
  void onMapCreated(
    MapLibreMapController controller, {
    void Function(LatLng? latLng, QueriedFeature? feature)? onFeatureClick,
  }) {
    _controller = controller;

    // Adding on feature callback
    _controller?.onFeatureTapped.add(
      (id, point, latLng, layerId) async {
        final feature = await NaxaMapUtils.featureFromPoint(_controller, point);
        onFeatureClick?.call(
          latLng,
          feature != null ? QueriedFeature.fromJson(feature) : null,
        );
      },
    );

    // Set fully loaded to true
    _fullyLoaded = true;

    // Notifying widgets to update on fully loaded
    Future.delayed(const Duration(milliseconds: 500), () {
      if (hasListeners) notifyListeners();
    });

    // Animate camera to current location
    locateUserCurrentLocation();
  }

  /// Method to handle onStyleLoaded callback
  ///
  void onStyleLoaded() {
    // Add/Apply layers
  }

  /// Method to locate current location
  ///
  Future<void> locateUserCurrentLocation() async {
    final currentLoc = _ref.read(currentLocationProvider);
    await NaxaMapUtils.animateCameraToCurrentLocation(
      _controller,
      fallback: currentLoc != null
          ? LatLng(currentLoc.latitude, currentLoc.longitude)
          : null,
      zoom: 13.0,
    );
  }

  /// Method to zoom in
  ///
  Future<void> zoomIn({
    double by = 1.0,
    Duration? duration,
    Offset? focus,
  }) async {
    NaxaMapUtils.zoomIn(_controller, by: by, duration: duration, focus: focus);
  }

  /// Method to zoom out
  ///
  Future<void> zoomOut({
    double by = 1.0,
    Duration? duration,
    Offset? focus,
  }) async {
    NaxaMapUtils.zoomOut(_controller, by: by, duration: duration, focus: focus);
  }

  /// Method to animate camera to given location
  ///
  void animateTo(LatLng latLng, {double zoom = 15.0}) {
    NaxaMapUtils.animateCameraToLatLng(
      _controller,
      latLng,
      zoom: zoom,
    );
  }
}
