import 'package:dio/dio.dart';

import '../../../../core/services/network/typedefs/response_or_exception.dart';
import '../models/fcm_device_added_or_updated_response.dart';
import '../models/fcm_device_check_response.dart';

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
  Future<EitherResponseOrException<FcmDeviceCheckResponse>>
      checkIfDeviceAlreadyRegistered({
    required int? userId,
    bool forceRefresh = true,
    CancelToken? cancelToken,
  });

  /// Method to register or update fcm device
  ///
  Future<EitherResponseOrException<FcmDeviceAddedOrUpdatedResponse>>
      registerOrUpdateFcmDevice({
    required Map<String, dynamic> payloads,
    int? deviceId, // Just for update
    bool update = false,
    CancelToken? cancelToken,
  });
}
