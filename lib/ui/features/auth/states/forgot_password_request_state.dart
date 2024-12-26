import '../models/forget_password_response.dart';

class ForgotPasswordRequestState {
  final bool requesting;
  final String? error;
  final ForgotPasswordResponse? response;

  ForgotPasswordRequestState({
    this.requesting = false,
    this.error,
    this.response,
  });

  /// Method to copy
  ForgotPasswordRequestState copy({
    bool? requesting,
    String? error,
    ForgotPasswordResponse? response,
  }) {
    return ForgotPasswordRequestState(
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
