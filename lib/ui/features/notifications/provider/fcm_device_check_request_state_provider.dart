import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/provider/logged_in_user_id_provider.dart';
import '../models/fcm_device_check_response.dart';
import '../repository/notification_repository.dart';
import '../states/fcm_device_check_request_state.dart';
import 'notification_repository_provider.dart';

final fcmDeviceCheckRequestStateProvider = StateNotifierProvider<
    FcmDeviceCheckRequestStateNotifier, FcmDeviceCheckRequestState>(
  (ref) {
    final repository = ref.read(notificationRepositoryProvider);
    return FcmDeviceCheckRequestStateNotifier(
      FcmDeviceCheckRequestState(),
      repository,
      ref,
    );
  },
);

/// FcmDeviceCheckRequestStateNotifier
///
class FcmDeviceCheckRequestStateNotifier
    extends StateNotifier<FcmDeviceCheckRequestState> {
  FcmDeviceCheckRequestStateNotifier(
    super.state,
    this._repository,
    this._ref,
  );

  /// Notification Repository
  ///
  final NotificationRepository _repository;

  /// Ref
  ///
  final Ref<FcmDeviceCheckRequestState> _ref;

  /// Method to check if device is already registered or not
  ///
  Future<void> checkIfDeviceIsAlreadyRegisteredOrNot({
    bool forceRefresh = true,
    CancelToken? cancelToken,
    void Function(FcmDeviceCheckResponse? response)? onCompleted,
  }) async {
    // Update state
    if (mounted) {
      state = FcmDeviceCheckRequestState(
        requesting: true,
      );
    }

    // Getting response from the network or cache
    final response = await _repository.checkIfDeviceAlreadyRegistered(
      userId: _ref.refresh(loggedInUserIdProvider),
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );

    // After getting response
    response.fold(
      (l) {
        if (mounted) {
          state = state.copy(
            requesting: false,
            error: l.message,
          );
        }

        // Trigger on completed callback
        onCompleted?.call(null);
      },
      (r) async {
        if (mounted) {
          state = state.copy(
            requesting: false,
            error: '',
            response: r,
          );
        }

        // Trigger on completed callback
        onCompleted?.call(r);
      },
    );
  }
}
