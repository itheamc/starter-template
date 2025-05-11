import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/polyline_drawer_state.dart';
import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';
import '../models/polyline_drawing_event.dart';

final polylineDrawerStateProvider = StateNotifierProvider.autoDispose<
    PolylineDrawerStateNotifier, PolylineDrawerState>(
  (ref) {
    return PolylineDrawerStateNotifier(
      PolylineDrawerState(),
    );
  },
);

class PolylineDrawerStateNotifier extends StateNotifier<PolylineDrawerState> {
  PolylineDrawerStateNotifier(super.state);

  /// MapLibreMapController
  ///
  MapLibreMapController? _mapController;

  /// Method for onMapCreated callback
  ///
  void onMapCreated(MapLibreMapController controller, {LatLng? latLng}) {
    _mapController = controller;
    _mapController?.onFeatureDrag.add(_handleDragging);
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) {
        state = state.copy(
          isMapReady: true,
        );
      }
    }).then((v) {
      if (latLng != null) {
        NaxaMapUtils.animateCameraToLatLng(_mapController, latLng, zoom: 16);
      }
    });
  }

  /// OnStyleLoaded callback
  ///
  void onStyleLoadedCallback({LatLng? latLng}) {}

  /// Method to enable or disable drawing
  ///
  void toggleDrawable([bool clearAll = true]) {
    state = state.copy(
      drawable: !state.drawable,
    );

    if (!clearAll) return;

    if (!state.drawable) {
      state = PolylineDrawerState(
        isMapReady: true,
      );
      _mapController?.clearLines();
      _mapController?.clearCircles();
    }
  }

  /// Method to update state with list of points
  ///
  void updateStateWithPoints(List<LatLng> points) {
    final center = _calculateCentroid(points);

    if (center != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(center, 12));
    }

    state = state.copy(
      points: [...points],
      histories: points
          .map(
            (p) => PolylineDrawingEvent(
              index: state.points.length,
              point: p,
              type: PolylineDrawingEventType.add,
            ),
          )
          .toList(),
      historiesOfUndo: [],
    );

    _drawPolyline();
    _drawCircles();
  }

  /// Method to handle on map click
  ///
  void onMapClick(Point<double> point, LatLng latLng) {
    if (!state.drawable) return;

    final points = state.points;
    if (points.any((l) =>
        l.latitude == latLng.latitude && l.longitude == latLng.longitude)) {
      return;
    }

    state = state.copy(
      points: [...points, latLng],
      histories: [
        ...state.histories,
        PolylineDrawingEvent(
          index: state.points.length,
          point: latLng,
          type: PolylineDrawingEventType.add,
        ),
      ],
    );

    _drawPolyline();
    _drawCircles();
  }

  /// Method to handle on map long click
  ///
  void onMapLongClick(Point<double> point, LatLng latLng) {
    // if (!state.drawable) return;
    //
    // final points = state.points;
    // if (points.any((l) =>
    //     l.latitude == latLng.latitude && l.longitude == latLng.longitude)) {
    //   return;
    // }
    //
    // state = state.copy(
    //   points: [...points, latLng],
    //   histories: [
    //     ...state.histories,
    //     PolylineDrawingEvent(
    //       index: state.points.length,
    //       point: latLng,
    //       type: PolylineDrawingEventType.add,
    //     ),
    //   ],
    // );
    //
    // _drawPolyline();
    // _drawCircles();
  }

  /// Method to handle point/circle dragging
  ///
  Future<void> _handleDragging(
    dynamic id, {
    required Point<double> point,
    required LatLng origin,
    required LatLng current,
    required LatLng delta,
    required DragEventType eventType,
  }) async {
    state = state.copy(
      points: state.circles
          .map((c) => c.id == id ? current : c.options.geometry)
          .nonNulls
          .toList(),
      circles: state.circles
          .map(
            (c) => c.id == id
                ? Circle(
                    c.id,
                    CircleOptions(
                      circleColor: c.options.circleColor,
                      circleOpacity: c.options.circleOpacity,
                      circleRadius: c.options.circleRadius,
                      circleStrokeColor: c.options.circleStrokeColor,
                      circleStrokeWidth: c.options.circleStrokeWidth,
                      geometry: current,
                      draggable: true,
                    ),
                    c.data,
                  )
                : c,
          )
          .nonNulls
          .toList(),
    );

    _drawPolyline();

    if (eventType == DragEventType.end) {
      final index = state.circles.indexWhere((c) => c.id == id);
      if (index > -1) {
        state = state.copy(
          histories: [
            ...state.histories,
            PolylineDrawingEvent(
              index: index,
              point: state.points[index],
              type: PolylineDrawingEventType.drag,
            ),
          ],
        );
      }
      _drawCircles();
    }
  }

  /// Method to draw polyline
  ///
  Future<void> _drawPolyline() async {
    if (state.points.isEmpty) {
      await _mapController?.clearLines();
      state = state.copy(polyline: Line("", LineOptions()));
      return;
    }

    final annotation = state.polyline != null
        ? await NaxaMapUtils.updateAnnotation<NaxaLineAnnotation>(
            _mapController,
            annotation: NaxaLineAnnotation.fromLine(state.polyline!).copy(
              options: LineOptions(
                geometry: state.points,
                lineColor: 'red',
                lineWidth: 2.5,
                lineJoin: 'round',
                lineGapWidth: 1.0,
              ),
            ),
          )
        : await NaxaMapUtils.addAnnotation<NaxaLineAnnotation>(
            _mapController,
            annotation: NaxaLineAnnotation(
              LineOptions(
                geometry: state.points,
                lineColor: 'red',
                lineWidth: 2.5,
                lineJoin: 'round',
                lineGapWidth: 1.0,
              ),
            ),
          );

    state = state.copy(
      polyline: annotation?.toLine(),
    );
  }

  /// Method to draw circles
  ///
  Future<void> _drawCircles() async {
    await _mapController?.clearCircles();

    final annotations = await Future.wait(
      state.points.map(
        (point) async => NaxaMapUtils.addAnnotation<NaxaCircleAnnotation>(
          _mapController,
          annotation: NaxaCircleAnnotation(
            CircleOptions(
              circleColor: "white",
              circleOpacity: 0.0,
              circleRadius: 5.0,
              circleStrokeColor: "red",
              circleStrokeWidth: 1.5,
              geometry: point,
              draggable: true,
            ),
          ),
        ),
      ),
    );

    state = state.copy(
      circles: annotations.nonNulls.map((e) => e.toCircle()).toList(),
    );
  }

  /// Method to handle undo
  ///
  void handleUndo() {
    if (state.points.isEmpty) {
      state = state.copy(
        histories: [],
      );
    } else {
      final points = [...state.points];

      final event = state.histories.last;

      if (event.type == PolylineDrawingEventType.add) {
        final i = event.index;
        points.removeAt(i);
      } else if (event.type == PolylineDrawingEventType.remove ||
          event.type == PolylineDrawingEventType.drag) {
        final i = event.index;
        final point = event.point;
        points.insert(i, point);
      } else {
        // Do nothing
      }

      final histories = [...state.histories];
      histories.removeLast();

      state = state.copy(
        points: [...points],
        histories: histories,
        historiesOfUndo: [
          ...state.historiesOfUndo,
          event,
        ],
      );
    }

    _drawPolyline();
    _drawCircles();
  }

  /// Method to handle redo
  ///
  void handleRedo() {
    if (state.historiesOfUndo.isEmpty) return;

    final points = [...state.points];

    final event = state.historiesOfUndo.last;

    if (event.type == PolylineDrawingEventType.add) {
      final point = event.point;
      points.add(point);
    } else if (event.type == PolylineDrawingEventType.remove) {
      final i = event.index;
      points.removeAt(i);
    } else if (event.type == PolylineDrawingEventType.drag) {
      final i = event.index;
      final point = event.point;
      points.removeAt(i);
      points.insert(i, point);
    } else {
      // Do nothing
    }

    final historiesOfUndo = [...state.historiesOfUndo];
    historiesOfUndo.removeLast();

    state = state.copy(
      points: [...points],
      historiesOfUndo: historiesOfUndo,
      histories: [
        ...state.histories,
        event,
      ],
    );

    _drawPolyline();
    _drawCircles();
  }

  /// Method to calculate centroid of given points
  ///
  LatLng? _calculateCentroid(List<LatLng> points) {
    if (points.isEmpty) return null;

    double totalLat = 0;
    double totalLng = 0;

    for (var point in points) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }

    final avgLat = totalLat / points.length;
    final avgLng = totalLng / points.length;

    return LatLng(avgLat, avgLng);
  }

  @override
  void dispose() {
    _mapController?.onFeatureDrag.clear();
    super.dispose();
  }
}
