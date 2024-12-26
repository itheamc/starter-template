import 'package:dio/dio.dart';

import '../typedef/fcm_device_add_or_update_response_or_exception.dart';
import '../typedef/fcm_device_check_response_or_exception.dart';

abstract class NotificationRepository {
  ///  Base endpoint path for checking if fcm device already added or not
  ///
  String get path4CheckingFcmDevicesAlreadyAddedOrNot;

  /// Endpoint for register fcm device
  ///
  String get path4registerFcmDevice;

  ///  Endpoint path for updating fcm device
  ///
  String get path4UpdateFcmDevice;

  /// Method to check if fcm device is already registered or not
  ///
  Future<EitherFcmDeviceCheckResponseOrException>
      checkIfDeviceAlreadyRegistered({
    required int? userId,
    bool forceRefresh = true,
    CancelToken? cancelToken,
  });

  /// Method to register or update fcm device
  ///
  Future<EitherFcmDeviceAddedOrUpdatedResponseOrException>
      registerOrUpdateFcmDevice({
    required Map<String, dynamic> payloads,
    int? deviceId, // Just for update
    bool update = false,
    CancelToken? cancelToken,
  });
}
