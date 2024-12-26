import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';

final locationServiceProvider = StateProvider<LocationService>((ref) {
  return LocationService.instance;
});
