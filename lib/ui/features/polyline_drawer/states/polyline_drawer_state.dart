import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

import '../models/polyline_drawing_event.dart';

class PolylineDrawerState {
  final bool isMapReady;
  final List<LatLng> points;
  final Line? polyline;
  final List<Circle> circles;

  /// List for storing histories for user events
  ///
  final List<PolylineDrawingEvent> histories;

  /// List for storing undo histories for handling redo
  ///
  final List<PolylineDrawingEvent> historiesOfUndo;

  /// Flag to control drawing of polyline
  ///
  final bool drawable;

  PolylineDrawerState({
    this.isMapReady = false,
    this.points = const [],
    this.polyline,
    this.circles = const [],
    this.histories = const [],
    this.historiesOfUndo = const [],
    this.drawable = false,
  });

  PolylineDrawerState copy({
    bool? isMapReady,
    List<LatLng>? points,
    Line? polyline,
    List<Circle>? circles,
    List<PolylineDrawingEvent>? histories,
    List<PolylineDrawingEvent>? historiesOfUndo,
    bool? drawable,
  }) {
    return PolylineDrawerState(
      isMapReady: isMapReady ?? this.isMapReady,
      points: points ?? this.points,
      polyline: polyline == null
          ? this.polyline
          : polyline.id.isEmpty
              ? null
              : polyline,
      circles: circles ?? this.circles,
      histories: histories ?? this.histories,
      historiesOfUndo: historiesOfUndo ?? this.historiesOfUndo,
      drawable: drawable ?? this.drawable,
    );
  }
}
