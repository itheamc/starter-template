import '../models/fcm_device_check_response.dart';

class FcmDeviceCheckRequestState {
  final bool requesting;
  final String? error;
  final FcmDeviceCheckResponse? response;

  FcmDeviceCheckRequestState({
    this.requesting = false,
    this.error,
    this.response,
  });

  /// Method to copy
  FcmDeviceCheckRequestState copy({
    bool? requesting,
    String? error,
    FcmDeviceCheckResponse? response,
  }) {
    return FcmDeviceCheckRequestState(
      requesting: requesting ?? this.requesting,
      error: error != null
          ? error.isEmpty
              ? null
              : error
          : this.error,
      response: response ?? this.response,
    );
  }
}
