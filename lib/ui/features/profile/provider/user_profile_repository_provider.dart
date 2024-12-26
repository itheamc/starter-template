import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/network/http_service_provider.dart';
import '../repository/user_profile_repository.dart';
import '../repository/user_profile_repository_impl.dart';

final userProfileRepositoryProvider = StateProvider<UserProfileRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);

  return UserProfileRepositoryImpl(httpService);
});
