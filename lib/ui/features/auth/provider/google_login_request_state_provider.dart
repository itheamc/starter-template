import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/services/storage/storage_keys.dart';
import '../../../../core/services/storage/storage_service_provider.dart';
import '../models/login_response.dart';
import '../repository/auth_repository.dart';
import '../states/login_request_state.dart';
import 'auth_repository_provider.dart';

final googleLoginRequestStateProvider =
    StateNotifierProvider<GoogleLoginRequestStateNotifier, LoginRequestState>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return GoogleLoginRequestStateNotifier(
      LoginRequestState(),
      repository,
      ref,
    );
  },
);

/// GoogleLoginRequestStateNotifier
///
class GoogleLoginRequestStateNotifier extends StateNotifier<LoginRequestState> {
  GoogleLoginRequestStateNotifier(
    super.state,
    this._repository,
    this._ref,
  );

  /// Auth Repository
  ///
  final AuthRepository _repository;

  /// Ref
  ///
  final Ref<LoginRequestState> _ref;

  /// Method to handle login with google
  ///
  Future<void> login({
    CancelToken? cancelToken,
    void Function(bool success)? onCompleted,
  }) async {
    // Update state
    if (mounted) {
      state = LoginRequestState(
        requesting: true,
      );
    }

    final response = await _repository.googleLogin(
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

        // Store user data to local storage
        await _storeUserData(r);

        // Trigger on completed callback
        onCompleted?.call(true);
      },
    );
  }

  /// Method to store user data to the hive
  ///
  Future<void> _storeUserData(LoginResponse response) async {
    if (mounted) {
      final storageService = _ref.read(storageServiceProvider);

      if (response.token != null) {
        await storageService.set(StorageKeys.loggedInUserToken, response.token);
        await storageService.set(StorageKeys.loggedInUserId, response.userId);
        await storageService.set(
            StorageKeys.loggedInUserProfileId, response.profileId);
        await storageService.set(StorageKeys.loggedInUserEmail, response.email);
        await storageService.set(
            StorageKeys.loggedInUserUsername, response.username);
      }
    }
  }
}
