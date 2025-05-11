import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

class LocationPickerState {
  final bool isMapReady;
  final bool isCameraMoving;
  final bool isCameraIdle;
  final LatLng? position;

  LocationPickerState({
    this.isMapReady = false,
    this.isCameraMoving = false,
    this.isCameraIdle = true,
    this.position,
  });

  LocationPickerState copy({
    bool? isMapReady,
    bool? isCameraMoving,
    bool? isCameraIdle,
    LatLng? position,
  }) {
    return LocationPickerState(
      isMapReady: isMapReady ?? this.isMapReady,
      isCameraMoving: isCameraMoving ?? this.isCameraMoving,
      isCameraIdle: isCameraIdle ?? this.isCameraIdle,
      position: position ?? this.position,
    );
  }
}
