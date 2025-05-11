import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

import '../states/location_picker_state.dart';

final locationPickerStateProvider = StateNotifierProvider.autoDispose<
    LocationPickerStateNotifier, LocationPickerState>(
  (ref) {
    return LocationPickerStateNotifier(
      LocationPickerState(),
    );
  },
);

class LocationPickerStateNotifier extends StateNotifier<LocationPickerState> {
  LocationPickerStateNotifier(super.state);

  /// MapLibreMapController
  MapLibreMapController? _mapController;

  /// Method for onMapCreated callback
  ///
  void onMapCreated(MapLibreMapController controller, {LatLng? latLng}) {
    _mapController = controller;
    _mapController?.addListener(_cameraPositionListener);
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) {
        state = state.copy(
          isMapReady: true,
        );
      }
    }).then((v) {
      if (latLng != null) {
        NaxaMapUtils.animateCameraToLatLng(_mapController, latLng, zoom: 16);
      } else {
        NaxaMapUtils.animateCameraToCurrentLocation(_mapController, zoom: 16);
      }
    });
  }

  /// OnStyleLoaded callback
  ///
  void onStyleLoadedCallback({LatLng? latLng}) {}

  /// Method for camera position change listener
  ///
  void _cameraPositionListener() {
    if (mounted && state.isCameraMoving != _mapController?.isCameraMoving) {
      state = state.copy(
        isCameraMoving: _mapController?.isCameraMoving ?? false,
        position: _mapController?.cameraPosition?.target,
      );
    }
  }

  @override
  void dispose() {
    _mapController?.removeListener(_cameraPositionListener);
    super.dispose();
  }
}
