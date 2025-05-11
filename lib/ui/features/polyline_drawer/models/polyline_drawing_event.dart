import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

enum PolylineDrawingEventType { add, remove, drag }

class PolylineDrawingEvent {
  final int index;
  final LatLng point;
  final PolylineDrawingEventType type;

  PolylineDrawingEvent({
    required this.index,
    required this.point,
    required this.type,
  });

  PolylineDrawingEvent copy({
    int? index,
    LatLng? point,
    PolylineDrawingEventType? type,
  }) =>
      PolylineDrawingEvent(
        index: index ?? this.index,
        point: point ?? this.point,
        type: type ?? this.type,
      );
}
