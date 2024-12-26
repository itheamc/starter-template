import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage/storage_keys.dart';
import '../../../../core/services/storage/storage_service_provider.dart';

final isAlreadyOnboardedProvider = StateProvider<bool>((ref) {
  final storageService = ref.read(storageServiceProvider);

  final isAlreadyOnboarded = storageService.get(
    StorageKeys.alreadyOnboarded,
    defaultValue: false,
  );

  return isAlreadyOnboarded;
});
