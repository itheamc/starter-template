import '../models/register_response.dart';

class RegisterRequestState {
  final bool requesting;
  final String? error;
  final Map<String, dynamic> payloads; // To store register screen fields data
  final Map<String, dynamic> files; // To store register screen image field data
  final RegisterResponse? response;

  RegisterRequestState({
    this.requesting = false,
    this.error,
    this.payloads = const {},
    this.files = const {},
    this.response,
  });

  /// Method to copy
  RegisterRequestState copy({
    bool? requesting,
    String? error,
    Map<String, dynamic>? payloads,
    Map<String, dynamic>? files,
    RegisterResponse? response,
  }) {
    return RegisterRequestState(
      requesting: requesting ?? this.requesting,
      error: error != null
          ? error.isEmpty
              ? null
              : error
          : this.error,
      payloads: payloads ?? this.payloads,
      files: files ?? this.files,
      response: response ?? this.response,
    );
  }
}
