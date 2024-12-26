class LocationCoordinate {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;

  const LocationCoordinate(
    this.latitude,
    this.longitude, {
    this.accuracy,
    this.altitude,
    this.speed,
  });

  factory LocationCoordinate.fromLngLat(double longitude, double latitude) =>
      LocationCoordinate(latitude, longitude);

  factory LocationCoordinate.fromLatLng(double latitude, double longitude) =>
      LocationCoordinate(latitude, longitude);
}
