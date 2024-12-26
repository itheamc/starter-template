import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/network/http_service_provider.dart';
import '../repository/auth_repository.dart';
import '../repository/auth_repository_impl.dart';

final authRepositoryProvider = StateProvider<AuthRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);

  return AuthRepositoryImpl(httpService);
});
