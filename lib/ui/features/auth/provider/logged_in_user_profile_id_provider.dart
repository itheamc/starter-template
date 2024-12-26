import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage/storage_keys.dart';
import '../../../../core/services/storage/storage_service_provider.dart';

final loggedInUserProfileIdProvider = StateProvider<int?>((ref) {
  final storageService = ref.read(storageServiceProvider);

  final profileId = storageService.get(
    StorageKeys.loggedInUserProfileId,
  );

  return profileId is int ? profileId : null;
});
