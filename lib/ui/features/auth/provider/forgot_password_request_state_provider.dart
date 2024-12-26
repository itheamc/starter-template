import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../repository/auth_repository.dart';
import '../states/forgot_password_request_state.dart';
import 'auth_repository_provider.dart';

final forgotPasswordRequestStateProvider = StateNotifierProvider<
    ForgotPasswordRequestStateNotifier, ForgotPasswordRequestState>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return ForgotPasswordRequestStateNotifier(
      ForgotPasswordRequestState(),
      repository,
    );
  },
);

/// ForgotPasswordRequestStateNotifier
///
class ForgotPasswordRequestStateNotifier
    extends StateNotifier<ForgotPasswordRequestState> {
  ForgotPasswordRequestStateNotifier(
    super.state,
    this._repository,
  );

  /// Auth Repository
  ///
  final AuthRepository _repository;

  /// Method to handle forgot password
  ///
  Future<void> forgotPassword({
    required Map<String, dynamic> payloads,
    CancelToken? cancelToken,
    void Function(bool success)? onCompleted,
  }) async {
    // Update state
    if (mounted) {
      state = ForgotPasswordRequestState(
        requesting: true,
      );
    }

    // Getting response from the network or cache
    final response = await _repository.forgetPassword(
      payloads: payloads,
      cancelToken: cancelToken,
    );

    // After getting response
    response.fold(
      (l) {
        if (mounted) {
          state = state.copy(
            requesting: false,
            error: l.message,
          );
        }

        // Trigger on completed callback
        onCompleted?.call(false);

        // Showing toast message in case of error
        if (l.message != null) Fluttertoast.showToast(msg: l.message!);
      },
      (r) async {
        if (mounted) {
          state = state.copy(
            requesting: false,
            error: '',
            response: r,
          );
        }

        // Showing toast message in case of error
        if (r.message != null) Fluttertoast.showToast(msg: r.message!);

        // Trigger on completed callback
        onCompleted?.call(true);
      },
    );
  }
}
