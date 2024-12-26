import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/fcm_device_added_or_updated_response.dart';
import '../repository/notification_repository.dart';
import '../states/fcm_device_add_or_update_request_state.dart';
import 'fcm_device_check_request_state_provider.dart';
import 'notification_repository_provider.dart';

final fcmDeviceAddOrUpdateRequestStateProvider = StateNotifierProvider<
    FcmDeviceAddOrUpdateRequestStateNotifier, FcmDeviceAddOrUpdateRequestState>(
  (ref) {
    final repository = ref.read(notificationRepositoryProvider);
    return FcmDeviceAddOrUpdateRequestStateNotifier(
      FcmDeviceAddOrUpdateRequestState(),
      repository,
      ref,
    );
  },
);

/// FcmDeviceAddOrUpdateRequestStateNotifier
///
class FcmDeviceAddOrUpdateRequestStateNotifier
    extends StateNotifier<FcmDeviceAddOrUpdateRequestState> {
  FcmDeviceAddOrUpdateRequestStateNotifier(
    super.state,
    this._repository,
    this._ref,
  );

  /// Notification Repository
  ///
  final NotificationRepository _repository;

  /// Ref
  ///
  final Ref<FcmDeviceAddOrUpdateRequestState> _ref;

  /// Method to add or update fcm device
  ///
  Future<void> addOrUpdateFcmDevice({
    required String token,
    bool forceRefresh = true,
    CancelToken? cancelToken,
    void Function(bool success)? onCompleted,
  }) async {
    // Update state
    state = FcmDeviceAddOrUpdateRequestState(
      requesting: true,
    );

    // Checking fcm device registered or not
    _ref
        .read(fcmDeviceCheckRequestStateProvider.notifier)
        .checkIfDeviceIsAlreadyRegisteredOrNot(
          forceRefresh: forceRefresh,
          cancelToken: cancelToken,
          onCompleted: (res) async {
            // If provider is unmounted during device check or res is null return from here
            if (!mounted || res == null) return;

            // Else register or update
            final payloads = <String, dynamic>{};

            // Device Info
            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            AndroidDeviceInfo? androidInfo;
            IosDeviceInfo? iosInfo;

            try {
              if (Platform.isAndroid) {
                androidInfo = await deviceInfo.androidInfo;
              }
              if (Platform.isIOS) {
                iosInfo = await deviceInfo.iosInfo;
              }
            } catch (e) {
              if (kDebugMode) print(e.toString());
            }

            final name = androidInfo?.device ?? iosInfo?.name;
            final model = androidInfo?.model ?? iosInfo?.model;
            final brand = androidInfo?.brand;

            payloads['name'] =
                '${name ?? ''}${model != null ? '_$model' : ''}${brand != null ? '_$brand' : ''}';
            payloads['registration_id'] = token;
            payloads['device_id'] =
                androidInfo?.id ?? iosInfo?.identifierForVendor ?? '';
            payloads['type'] = Platform.isIOS ? "ios" : "android";
            payloads['active'] = true;

            // If not already registered
            if (res.hasFcmToken) {
              await _updateDevice(
                deviceId: res.fcmDeviceId,
                payloads: payloads,
                forceRefresh: true,
                cancelToken: cancelToken,
                onCompleted: (res) {
                  if (mounted) {
                    state = state.copy(
                      requesting: false,
                      response: res,
                    );
                  }
                },
              );
            } else {
              await _registerDevice(
                payloads: payloads,
                forceRefresh: true,
                cancelToken: cancelToken,
                onCompleted: (res) {
                  if (mounted) {
                    state = state.copy(
                      requesting: false,
                      response: res,
                    );
                  }
                },
              );
            }
          },
        );
  }

  /// Method to add fcm device
  ///
  Future<void> _registerDevice({
    required Map<String, dynamic> payloads,
    bool forceRefresh = true,
    CancelToken? cancelToken,
    void Function(FcmDeviceAddedOrUpdatedResponse? res)? onCompleted,
  }) async {
    // Getting response from the network or cache
    final response = await _repository.registerOrUpdateFcmDevice(
      payloads: payloads,
      cancelToken: cancelToken,
      update: false,
    );

    // After getting response
    response.fold(
      (l) {
        // Trigger on completed callback
        onCompleted?.call(null);
      },
      (r) async {
        // Trigger on completed callback
        onCompleted?.call(r);
      },
    );
  }

  /// Method to update fcm device
  ///
  Future<void> _updateDevice({
    required int? deviceId,
    required Map<String, dynamic> payloads,
    bool forceRefresh = true,
    CancelToken? cancelToken,
    void Function(FcmDeviceAddedOrUpdatedResponse? res)? onCompleted,
  }) async {
    // Getting response from the network or cache
    final response = await _repository.registerOrUpdateFcmDevice(
      deviceId: deviceId,
      payloads: payloads,
      cancelToken: cancelToken,
    );

    // After getting response
    response.fold(
      (l) {
        // Trigger on completed callback
        onCompleted?.call(null);
      },
      (r) async {
        // Trigger on completed callback
        onCompleted?.call(r);
      },
    );
  }
}
