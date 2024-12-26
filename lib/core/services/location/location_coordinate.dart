class LocationCoordinate {
  final double latitude;
  final double longitude;

  const LocationCoordinate(this.latitude, this.longitude);

  factory LocationCoordinate.fromLngLat(double longitude, double latitude) =>
      LocationCoordinate(latitude, longitude);

  factory LocationCoordinate.fromLatLng(double latitude, double longitude) =>
      LocationCoordinate(latitude, longitude);
}
