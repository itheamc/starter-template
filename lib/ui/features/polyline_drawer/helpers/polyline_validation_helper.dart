import 'dart:math';

import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

class PolylineValidationHelper {
  PolylineValidationHelper._();

  /// Checks if adding the point to the polygon would create any self-intersections
  ///
  /// - [point] The new point to check
  /// - [polygonPoints] The existing polygon points
  /// - [onInvalid] Optional callback for when an intersection is found
  /// - [index] Optional index of the point in case of dragging existing point
  /// Return true if adding the point would create a self-intersection, false otherwise
  ///
  static bool wouldPointCreateSelfIntersection(
    LatLng point,
    List<LatLng> polygonPoints, [
    void Function(String)? onInvalid,
    int? index,
  ]) {
    // Need at least 3 points to form a polygon
    if (polygonPoints.length < 2) return false;

    // Create temp points list
    final points = [...polygonPoints];

    // Create a new array with the point added to the polygon
    if (index != null && index < points.length) {
      points.removeAt(index);
      points.insert(index, point);
    } else {
      points.add(point);
    }

    final n = points.length;

    // Small epsilon value to handle floating-point comparisons
    const double epsilon = 1e-9;

    // Check each edge pair for intersection
    for (int i = 0; i < n; i++) {
      // Define first edge points (i to i+1, with wrapping)
      final p1 = points[i];
      final p2 = points[(i + 1) % n];

      // Line segment 1 coordinates
      final x1 = p1.longitude;
      final y1 = p1.latitude;
      final x2 = p2.longitude;
      final y2 = p2.latitude;

      // Bounding box for first line segment
      final minx1 = min(x1, x2);
      final maxx1 = max(x1, x2);
      final miny1 = min(y1, y2);
      final maxy1 = max(y1, y2);

      for (int j = i + 2; j < n + (i == 0 ? -1 : 1); j++) {
        // Define second edge points (j to j+1, with wrapping)
        final j1 = j % n;
        final j2 = (j + 1) % n;

        // Skip if shares endpoint with the first edge
        if (j2 == i || j1 == (i + 1) % n) continue;

        // Line segment 2 coordinates
        final x3 = points[j1].longitude;
        final y3 = points[j1].latitude;
        final x4 = points[j2].longitude;
        final y4 = points[j2].latitude;

        // Quick check 1: Skip if they share a vertex (adjacent edges)
        double diffX1X3 = x1 - x3;
        double diffY1Y3 = y1 - y3;
        double diffX2X4 = x2 - x4;
        double diffY2Y4 = y2 - y4;
        double diffX1X4 = x1 - x4;
        double diffY1Y4 = y1 - y4;
        double diffX2X3 = x2 - x3;
        double diffY2Y3 = y2 - y3;

        if ((diffX1X3 > -epsilon &&
                diffX1X3 < epsilon &&
                diffY1Y3 > -epsilon &&
                diffY1Y3 < epsilon) ||
            (diffX2X4 > -epsilon &&
                diffX2X4 < epsilon &&
                diffY2Y4 > -epsilon &&
                diffY2Y4 < epsilon) ||
            (diffX1X4 > -epsilon &&
                diffX1X4 < epsilon &&
                diffY1Y4 > -epsilon &&
                diffY1Y4 < epsilon) ||
            (diffX2X3 > -epsilon &&
                diffX2X3 < epsilon &&
                diffY2Y3 > -epsilon &&
                diffY2Y3 < epsilon)) {
          continue;
        }

        // Quick check 2: Bounding box test (optimization)
        final minx2 = min(x3, x4);
        final maxx2 = max(x3, x4);
        final miny2 = min(y3, y4);
        final maxy2 = max(y3, y4);

        if (minx1 > maxx2 + epsilon ||
            maxx1 < minx2 - epsilon ||
            miny1 > maxy2 + epsilon ||
            maxy1 < miny2 - epsilon) {
          continue;
        }

        // Line intersection test using parametric equation
        final dx1 = x2 - x1;
        final dy1 = y2 - y1;
        final dx2 = x4 - x3;
        final dy2 = y4 - y3;
        final dx3 = x1 - x3;
        final dy3 = y1 - y3;

        final denominator = dy2 * dx1 - dx2 * dy1;

        // Skip if lines are parallel or collinear
        if (denominator > -epsilon && denominator < epsilon) continue;

        final t1 = (dx2 * dy3 - dy2 * dx3) / denominator;
        final t2 = (dx1 * dy3 - dy1 * dx3) / denominator;

        // Check if intersection occurs within both line segments
        if (t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1) {
          onInvalid?.call("Adding this point would create a self-intersection");
          return true;
        }
      }
    }

    return false;
  }

  /// Function to convert degrees to radians
  ///
  static double _deg2Rad(double degrees) {
    return degrees * (pi / 180.0);
  }

  /// Function to calculate the distance between two points using the Haversine formula
  ///
  static double haversineDistance(List<LatLng> line) {
    // Radius of the Earth in kilometers
    const double earthRadius = 6371.0;

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = _deg2Rad(line.first.latitude);
    double lon1Rad = _deg2Rad(line.first.longitude);
    double lat2Rad = _deg2Rad(line.last.latitude);
    double lon2Rad = _deg2Rad(line.last.longitude);

    // Calculate the differences
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    // Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculate the distance
    return earthRadius * c;
  }
}

extension LatLngListExt on List<LatLng> {
  LatLng get center {
    return LatLng(
      (first.latitude + last.latitude) / 2,
      (first.longitude + last.longitude) / 2,
    );
  }
}
