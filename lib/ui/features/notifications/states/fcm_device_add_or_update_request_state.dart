import '../models/fcm_device_added_or_updated_response.dart';

class FcmDeviceAddOrUpdateRequestState {
  final bool requesting;
  final String? error;
  final FcmDeviceAddedOrUpdatedResponse? response;

  FcmDeviceAddOrUpdateRequestState({
    this.requesting = false,
    this.error,
    this.response,
  });

  /// Method to copy
  FcmDeviceAddOrUpdateRequestState copy({
    bool? requesting,
    String? error,
    FcmDeviceAddedOrUpdatedResponse? response,
  }) {
    return FcmDeviceAddOrUpdateRequestState(
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
