import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/provider/logged_in_user_profile_id_provider.dart';
import '../models/user_profile.dart';
import '../repository/user_profile_repository.dart';
import '../states/user_profile_state.dart';
import 'user_profile_repository_provider.dart';

final userProfileStateProvider =
    StateNotifierProvider<UserProfileStateNotifier, UserProfileState>(
  (ref) {
    final repository = ref.read(userProfileRepositoryProvider);
    return UserProfileStateNotifier(
      UserProfileState(),
      repository,
      ref,
    );
  },
);

/// UserProfileStateNotifier
///
class UserProfileStateNotifier extends StateNotifier<UserProfileState> {
  UserProfileStateNotifier(
    super.state,
    this._repository,
    this._ref,
  );

  /// Profile Repository
  ///
  final UserProfileRepository _repository;

  /// Ref
  ///
  final Ref<UserProfileState> _ref;

  /// Method to get the user profile
  ///
  Future<void> fetchProfile({
    int? profileId,
    bool forceRefresh = true,
    CancelToken? cancelToken,
    void Function(UserProfile?)? onCompleted,
  }) async {
    profileId ??= _ref.refresh(loggedInUserProfileIdProvider);

    if (profileId == null) {
      onCompleted?.call(null);
      return;
    }

    // Update state
    if (mounted) {
      state = UserProfileState(
        fetching: true,
      );
    }

    // Making request to fetch the form
    final response = await _repository.fetchProfile(
      profileId: profileId,
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );

    // After getting response
    response.fold(
      (l) {
        if (mounted) {
          state = state.copy(
            fetching: false,
            error: l.message,
          );
        }

        // Trigger onCompleted callback
        onCompleted?.call(null);
      },
      (r) async {
        if (mounted) {
          state = state.copy(
            fetching: false,
            error: '',
            profile: r,
          );
        }

        // Trigger onCompleted callback
        onCompleted?.call(r);
      },
    );
  }

  ///Method to update the user profile
  ///
  Future<void> updateUserProfile({
    required int? profileId,
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    bool forceRefresh = true,
    CancelToken? cancelToken,
    void Function(UserProfile?)? onCompleted,
  }) async {
    profileId ??= _ref.refresh(loggedInUserProfileIdProvider);

    //cached user state profile details to be shown in case of error
    final userDetails = state.profile;

    if (profileId == null) {
      onCompleted?.call(null);
      return;
    }

    // Update state
    if (mounted) {
      state = UserProfileState(
        isUpdating: true,
      );
    }

    //Making the request to update the profile
    final response = await _repository.updateProfile(
      profileId: profileId,
      payloads: payloads,
      medias: medias,
    );

    // After getting response
    response.fold(
      (l) {
        if (mounted) {
          state = state.copy(
            isUpdating: false,
            profile: userDetails,
            error: l.message,
          );
        }

        // Trigger onCompleted callback
        onCompleted?.call(null);
      },
      (r) async {
        if (mounted) {
          state = state.copy(
            isUpdating: false,
            error: '',
            profile: r,
          );
        }

        // Trigger onCompleted callback
        onCompleted?.call(r);
      },
    );
  }
}
