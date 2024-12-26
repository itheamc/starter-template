import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage/storage_keys.dart';
import '../../../../core/services/storage/storage_service_provider.dart';

final userLoggedInStateProvider = StateProvider.autoDispose<bool>((ref) {
  final storageService = ref.read(storageServiceProvider);

  final token = storageService.get(
    StorageKeys.loggedInUserToken,
    defaultValue: '',
  );

  final userId = storageService.get(
    StorageKeys.loggedInUserId,
  );

  return token is String &&
      token.trim().isNotEmpty &&
      userId is int &&
      userId > 0;
});
