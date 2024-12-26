import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage_service_provider.dart';
import '../../config/flavor/configuration_provider.dart';
import 'dio_http_service.dart';
import 'http_service.dart';

/// Provider that maps an [HttpService] interface to implementation
final httpServiceProvider = Provider<HttpService>((ref) {
  final configuration = ref.watch(flavorConfigurationProvider);
  final storageService = ref.watch(storageServiceProvider);

  return DioHttpService(configuration, storageService);
});
