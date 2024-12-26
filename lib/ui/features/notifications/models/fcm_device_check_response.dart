class FcmDeviceCheckResponse {
  FcmDeviceCheckResponse({
    this.hasFcmToken = false,
    this.fcmDeviceId,
    this.fcmRegistrationToken,
  });

  final bool hasFcmToken;
  final int? fcmDeviceId;
  final String? fcmRegistrationToken;

  FcmDeviceCheckResponse copyWith({
    bool? hasFcmToken,
    int? fcmDeviceId,
    String? fcmRegistrationToken,
  }) {
    return FcmDeviceCheckResponse(
      hasFcmToken: hasFcmToken ?? this.hasFcmToken,
      fcmDeviceId: fcmDeviceId ?? this.fcmDeviceId,
      fcmRegistrationToken: fcmRegistrationToken ?? this.fcmRegistrationToken,
    );
  }

  factory FcmDeviceCheckResponse.fromJson(Map<String, dynamic> json) {
    return FcmDeviceCheckResponse(
      hasFcmToken:
          json["has_fcm_token"] is bool ? json["has_fcm_token"] : false,
      fcmDeviceId: json["fcm_device_id"],
      fcmRegistrationToken: json["fcm_registration_token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "has_fcm_token": hasFcmToken,
        "fcm_device_id": fcmDeviceId,
        "fcm_registration_token": fcmRegistrationToken,
      };

  @override
  String toString() {
    return "$hasFcmToken, $fcmDeviceId, $fcmRegistrationToken, ";
  }
}
