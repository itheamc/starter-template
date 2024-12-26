import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/register_response.dart';
import '../repository/auth_repository.dart';
import '../states/register_request_state.dart';
import 'auth_repository_provider.dart';

final registerRequestStateProvider =
    StateNotifierProvider<RegisterRequestStateNotifier, RegisterRequestState>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return RegisterRequestStateNotifier(
      RegisterRequestState(),
      repository,
    );
  },
);

/// RegisterRequestStateNotifier
///
class RegisterRequestStateNotifier extends StateNotifier<RegisterRequestState> {
  RegisterRequestStateNotifier(
    super.state,
    this._repository,
  );

  /// Auth Repository
  ///
  final AuthRepository _repository;

  /// Method to handle register
  ///
  Future<void> register({
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    CancelToken? cancelToken,
    void Function(RegisterResponse?)? onCompleted,
  }) async {
    // Update state
    if (mounted) {
      state = RegisterRequestState(
        requesting: true,
        payloads: state.payloads,
        files: state.files,
      );
    }

    // Getting response from the network or cache
    final response = await _repository.register(
      payloads: payloads,
      medias: medias,
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
        onCompleted?.call(null);

        // Showing toast message in case of error
        if (l.message != null) Fluttertoast.showToast(msg: l.message!);
      },
      (r) async {
        if (mounted) {
          state = state.copy(
            requesting: false,
            error: '',
            response: r,
            payloads: {},
            files: {},
          );
        }

        // Trigger on completed callback
        onCompleted?.call(r);
      },
    );
  }
}
