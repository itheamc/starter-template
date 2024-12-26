import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage/storage_keys.dart';
import '../../../../core/services/storage/storage_service_provider.dart';

final loggedInUserIdProvider = StateProvider<int?>((ref) {
  final storageService = ref.read(storageServiceProvider);

  final userId = storageService.get(
    StorageKeys.loggedInUserId,
  );

  return userId is int ? userId : null;
});
