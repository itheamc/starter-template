import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/network/http_service_provider.dart';
import '../repository/notification_repository.dart';
import '../repository/notification_repository_impl.dart';

final notificationRepositoryProvider =
    StateProvider<NotificationRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);

  return NotificationRepositoryImpl(httpService);
});
