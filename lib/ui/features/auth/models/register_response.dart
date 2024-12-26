class RegisterResponse {
  RegisterResponse({
    this.message,
    this.success = false,
  });

  final String? message;
  final bool success;

  RegisterResponse copyWith({
    String? message,
    bool? success,
  }) {
    return RegisterResponse(
      message: message ?? this.message,
      success: success ?? this.success,
    );
  }

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
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
    return "$message, $success, ";
  }
}
