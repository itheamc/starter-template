import '../models/login_response.dart';

class LoginRequestState {
  final bool requesting;
  final String? error;
  final LoginResponse? response;

  LoginRequestState({
    this.requesting = false,
    this.error,
    this.response,
  });

  /// Method to copy
  LoginRequestState copy({
    bool? requesting,
    String? error,
    LoginResponse? response,
  }) {
    return LoginRequestState(
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
