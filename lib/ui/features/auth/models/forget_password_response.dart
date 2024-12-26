class ForgotPasswordResponse {
  ForgotPasswordResponse({
    this.message,
    this.success = false,
  });

  final String? message;
  final bool success;

  ForgotPasswordResponse copyWith({
    String? message,
    bool? success,
  }) {
    return ForgotPasswordResponse(
      message: message ?? this.message,
      success: success ?? this.success,
    );
  }

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json["message"] ??
          json['Message'] ??
          json['Details'] ??
          json['details'],
      success: json["success"] is bool ? json['success'] : false,
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };

  @override
  String toString() {
    return "$message, $success ";
  }
}
